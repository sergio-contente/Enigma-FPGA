------------------------------ENIGMA-------------------------------------
-- Arquivo   : rotor_initial_position.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Consiste no rotacionamento dos rotores que sao responsaveis
--							por combinar as letras de entrada.
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     26/11/2022  1.0     Jonas Gomes de Morais     		criacao
------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity rotor_initial_position is
	port(
		clock : in std_logic;
		reset : in std_logic;
		set : in std_logic;
		initial_pos : in std_logic_vector(4 downto 0);
		letter_in : in std_logic_vector(4 downto 0);
		letter_out : out std_logic_vector(4 downto 0)
	);
end rotor_initial_position;

architecture rotor_initial_position_arch of rotor_initial_position is
	signal s_letter_in, s_letter_out, s_init_pos : std_logic_vector(4 downto 0);

	component registrador_n is
		generic (
		   constant N: integer := 8 
		);
		port (
		   clock  : in  std_logic;
		   clear  : in  std_logic;
		   enable : in  std_logic;
		   D      : in  std_logic_vector (N-1 downto 0);
		   Q      : out std_logic_vector (N-1 downto 0) 
		);
	end component;
begin
	reg_init_pos : registrador_n
		generic map(
			N => 5
		)
		port map(
			clock => clock,
			clear => reset,
			enable => set,
			D => initial_pos,
			Q => s_init_pos
		);
	
	shift_init_pos : process(letter_in, clock, s_init_pos)
	begin
	if clock'event and clock='1' then
		s_letter_out <= std_logic_vector(to_unsigned((to_integer(unsigned(s_letter_in)) + to_integer(unsigned(s_init_pos))) rem 27), s_letter_out'length);
	end if;
	end process shift_init_pos;
	
	letter_in <= s_letter_in;	
	letter_out <= s_letter_out;
		
end architecture;
