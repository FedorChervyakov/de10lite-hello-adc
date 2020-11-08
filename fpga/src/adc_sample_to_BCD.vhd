-- adc_sample_to_BCD.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity adc_sample_to_BCD is
    port (
        adc_sample : in std_logic_vector(11 downto 0);
        vol        : out std_logic_vector(12 downto 0)
    );
end entity;


architecture A of adc_sample_to_BCD is
begin
    vol <= std_logic_vector(resize(unsigned(adc_sample) * 2 * 2500 / 4095, 13));
end architecture A;
