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

entity SignalPath is
	port(
		clock  : in  std_logic;
		clear : in std_logic;
		direction : in std_logic;
		first_rotor: in std_logic_vector(2 downto 0);
		second_rotor: in std_logic_vector(2 downto 0);
		third_rotor: in std_logic_vector(2 downto 0);
		enable_inicial : in std_logic;
		enable_rotation : in std_logic;
		set_ring: in std_logic;
		ringstellung : in std_logic_vector(4 downto 0); -- posicao anel
		grundstellung : in std_logic_vector(4 downto 0); -- posicao inicial do rotor
		rotor_turnover : out std_logic;
		letter_in : in std_logic_vector(4 downto 0);
		letter_out : out std_logic_vector(4 downto 0)
	);
end SignalPath;

architecture signal_path_arch of SignalPath is
	component RotorPass is
		port(
		clock  : in  std_logic;
		clear : in std_logic;
		direction : in std_logic;
		rotor_type : in std_logic_vector(2 downto 0);
		enable_inicial : in std_logic;
		enable_rotation : in std_logic;
		set_ring: in std_logic;
		ringstellung : in std_logic_vector(4 downto 0); -- posicao anel
		grundstellung : in std_logic_vector(4 downto 0); -- posicao inicial do rotor
		rotor_turnover : out std_logic;
		letter_in : in std_logic_vector(4 downto 0);
		letter_out : out std_logic_vector(4 downto 0)
	);
	end component;
-- sinais internos do primeiro rotor
	signal gira_segundo_rotor, set_ring_first, enable_rotation_first, enable_inicial_first : std_logic;
	signal rinstellung_first, grundstellung_first, first_letter_in, first_letter_out : std_logic_vector(4 downto 0);

-- sinais internos do segundo rotor
	signal gira_terceiro_rotor, set_ring_second, enable_rotation_second, enable_inicial_second : std_logic;
	signal rinstellung_second, grundstellung_second, second_letter_in, second_letter_out : std_logic_vector(4 downto 0);

-- sinais internos do terceiro rotor
	signal set_ring_third, enable_rotation_third, enable_incial_third : std_logic;
	signal rinstellung_third, grundstellung_third, third_letter_in, third_letter_out : std_logic_vector(4 downto 0);
begin

	--so giram quando o sinal estiver entrando (direita para a esquerda)

	enable_rotation_first <= '1' when direction = '0' else '0';
	enable_rotation_second <= '1' when direction = '0' else '0';
	enable_rotation_third <= '1' when direction = '0' else '0';

-- Sinal passa pelo primeiro rotor
	first_rotor: RotorPass port map(
		clock  => clock,
		clear  => clear,
		direction => direction,
		rotor_type => first_rotor,
		enable_inicial => enable_inicial_first,
		enable_rotation => enable_rotation_first,
		set_ring => set_ring_first,
		ringstellung => ringstellung_first,  -- posicao anel
		grundstellung => grundstellung_first, -- posicao inicial do rotor
		rotor_turnover => gira_segundo_rotor,
		letter_in => first_letter_in,
		letter_out => first_letter_out
	);

	second_letter_in <= first_letter_out;
	enable_rotation <= gira_segundo_rotor;

-- Sinal passa pelo segundo rotor
	second_rotor: RotorPass port map(
		clock => clock,
		clear => clear,
		direction => direction,
		rotor_type => second_rotor,
		enable_inicial => enable_inicial_second,
		enable_rotation => enable_rotation_second,
		set_ring => set_ring_second,
		ringstellung => ringstellung_second, -- posicao anel
		grundstellung => grundstellung_second,
		rotor_turnover => gira_terceiro_rotor,
		letter_in => second_letter_in,
		letter_out => second_letter_out
	);

	third_letter_in <= second_letter_out;
	enable_rotation <= gira_terceiro_rotor;

-- Sinal passa pelo terceiro rotor
	third_rotor: RotorPass port map(
		clock => clock,
		clear => clear,
		direction => direction,
		rotor_type => third_rotor,
		enable_inicial => enable_inicial_third,
		enable_rotation => enable_rotation_third,
		set_ring => set_ring_third,
		ringstellung => ringstellung_third, -- posicao anel
		grundstellung => grundstellung_third,
		rotor_turnover => gira_terceiro_rotor,
		letter_in => third_letter_in,
		letter_out => third_letter_out
	);

	letter_out <= third_letter_out when direction = '0' else
								first_letter_out;
end architecture;
