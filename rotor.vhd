------------------------------ENIGMA-------------------------------------
-- Arquivo   : RotorPass.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Consiste na passagem do sinal
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     29/11/2022  1.0     Sergio Magalhães Contente     	criacao
------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity rotor is
	port(
		clock  : in  std_logic;
		clear : in std_logic;

		direction : in std_logic;
		gira : in std_logic;

		letter_in : in std_logic_vector(4 downto 0);

		rotor_type : in std_logic_vector(2 downto 0);
		
		letter_out : out std_logic_vector(4 downto 0);

		turn_next: out std_logic
	);
end rotor;

architecture rotor_arch of rotor is
	signal 

	

	component rotor_rotate is
		port (
			clock : in std_logic;
			clear : in std_logic;
			enable_rotation : in std_logic;
			rotor_letter_in : in std_logic_vector(4 downto 0);
			rotor_type_in : in std_logic_vector(2 downto 0);
			rotor_out : out std_logic_vector(4 downto 0);
			rotate_next_rotor : out std_logic
			fim_rotor: out std_logic;
		);
	end component;

	component TraduzLetra is
		port(
			rotor_type: in std_logic_vector(2 downto 0);
			letter_in : in std_logic_vector(4 downto 0);
			direction: in std_logic;
			letter_out : out std_logic_vector(4 downto 0)
		);
	end component;

signal gira_segundo, gira_terceiro : std_logic;
signal s_first_letter, s_second_letter, s_third_letter : std_logic_vector(4 downto 0);

begin

	---------------------------------------
--
-- Rotacionamento do  rotor
--
----------------------------------------
rotor_spin: rotor_rotate
port map(
	clock => clock,
	clear => clear,
	enable_rotation => gira_rotor,
	rotor_letter_in => letter_in,
	rotor_type_in => rotor_type;
	rotor_out =>  s_letter,
	rotate_next_rotor => turn_next
);


---------------------------------------
--
-- Combinacao da letra
--
----------------------------------------

rotor_translation: TraduzLetra
port map(
	rotor_type => rotor_type,
	letter_in => s_letter,
	direction => direction,
	letter_out => letter_out
);

end architecture;
