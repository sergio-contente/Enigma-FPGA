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
end RotorPass;

architecture rotor_initial_position_arch of rotor_initial_position is
	signal s_letter_inicial_in, s_letter_anel, s_letter_out, s_letter_rotor_out, s_letter_tradutor: std_logic_vector(4 downto 0);

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

	component rotor_turnover is
		port(
				rotor_type : in std_logic_vector(2 downto 0); -- Temos 5 tipos diferentes de Rotor (I, II, III, IV e V)
				current_letter : in  std_logic_vector(4 downto 0); -- Valor atual da letra mostrada no rotor
				turnover_rotor : out  std_logic -- Se deve rotacionar ou nao o proximo rotor
			); 
	end component;

	component ring_position is
		port(
			clock : in std_logic;
			reset : in std_logic;
			set : in std_logic;
			direction : in std_logic;
			ring_pos : in std_logic_vector(4 downto 0);
			letter_in : in std_logic_vector(4 downto 0);
			letter_out : out std_logic_vector(4 downto 0)
		);
	end component;

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

	component translator_I is
    port (
				enable   : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
	end component;

	component translator_II is
    port (
				enable   : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
	end component;

	component translator_III is
    port (
				enable   : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
	end component;

	component translator_IV is
    port (
				enable   : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
	end component;

	component translator_V is
    port (
				enable   : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
	end component;

begin

	letra_inicial: registrador_n
		port map(
			clock => clock,
			clear => clear,
			enable => enable_inicial,
			D => letter_in,
			Q => s_letter_inicial_in
		);

	anel: ring_position
		port map(
			clock => clock,
			reset => clear,
			set => set_ring,
			direction => direction,
			ring_pos => ringstellung,
			letter_in => s_letter_inicial_in,
			letter_out => s_letter_anel
		);

	gira_rotor: rotor_rotate
		port map (
			clock => clock,
			clear => clear,
			enable_rotation => enable_rotation,
			rotor_letter_in => s_letter_anel,
			rotor_type_in +> rotor_type,
			rotor_out =>  s_letter_rotor_out,
			rotate_next_rotor => rotor_turnover
		);

	tradutor_I: port map (
		enable   => rotor_type,
		original => s_letter_rotor_out, -- Letra do comeco 
		direction => direction,
		saida    =>  s_letter_traducao-- Combinacao
); 

tradutor_II: port map (
		enable   => rotor_type,
		original => s_letter_rotor_out, -- Letra do comeco 
		direction => direction,
		saida    =>  s_letter_traducao-- Combinacao
); 

tradutor_III: port map (
		enable   => rotor_type,
		original => s_letter_rotor_out, -- Letra do comeco 
		direction => direction,
		saida    =>  s_letter_traducao-- Combinacao
); 

tradutor_IV: port map (
		enable   => rotor_type,
		original => s_letter_rotor_out, -- Letra do comeco 
		direction => direction,
		saida    =>  s_letter_traducao-- Combinacao
); 

tradutor_V: port map (
		enable   => rotor_type,
		original => s_letter_rotor_out, -- Letra do comeco 
		direction => direction,
		saida    =>  s_letter_traducao-- Combinacao
); 

letter_out <= s_letter_traducao;

end architecture;
