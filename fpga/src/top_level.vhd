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
    
    -- signals

begin
--    qsys_u0 : component hello_adc
--    port map (
--        adc_control_core_command_valid
--        adc_control_core_command_channel
--        adc_control_core_command_startofpacket
--        adc_control_core_command_endofpacket
--        adc_control_core_command_ready
--        adc_control_core_response_valid
--        adc_control_core_response_channel
--        adc_control_core_response_data
--        adc_control_core_response_startofpacket
--        adc_control_core_response_endofpacket
--        clk_clk
--        clock_bridge_out_clk_clk
--        reset_reset_n
--    );
end architecture A;
