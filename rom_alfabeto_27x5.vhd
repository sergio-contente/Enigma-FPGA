library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_alfabeto_27x5 is
    port (
        endereco : in  std_logic_vector(4 downto 0);
        saida    : out std_logic_vector(4 downto 0)
    ); 
end entity;

architecture rom_arch of rom_alfabeto_27x5 is
    type memoria_27x5 is array (integer range 0 to 26) of std_logic_vector(4 downto 0);
    constant alfabeto: memoria_27x5 := (
        "00000", --   0 = 'A'
        "00001", --   1 = 'B'
        "00010", --   2 = 'C'
        "00011", --   3 = 'D'
        "00100", --   4 = 'E'
        "00101", --   5 = 'F'
        "00110", --   6 = 'G'
        "00111", --   7 = 'H'
        "01000", --   8 = 'I'
        "01001", --   9 = 'J'
        "01010", --  10 = 'K'
        "01011", --  11 = 'L'
        "01100", --  12 = 'M'
        "01101", --  13 = 'N'
        "01110", --  14 = 'O'
        "01111", --  15 = 'P'
        "10000", --  16 = 'Q'
        "10001", --  17 = 'R'
        "10010", --  18 = 'S'
        "10011", --  19 = 'T'
        "10100", --  20 = 'U'
        "10101", --  21 = 'V'
        "10110", --  22 = 'W'
        "10111", --  23 = 'X'
        "11000", --  24 = 'Y'
        "11001", --  25 = 'Z'
        "11010"  --  26 = ' '
    );
begin

    saida <= alfabeto(to_integer(unsigned(endereco)));

end architecture rom_arch;
