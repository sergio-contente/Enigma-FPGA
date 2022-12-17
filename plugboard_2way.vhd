------------------------------ENIGMA-------------------------------------
-- Arquivo   : plugboard_2way.vhd
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

entity plugboard_2way is
    port(
		clock : in  std_logic;
		clear : in  std_logic;
		switch_letters : in std_logic; -- Enable para trocar original_letter com new_letter
		from_letter_dir : in std_logic_vector(4 downto 0); -- Letra original
		to_letter : in std_logic_vector(4 downto 0); -- Letra a ser trocada para o endereco da original
		from_letter_inv : in std_logic_vector(4 downto 0);
		final_letter_dir : out std_logic_vector(4 downto 0);  
        final_letter_inv : out std_logic_vector(4 downto 0)
    );
end plugboard_2way;

architecture plugboard_2way_arch of plugboard_2way is
	type alphabet is array (0 to 26) of std_logic_vector(4 downto 0);
	signal letters : alphabet := ("00000", "00001", "00010", "00011", "00100", "00101", 
											"00110", "00111", "01000", "01001", "01010", "01011", 
											"01100", "01101", "01110", "01111", "10000", "10001", 
											"10010", "10011", "10100", "10101", "10110", "10111",
											"11000", "11001", "11010"); -- Esse aqui eh o vetor que sofrer permutacoes com os ciclos de clock
	signal fixed_alphabet : alphabet := ("00000", "00001", "00010", "00011", "00100", "00101", 
											"00110", "00111", "01000", "01001", "01010", "01011", 
											"01100", "01101", "01110", "01111", "10000", "10001", 
											"10010", "10011", "10100", "10101", "10110", "10111",
											"11000", "11001", "11010"); -- Esse vetor nunca deve ser modificado! Serve para o reset
	
	signal s_final_letter_dir, s_final_letter_inv : std_logic_vector(4 downto 0);
begin
	process(clock, clear, switch_letters, letters)
	begin
		if (clear = '1') then 
			for i in 0 to 26 loop
				letters(i) <= fixed_alphabet(i);
			end loop;
		elsif (clock'event and clock='1') then 
			if (switch_letters = '1') then
				letters(to_integer(unsigned(from_letter_dir))) <= to_letter;
				letters(to_integer(unsigned(to_letter))) <= from_letter_dir;
			end if;
		end if;
	end process;
	process(from_letter_dir, from_letter_inv, letters, s_final_letter_dir, s_final_letter_inv)
	begin
		if (to_integer(unsigned(from_letter_dir)) < 27) then
			s_final_letter_dir <= letters(to_integer(unsigned(from_letter_dir)));
		end if;
		if (to_integer(unsigned(from_letter_inv)) < 27) then
			s_final_letter_inv <= letters(to_integer(unsigned(from_letter_inv)));
		end if;
	end process;

	final_letter_dir <= s_final_letter_dir;
	final_letter_inv <= s_final_letter_inv;
end plugboard_2way_arch;
