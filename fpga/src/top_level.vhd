library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity top_level is
    port (
        -- Clocks
        ADC_CLK_10      : in std_logic;
        MAX10_CLK1_50   : in std_logic;
        MAX10_CLK2_50   : in std_logic;
        -- KEY
        KEY             : in std_logic_vector(1 downto 0);
        -- SW
        SW              : in std_logic_vector(9 downto 0);
        -- LEDR
        LEDR            : out std_logic_vector(9 downto 0);
        -- HEX
        HEX0            : out std_logic_vector(7 downto 0);
        HEX1            : out std_logic_vector(7 downto 0);
        HEX2            : out std_logic_vector(7 downto 0);
        HEX3            : out std_logic_vector(7 downto 0);
        HEX4            : out std_logic_vector(7 downto 0);
        HEX5            : out std_logic_vector(7 downto 0);
        -- SDRAM
        DRAM_CLK        : out std_logic;
        DRAM_CKE        : out std_logic;
        DRAM_ADDR       : out std_logic_vector(12 downto 0);
        DRAM_BA         : out std_logic_vector(1 downto 0);
        DRAM_DQ         : inout std_logic_vector(15 downto 0);
        DRAM_LDQM       : out std_logic;
        DRAM_UDQM       : out std_logic;
        DRAM_CS_N       : out std_logic;
        DRAM_WE_N       : out std_logic;
        DRAM_CAS_N      : out std_logic;
        DRAM_RAS_N      : out std_logic;
        -- VGA
        VGA_R           : out std_logic_vector(3 downto 0);
        VGA_G           : out std_logic_vector(3 downto 0);
        VGA_B           : out std_logic_vector(3 downto 0);
        VGA_HS          : out std_logic;
        VGA_VS          : out std_logic;
        -- GSENSOR
        GSENSOR_SCLK    : out std_logic;
        GSENSOR_SDO     : inout std_logic;
        GSENSOR_SDI     : inout std_logic;
        GSENSOR_INT     : in std_logic_vector(2 downto 1);
        GSENSOR_CS_N    : out std_logic;
        -- GPIO
        GPIO            : inout std_logic_vector(35 downto 0);
        -- ARDUINO
        ARDUINO_IO      : inout std_logic_vector(15 downto 0);
        ARDUINO_RESET_N : inout std_logic
    );
end entity;


architecture A of top_level is
    component hello_adc is
        port (
            --  adc_control_core_command.valid
            adc_control_core_command_valid          : in  std_logic;
            -- .channel
            adc_control_core_command_channel        : in  std_logic_vector(4 downto 0) := (others => '0');
            -- .startofpacket
            adc_control_core_command_startofpacket  : in  std_logic := '0';
            -- .endofpacket
            adc_control_core_command_endofpacket    : in  std_logic := '0';
            -- .ready
            adc_control_core_command_ready          : out std_logic;
            -- adc_control_core_response.valid
            adc_control_core_response_valid         : out std_logic;
            -- .channel
            adc_control_core_response_channel       : out std_logic_vector(4 downto 0);
            -- .data
            adc_control_core_response_data          : out std_logic_vector(11 downto 0);
            -- .startofpacket
            adc_control_core_response_startofpacket : out std_logic;
            -- .endofpacket
            adc_control_core_response_endofpacket   : out std_logic;
            -- clk.clk
            clk_clk                                 : in  std_logic := '0';
            -- clock_bridge_out_clk.clk
            clock_bridge_out_clk_clk                : out std_logic;
            -- reset.reset_n
            reset_reset_n                           : in  std_logic := '0'
        );
    end component hello_adc;

    component BCD_7_segment is
        port (
            -- BCD input
            BCD   : in std_logic_vector(3 downto 0);
            reset : in std_logic;

            -- 7-segment output
            seven_sig : out std_logic_vector(6 downto 0)
        );
    end component BCD_7_segment;

    component adc_sample_to_BCD is
        port (
            adc_sample  : in std_logic_vector(11 downto 0);
            vol         : out std_logic_vector(12 downto 0);
            ones        : out std_logic_vector(3 downto 0);
            tenths      : out std_logic_vector(3 downto 0);
            hundredths  : out std_logic_vector(3 downto 0);
            thousandths : out std_logic_vector(3 downto 0)
        );
    end component;

    -- ADC signals
    signal req_channel, cur_channel : std_logic_vector(4 downto 0);
    signal sample_data              : std_logic_vector(11 downto 0);
    signal adc_cc_command_ready     : std_logic;
    signal adc_cc_response_valid    : std_logic;
    signal adc_cc_response_channel  : std_logic_vector(4 downto 0);
    signal adc_cc_response_data     : std_logic_vector(11 downto 0);

    -- BCD signals
    signal ones        : std_logic_vector(3 downto 0);
    signal tenths      : std_logic_vector(3 downto 0);
    signal hundredths  : std_logic_vector(3 downto 0);
    signal thousandths : std_logic_vector(3 downto 0);

    -- system clock and reset
    signal sys_clk, nreset, reset : std_logic;
begin
    -- system reset
    reset <= not KEY(0);
    nreset <= not reset;

    -- calculate channel used for sampling
    -- Available channels on DE10-Lite are 1-6
    -- use slide switches (SW) to select the channel
    -- SW(2 downto 0) down: map to arduino ADC_IN0
    adc_command : process(sys_clk, SW, adc_cc_command_ready)
        variable temp : std_logic_vector(4 downto 0) := (others => '0');
    begin
        if rising_edge(sys_clk) then
            if (adc_cc_command_ready = '1') then
                temp(2 downto 0) := std_logic_vector(unsigned(SW(2 downto 0)) + 1);
            end if;
        end if;
        req_channel <= temp;
    end process;

    -- read the sampled value from the ADC
    adc_read : process(sys_clk, adc_cc_response_valid)
        variable reading : std_logic_vector(11 downto 0) := (others => '0');
        variable ch      : std_logic_vector(4 downto 0) := (others => '0');
    begin
        if rising_edge(sys_clk) then
            if (adc_cc_response_valid = '1') then
                reading := adc_cc_response_data;
                ch := adc_cc_response_channel;
            end if;
        end if;
        cur_channel <= ch;
        sample_data <= reading;
    end process;

    -- instantiate ADC sample to BCD converter
    adc_sample_to_BCD_conv : adc_sample_to_BCD
    port map (
        adc_sample => sample_data,
        vol => open,
        ones => ones,
        tenths => tenths,
        hundredths => hundredths,
        thousandths => thousandths
    );

    -- instantiate 7 segment displays
    hex_ones : BCD_7_segment
        port map (BCD => ones, reset => reset, seven_sig => HEX3(6 downto 0));

    hex_tenths : BCD_7_segment
        port map (BCD => tenths, reset => reset, seven_sig => HEX2(6 downto 0));

    hex_hundredths : BCD_7_segment
        port map (BCD => hundredths, reset => reset, seven_sig => HEX1(6 downto 0));

    hex_thousandths : BCD_7_segment
        port map (BCD => thousandths, reset => reset, seven_sig => HEX0(6 downto 0));

    -- enable/disable decimal points on HEX display appropriately
    HEX3(7) <= '0'; -- point enabled
    HEX2(7) <= '1'; -- point disabled
    HEX1(7) <= '1'; -- point disabled
    HEX0(7) <= '1'; -- point disabled


    -- instantiate QSYS subsystem with ADC and PLL
    qsys_u0 : component hello_adc
    port map (
        -- command always valid
        adc_control_core_command_valid => '1',
        adc_control_core_command_channel => req_channel,
        -- startofpacket and endofpacket are ignored in adc_control_core
        adc_control_core_command_startofpacket => '1',
        adc_control_core_command_endofpacket => '1',
        adc_control_core_command_ready => adc_cc_command_ready,
        adc_control_core_response_valid => adc_cc_response_valid,
        adc_control_core_response_channel => adc_cc_response_channel,
        adc_control_core_response_data => adc_cc_response_data,
        adc_control_core_response_startofpacket => open,
        adc_control_core_response_endofpacket => open,
        clk_clk => MAX10_CLK1_50,
        clock_bridge_out_clk_clk => sys_clk,
        reset_reset_n => nreset
    );
end architecture A;
