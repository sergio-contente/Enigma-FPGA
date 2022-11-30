library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity bit_to_ascii is
    port(
        5bit : out std_logic(4 downto 0);
        ascii : in std_logic(6 downto 0)
    );
end bit_to_ascii;

architecture arch of bit_to_ascii is
    signal converted : std_logic_vector(6 downto 0);
begin
    converted <= "1000001" when ascii = "00000" else
                 "1000010" when ascii = "00001" else
                 "1000011" when ascii = "00010" else
                 "1000100" when ascii = "00011" else
                 "1000101" when ascii = "00100" else
                 "1000110" when ascii = "00101" else
                 "1000111" when ascii = "00110" else
                 "1001000" when ascii = "00111" else
                 "1001001" when ascii = "01000" else
                 "1001010" when ascii = "01001" else
                 "1001011" when ascii = "01010" else
                 "1001100" when ascii = "01011" else
                 "1001101" when ascii = "01100" else
                 "1001110" when ascii = "01101" else
                 "1001111" when ascii = "01110" else
                 "1010000" when ascii = "01111" else
                 "1010001" when ascii = "10000" else
                 "1010010" when ascii = "10001" else
                 "1010011" when ascii = "10010" else
                 "1010100" when ascii = "10011" else
                 "1010101" when ascii = "10100" else
                 "1010110" when ascii = "10101" else
                 "1010111" when ascii = "10110" else
                 "1011000" when ascii = "10111" else
                 "1011001" when ascii = "11000" else
                 "1011010" when ascii = "11001" else
                 "0100000" when ascii = "11010" else
                 "1111111";
    
    5bit <= converted;
end architecture;