-- BCD_7_segment.vhd
-- BCD digit to 7-segment display signals
library ieee;
use ieee.std_logic_1164.all;


entity BCD_7_segment is
    port (
        -- BCD input
        BCD   : in std_logic_vector(3 downto 0);
        reset : in std_logic;
         
        -- 7-segment output
        seven_sig : out std_logic_vector(6 downto 0)
    );
end entity;


architecture A of BCD_7_segment is
    signal A, B, C, D : std_logic;
    signal seven_sig_temp: std_logic_vector(6 downto 0);
begin
    A <= BCD(3);
    B <= BCD(2);
    C <= BCD(1);
    D <= BCD(0);
    
    -- top horizontal bar
    seven_sig_temp(0) <= not ((not B and not D) or C or (B and D) or A);
    -- upper right vertical bar
    seven_sig_temp(1) <= not (not B or (not C and not D) or (C and D));
    -- lower right vertical bar
    seven_sig_temp(2) <= not (not C or D or B);
    -- bottom horizontal bar
    seven_sig_temp(3) <= not ((not B and not D) or (not B and C) or (B and not C and D) or (C and not D) or A);
    -- lower left vertical bar
    seven_sig_temp(4) <= not ((not B and not D) or (C and not D));
    -- upper left vertical bar
    seven_sig_temp(5) <= not ((not C and not D) or (B and not C) or (B and not D) or A);
    -- middle horizontal bar
    seven_sig_temp(6) <= not ((not B and C) or (B and not C) or A or (B and not D));

    seven_sig <= seven_sig_temp  when reset='0' else
                 (others => '1') when reset='1' else
                 (others => 'X');
end architecture A;
