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
            adc_sample : in std_logic_vector(11 downto 0);
            vol        : out std_logic_vector(12 downto 0)
        );
    end component;

    -- constant time interval
    constant T : time := 50 ns;

    -- signals to DUT
    signal adc_sample : std_logic_vector(11 downto 0);
    signal vol        : std_logic_vector(12 downto 0);
begin
    -- instantiate DUT
    dut : adc_sample_to_BCD
    port map (adc_sample => adc_sample, vol => vol);

    -- test sequence
    tb : process
    begin
        -- verify 0 in = 0 V out
        adc_sample <= (others => '0');
        wait for T;
        assert (vol = "0000000000000")
            report "adc_sample_to_BCD Error: 0 in != 0 V out"
            severity error;

        -- verify 4095 in = 5 V out
        adc_sample <= std_logic_vector(to_unsigned(4095, adc_sample'length));
        wait for T;
        assert (vol = std_logic_vector(to_unsigned(5000, vol'length)))
            report "adc_sample_to_BCD Error: 4095 in != 5000 mV out"
            severity error;

        stop(1);
    end process;
end architecture Testbench;
