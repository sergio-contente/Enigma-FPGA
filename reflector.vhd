------------------------------ENIGMA-------------------------------------
-- Arquivo   : reflector.vhd
-- Projeto   : Enigma
-------------------------------------------------------------------------
-- Descricao : Refletor que faz a permutacao entre duas letras
--             usando Cifra de Cesar, com base nos 3 tipos de
--             refletores usados pelas forcas armadas alemas na WWII.
--             Basicamente consiste em um MUX.
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     22/11/2022  1.0     Sergio Magalhaes Contente 		criacao
------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reflector is
    port(
				reflector_type : in std_logic_vector(1 downto 0);
        letter_in : in std_logic_vector(4 downto 0);
        letter_out: out std_logic_vector(4 downto 0);
    );
end reflector;

architecture reflector_arch of reflector is
begin
	
end reflector_arch;
