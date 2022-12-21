library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity bit_to_ascii is
    port(
        fivebit : in std_logic_vector(4 downto 0);
        ascii : out std_logic_vector(6 downto 0)
    );
end bit_to_ascii;

architecture arch of bit_to_ascii is
    signal converted : std_logic_vector(6 downto 0);
begin
    converted <= "1000001" when fivebit = "00000" else
                 "1000010" when fivebit = "00001" else
                 "1000011" when fivebit = "00010" else
                 "1000100" when fivebit = "00011" else
                 "1000101" when fivebit = "00100" else
                 "1000110" when fivebit = "00101" else
                 "1000111" when fivebit = "00110" else
                 "1001000" when fivebit = "00111" else
                 "1001001" when fivebit = "01000" else
                 "1001010" when fivebit = "01001" else
                 "1001011" when fivebit = "01010" else
                 "1001100" when fivebit = "01011" else
                 "1001101" when fivebit = "01100" else
                 "1001110" when fivebit = "01101" else
                 "1001111" when fivebit = "01110" else
                 "1010000" when fivebit = "01111" else
                 "1010001" when fivebit = "10000" else
                 "1010010" when fivebit = "10001" else
                 "1010011" when fivebit = "10010" else
                 "1010100" when fivebit = "10011" else
                 "1010101" when fivebit = "10100" else
                 "1010110" when fivebit = "10101" else
                 "1010111" when fivebit = "10110" else
                 "1011000" when fivebit = "10111" else
                 "1011001" when fivebit = "11000" else
                 "1011010" when fivebit = "11001" else
                --  "0100000" when fivebit = "11010" else
                 "1111111";
    
    ascii <= converted;
end architecture;