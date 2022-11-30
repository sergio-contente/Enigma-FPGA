library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ascii_to_5bit is
    port(
        ascii : in std_logic(6 downto 0);
        5bit : out std_logic(4 downto 0)
    );
end ascii_to_5bit;

architecture arch of ascii_to_5bit is
    signal converted : std_logic_vector(4 downto 0);
begin
    converted <= "00000" when ascii = "1000001" else
                 "00001" when ascii = "1000010" else
                 "00010" when ascii = "1000011" else
                 "00011" when ascii = "1000100" else
                 "00100" when ascii = "1000101" else
                 "00101" when ascii = "1000110" else
                 "00110" when ascii = "1000111" else
                 "00111" when ascii = "1001000" else
                 "01000" when ascii = "1001001" else
                 "01001" when ascii = "1001010" else
                 "01010" when ascii = "1001011" else
                 "01011" when ascii = "1001100" else
                 "01100" when ascii = "1001101" else
                 "01101" when ascii = "1001110" else
                 "01110" when ascii = "1001111" else
                 "01111" when ascii = "1010000" else
                 "10000" when ascii = "1010001" else
                 "10001" when ascii = "1010010" else
                 "10010" when ascii = "1010011" else
                 "10011" when ascii = "1010100" else
                 "10100" when ascii = "1010101" else
                 "10101" when ascii = "1010110" else
                 "10110" when ascii = "1010111" else
                 "10111" when ascii = "1011000" else
                 "11000" when ascii = "1011001" else
                 "11001" when ascii = "1011010" else
                 "00000" when ascii = "1100001" else
                 "00001" when ascii = "1100010" else
                 "00010" when ascii = "1100011" else
                 "00011" when ascii = "1100100" else
                 "00100" when ascii = "1100101" else
                 "00101" when ascii = "1100110" else
                 "00110" when ascii = "1100111" else
                 "00111" when ascii = "1101000" else
                 "01000" when ascii = "1101001" else
                 "01001" when ascii = "1101010" else
                 "01010" when ascii = "1101011" else
                 "01011" when ascii = "1101100" else
                 "01100" when ascii = "1101101" else
                 "01101" when ascii = "1101110" else
                 "01110" when ascii = "1101111" else
                 "01111" when ascii = "1110000" else
                 "10000" when ascii = "1110001" else
                 "10001" when ascii = "1110010" else
                 "10010" when ascii = "1110011" else
                 "10011" when ascii = "1110100" else
                 "10100" when ascii = "1110101" else
                 "10101" when ascii = "1110110" else
                 "10110" when ascii = "1110111" else
                 "10111" when ascii = "1111000" else
                 "11000" when ascii = "1111001" else
                 "11001" when ascii = "1111010" else
                 "11010" when ascii = "0100000" else
                 "11111";
    
    5bit <= converted;
end architecture;