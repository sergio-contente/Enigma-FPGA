------------------------------ENIGMA-------------------------------------
-- Arquivo   : translator_I.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Traducao do teclado:
-- =========================================================================
--							ABCDEFGHIJKLMNOPQRSTUVWXYZ
--							EKMFLGDQVZNTOWYHXUSPAIBRCJ
-- ========================================================================
--							por combinar as letras de entrada.
----------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     23/11/2022  1.0     Sergio Magalhaes Contente 		criacao
------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity translator_I is
    port (
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
end entity;

architecture translator_I_arch of translator_I is
	signal s_letter_in, s_letter_out: std_logic_vector(4 downto 0);
begin
	s_letter_in <= original;
	rotation_rotor_I: process (s_letter_in, s_letter_out, direction)
	begin
			case s_letter_in is 
	
			end case;
	end process;
end architecture;
