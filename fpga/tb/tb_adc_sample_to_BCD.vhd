library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library std;
use std.env.all;

entity tb_adc_sample_to_BCD is
end entity;

architecture Testbench of tb_adc_sample_to_BCD is
    -- DUT
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

    -- constant time interval
    constant T : time := 50 ns;

    -- signals to DUT
    signal adc_sample  : std_logic_vector(11 downto 0);
    signal vol         : std_logic_vector(12 downto 0);
    signal ones        : std_logic_vector(3 downto 0);
    signal tenths      : std_logic_vector(3 downto 0);
    signal hundredths  : std_logic_vector(3 downto 0);
    signal thousandths : std_logic_vector(3 downto 0);
begin
    -- instantiate DUT
    dut : adc_sample_to_BCD
    port map (
        adc_sample => adc_sample,
        vol => vol,
        ones => ones,
        tenths => tenths,
        hundredths => hundredths,
        thousandths => thousandths
    );

    -- test sequence
    tb : process
    begin
        -- verify 0 in = 0 V out
        adc_sample <= std_logic_vector(to_unsigned(0, adc_sample'length));
        wait for T;
        assert (vol = std_logic_vector(to_unsigned(0, vol'length)))
            report "adc_sample_to_BCD Error: 0 in != 0 V out"
            severity error;

        -- verify 0 V is correctly split into decimal digits
        assert (ones = "0000")
            report "adc_sample_to_BCD Error: 0 V is incorrectly converted to ones"
            severity error;

        assert (tenths = "0000")
            report "adc_sample_to_BCD Error: 0 V is incorrectly converted to tenths"
            severity error;

        assert (hundredths = "0000")
            report "adc_sample_to_BCD Error: 0 V is incorrectly converted to hundredths"
            severity error;

        assert (thousandths = "0000")
            report "adc_sample_to_BCD Error: 0 V is incorrectly converted to thousandths"
            severity error;

        -- verify 4095 in = 5 V out
        adc_sample <= std_logic_vector(to_unsigned(4095, adc_sample'length));
        wait for T;
        assert (vol = std_logic_vector(to_unsigned(5000, vol'length)))
            report "adc_sample_to_BCD Error: 4095 in != 5000 mV out"
            severity error;

        -- verify 5 V is correctly split into decimal digits
        assert (ones = "0101")
            report "adc_sample_to_BCD Error: 5 V is incorrectly converted to ones"
            severity error;

        assert (tenths = "0000")
            report "adc_sample_to_BCD Error: 5 V is incorrectly converted to tenths"
            severity error;

        assert (hundredths = "0000")
            report "adc_sample_to_BCD Error: 5 V is incorrectly converted to hundredths"
            severity error;

        assert (thousandths = "0000")
            report "adc_sample_to_BCD Error: 5 V is incorrectly converted to thousandths"
            severity error;

        -- verify 1011 in = 1.234 V out
        adc_sample <= std_logic_vector(to_unsigned(1011, adc_sample'length));
        wait for T;
        assert (vol = std_logic_vector(to_unsigned(1234, vol'length)))
            report "adc_sample_to_BCD Error: 1011 in != 1234 mV out"
            severity error;

        -- verify 1.234 V is correctly split into decimal digits
        assert (ones = "0001")
            report "adc_sample_to_BCD Error: 1.234 V is incorrectly converted to ones"
            severity error;

        assert (tenths = "0010")
            report "adc_sample_to_BCD Error: 1.234 V is incorrectly converted to tenths"
            severity error;

        assert (hundredths = "0011")
            report "adc_sample_to_BCD Error: 1.234 V is incorrectly converted to hundredths"
            severity error;

        assert (thousandths = "0100")
            report "adc_sample_to_BCD Error: 1.234 V is incorrectly converted to thousandths"
            severity error;
        stop(1);
    end process;
end architecture Testbench;
