------------------------------ENIGMA-------------------------------------
-- Arquivo   : plugboard.vhd
-- Projeto   : Enigma
-------------------------------------------------------------------------
-- Descricao : Refletor que faz a permutacao entre duas letras
--             dada uma chave como entrada.
--
--             Consiste de um dicionario que mapeia as posicoes das letras
--						 no alfabeto como chave e as letras em si como valor.
--
--             Com a codificacao de 5 bits, a posicao e congruente ao valor
--             no alfabeto original.
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     22/11/2022  1.0     Sergio Magalhaes Contente 		criacao
------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity plugboard is
    port(
				clock : in  std_logic;
				clear : in  std_logic;
				switch_letters : in std_logic; -- Enable para trocar original_letter com new_letter
				from_letter : in std_logic(4 downto 0); -- Letra original
				to_letter : in std_logic_vector(4 downto 0); -- Letra a ser trocada para o endereco da original
        final_letter : out std_logic_vector(4 downto 0);
    );
end plugboard;

architecture plugboard_arch of plugboard is
	type alphabet is array (0 to 25) of std_logic_vector(4 downto 0);
	signal letters : alphabet := ("00000", "00001", "00010", "00011", "00100", "00101", 
											"00110", "00111", "01000", "01001", "01010", "01011", 
											"01100", "01101", "01110", "01111", "10000", "10001", 
											"10010", "10011", "10100", "10101", "10110", "10111",
											"11000", "11001");
begin
	process(clock, clear, switch_letters, letters)
	begin
		if (clear = '1') then letters(to_integer(unsigned(from_letter))) <= letters(to_integer(unsigned(from_letter)));
		elsif (clock'event and clock='1') then 
			if (switch_letters = '1') then
				letters(to_integer(unsigned(from_letter))) <= to_letter;
			end if;
		end if;

		final_letter <= letters(to_integer(unsigned(from_letter)));
	end process;
end plugboard_arch;
