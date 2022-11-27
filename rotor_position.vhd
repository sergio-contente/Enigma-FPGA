------------------------------ENIGMA-------------------------------------
-- Arquivo   : rotor_position.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Consiste no rotacionamento dos rotores que sao responsaveis
--							por combinar as letras de entrada.
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     26/11/2022  1.0     Sergio Magalhaes Contente 		criacao
------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity RotorPosition is
	port(
		
	);
end RotorPosition;

architecture Behavioral of RotorPass is
	signal s_letter_in, s_letter_out : std_logic_vector(4 downto 0);
begin

end architecture;
