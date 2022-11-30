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

entity RotorPass is
	port(
		clock  : in  std_logic;
		clear : in std_logic;

		direction : in std_logic;
		gira_primeiro : in std_logic;

		first_letter_in : in std_logic_vector(4 downto 0);
		second_letter_in : in std_logic_vector(4 downto 0);
		third_letter_in : in std_logic_vector(4 downto 0);

		s_first_rotor_type : in std_logic_vector(2 downto 0);
		s_second_rotor_type : in std_logic_vector(2 downto 0);
		s_third_rotor_type : in std_logic_vector(2 downto 0);
		
		first_letter_out : out std_logic_vector(4 downto 0);
		second_letter_out : out std_logic_vector(4 downto 0);
		third_letter_out : out std_logic_vector(4 downto 0);

		enable_refletor : out std_logic
	);
end RotorPass;

architecture RotorPass_arch of RotorPass is
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
-- Rotacionamento do primeiro rotor
--
----------------------------------------
first_spin: rotor_rotate
port map(
	clock => clock,
	clear => clear,
	enable_rotation => gira_primeiro,
	rotor_letter_in => first_letter_in,
	rotor_type_in => s_first_rotor_type;
	rotor_out =>  s_first_letter,
	rotate_next_rotor => gira_segundo
);


---------------------------------------
--
-- Combinacao da primeira letra
--
----------------------------------------

first_translation: TraduzLetra
port map(
	rotor_type => s_first_rotor_type,
	letter_in => s_first_letter,
	direction => direction,
	letter_out => first_letter_out
);


---------------------------------------
--
-- Rotacionamento do segundo rotor
--
----------------------------------------
second_spin: rotor_rotate
port map(
clock => clock,
clear => clear,
enable_rotation => gira_segundo,
rotor_letter_in => second_letter_in,
rotor_type_in => s_second_rotor_type;
rotor_out => s_second_letter,
rotate_next_rotor => gira_terceiro
);

---------------------------------------
--
-- Combinacao da segunda letra
--
----------------------------------------

second_translation: TraduzLetra
port map(
rotor_type => s_second_rotor_type,
letter_in => s_second_letter,
direction => direction,
letter_out => second_letter_out
);

---------------------------------------
--
-- Rotacionamento do terceiro rotor
--
----------------------------------------
third_spin: rotor_rotate
port map(
clock => clock,
clear => clear,
enable_rotation => gira_terceiro,
rotor_letter_in => third_letter_in,
rotor_type_in => s_third_rotor_type;
rotor_out => s_third_letter,
rotate_next_rotor => open
);

---------------------------------------
--
-- Combinacao da terceira letra
--
----------------------------------------

third_translation: TraduzLetra
port map(
rotor_type => s_third_rotor_type,
letter_in => s_third_letter,
direction => direction,
letter_out => third_letter_out
);

enable_refletor <= '1' when  gira_terceiro = '1' and direction = '0' else '0';

end architecture;
