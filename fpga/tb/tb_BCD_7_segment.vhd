library IEEE;
use IEEE.std_logic_1164.all;

library std;
use std.env.all;

entity tb_BCD_7_segment is
end entity;

architecture Testbench of tb_BCD_7_segment is
    -- DUT
    component BCD_7_segment is
        port (
            -- BCD input
            BCD   : in std_logic_vector(3 downto 0);
            reset : in std_logic;
             
            -- 7-segment output
            seven_sig : out std_logic_vector(6 downto 0)
        );
    end component;

    -- constant time interval
    constant T : time := 50 ns;

    -- signals to DUT
    signal BCD   : std_logic_vector(3 downto 0);
    signal reset : std_logic;

    signal seven_sig : std_logic_vector(6 downto 0);
begin
    -- instantiate DUT
    dut : BCD_7_segment
        port map (BCD => BCD, reset => reset, seven_sig => seven_sig);

    -- test sequence
    tb : process
    begin
        -- set all inputs to zero
        BCD <= (others => '0');
        reset <= '0';

        -- test reset
        reset <= '0';
        wait for T;
        reset <= '1';
        wait for T;
        assert (seven_sig = "1111111")
            report "BCD_7_segment Error: Display not off under reset"
            severity error;
        reset <= '0';

        -- test digits
        -- test 0
        BCD <= "0000";
        wait for T;
        assert (seven_sig = "1000000")
            report "BCD_7_segment Error: 0 is not displayed correctly"
            severity error;

        -- test 1
        BCD <= "0001";
        wait for T;
        assert (seven_sig = "1111001")
            report "BCD_7_segment Error: 1 is not displayed correctly"
            severity error;

        -- test 2
        BCD <= "0010";
        wait for T;
        assert (seven_sig = "0100100")
            report "BCD_7_segment Error: 2 is not displayed correctly"
            severity error;

        -- test 3
        BCD <= "0011";
        wait for T;
        assert (seven_sig = "0110000")
            report "BCD_7_segment Error: 3 is not displayed correctly"
            severity error;

        -- test 4
        BCD <= "0100";
        wait for T;
        assert (seven_sig = "0011001")
            report "BCD_7_segment Error: 4 is not displayed correctly"
            severity error;

        -- test 5
        BCD <= "0101";
        wait for T;
        assert (seven_sig = "0010010")
            report "BCD_7_segment Error: 5 is not displayed correctly"
            severity error;

        -- test 6
        BCD <= "0110";
        wait for T;
        assert (seven_sig = "0000010")
            report "BCD_7_segment Error: 6 is not displayed correctly"
            severity error;

        -- test 7
        BCD <= "0111";
        wait for T;
        assert (seven_sig = "1111000")
            report "BCD_7_segment Error: 7 is not displayed correctly"
            severity error;

        -- test 8
        BCD <= "1000";
        wait for T;
        assert (seven_sig = "0000000")
            report "BCD_7_segment Error: 8 is not displayed correctly"
            severity error;

        -- test 9
        BCD <= "1001";
        wait for T;
        assert (seven_sig = "0010000")
            report "BCD_7_segment Error: 9 is not displayed correctly"
            severity error;

        stop(1);
    end process;
end architecture Testbench;
