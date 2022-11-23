------------------------------ENIGMA-------------------------------------
-- Arquivo   : rotor_turnover.vhd
-- Projeto   : Enigma
-------------------------------------------------------------------------
-- Descricao : Seleciona qual tipo de roda do rotor que o usuario estara
--             dutilizando para cada uma das 3 peças.
--
--             Consiste em um MUX que retorna se o rotor de tal tipo deve
--							 rotacionar ou nao.
--
--             A ordem logica é: o rotor 1 sempre gira, o 2 gira a partir
-- 						 momento que atingiu o entalhe do rotor 1 e o terceiro rotor
--             gira apenas quando atinge o entalhe do rotor 2.
--
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     22/11/2022  1.0     Sergio Magalhaes Contente 		criacao
------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity rotor_turnover is
	port(
			rotor_type : in std_logic_vector(2 downto 0); -- Temos 5 tipos diferentes de Rotor (I, II, III, IV e V)
			current_letter : in  std_logic_vector(4 downto 0); -- Valor atual da letra mostrada no rotor
		  turnover_rotor : out  std_logic -- Se deve rotacionar ou nao o proximo rotor
		); 
end rotor_turnover;

architecture rotor_turnover_arch of rotor_turnover is

	signal s_turnover : std_logic; --

begin
		s_turnover <=
				'1' when current_letter = "10000" and rotor_type = "000" else -- Q (Rotor I)
				'1' when current_letter = "00100" and rotor_type = "001" else -- E (Rotor II)
				'1' when current_letter = "10101" and rotor_type = "010" else -- V (Rotor III)
				'1' when current_letter = "01001" and rotor_type = "011" else -- J (Rotor IV)
				'1' when current_letter = "11001" and rotor_type = "100" else -- Z (Rotor V)
				'0'; -- Nao deve rotacionar

		turnover_rotor <= s_turnover;

end architecture;


