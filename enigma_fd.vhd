------------------------------ENIGMA-------------------------------------
-- Arquivo   : engima_fd.vhd
-- Projeto   : Enigma
-------------------------------------------------------------------------
-- Descricao : Dataflow of enigma signals
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     22/11/2022  1.0     Sergio Magalhaes Contente 		criacao
------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.alphabet_type.all;

entity engima_fd is
	port(enable	    : in  std_logic;
		  clk 		 : in  std_logic;
		  save 		 : in  std_logic;
		  letter_in  : in  std_logic_vector(4 downto 0);
		  memory_out : out alphabet;
		  done       : out std_logic;
			letter_out        : OUT std_logic_vector(4 downto 0)
	);
end engima_fd;

architecture fd_arch of engima_fd is 
	type alphabet is array (0 to 26) of std_logic_vector(4 downto 0);

	signal s_memory       : alphabet; 	-- stores the plugboard information
	signal s_letter_count : unsigned(4 downto 0) := "00000";  -- letter counter (counts from A to Z)

	signal s_plugboard : alphabet := ("00000", "00001", "00010", "00011", "00100", "00101", 
												 "00110", "00111", "01000", "01001", "01010", "01011", 
												 "01100", "01101", "01110", "01111", "10000", "10001", 
												 "10010", "10011", "10100", "10101", "10110", "10111",
												 "11000", "11001");

	component plugboard is
			port(
					clock : in  std_logic;
					clear : in  std_logic;
					switch_letters : in std_logic; -- Enable para trocar original_letter com new_letter
					from_letter : in std_logic_vector(4 downto 0); -- Letra original
					to_letter : in std_logic_vector(4 downto 0); -- Letra a ser trocada para o endereco da original
					final_letter : out std_logic_vector(4 downto 0)
			);
	end component;

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

component rotor is
	port(
		clock  : in  std_logic;
		clear : in std_logic;

		direction : in std_logic;
		gira : in std_logic;

		letter_in : in std_logic_vector(4 downto 0);

		rotor_type : in std_logic_vector(2 downto 0);
		is_third: in std_logic;
		
		letter_out : out std_logic_vector(4 downto 0);

		turn_next: out std_logic;
		fim_combinacao : out std_logic
	);
end component;

component reflector is
	port(
		reflector_type : in std_logic_vector(1 downto 0); -- "00": TIPO A, "01": TIPO B, "10": TIPO C
		letter_in : in std_logic_vector(4 downto 0);
		enable_reflector => in std_logic;

		letter_out: out std_logic_vector(4 downto 0)
	);
end component;

entity preparation is
	port (
		clock : in std_logic;
		clear : in std_logic;
		enable : in std_logic;

		letter_in : in std_logic_vector(4 downto 0);
		ring_pos : in std_logic_vector(4 downto 0);
		rotor_post : in std_logic_vector(4 downto 0);

		preprocess_letter : out std_logic_vector(4 downto 0);
		fim_preprocess  : out std_logic

	);

begin
-------------------------------------------------------------
--
--           Setup Inicial das Configuracoes
--
-------------------------------------------------------------

-- Registra a letra recebida serialmente

	letra_serial: registrador_n
	generic map(
		 N => 5
	)
	port map (
		 clock => clock,
		 clear => clear,
		 enable => tem_dado,
		 D      => entrada_serial,
		 Q      => s_letra_recebia
	);
 
	
-- Setup da plugboard : modifica o vetor de sinais s_plugboard

	plugboard_setup: plugboard
		port map(
				clock => clock,
				clear => clear,
				switch_letters => setup_plugboard,-- Enable para trocar original_letter com new_letter
				from_letter => letra_original_serial, -- Letra original
				to_letter => letra_nova_serial, -- Letra a ser trocada para o endereco da original
				final_letter => s_plugboard(to_integer(unsigned(letra_original_serial)))
		);

-- Setup do refletor : registra o tipo de refletor utilizado
		refletor_setup: registrador_n
			generic map(
				N => 2
			)
			port map (
				clock => clock,
				clear => clear,
				enable => setup_refletor,
				D      => refletor_type,
				Q      => s_refletor_type
			);

-- Setup dos aneis: Registra qual eh a posicao do anel de cada rotor

	first_ring_setup: registrador_n
    generic map(
       N => 5
    )
    port map (
       clock => clock,
       clear => clear,
       enable => setup_first_ring,
       D      => first_ring_pos,
       Q      => s_first_ring_pos
    );

	second_ring_setup: registrador_n
	generic map(
		 N => 5
	)
	port map (
		 clock => clock,
		 clear => clear,
		 enable => setup_second_ring,
		 D      => second_ring_pos,
		 Q      => s_second_ring_pos
	);

	third_ring_setup: registrador_n
	generic map(
		 N => 5
	)
	port map (
		 clock => clock,
		 clear => clear,
		 enable => setup_third_ring,
		 D      => third_ring_pos,
		 Q      => s_third_ring_pos
	);
	
-- Setup das posicoes iniciais: 

	first_init_pos: registrador_n
	generic map(
		 N => 5
	)
	port map (
		 clock => clock,
		 clear => clear,
		 enable => setup_first_pos,
		 D      => first_pos,
		 Q      => s_first_pos
	);

	second_init_pos: registrador_n
	generic map(
		 N => 5
	)
	port map (
		 clock => clock,
		 clear => clear,
		 enable => setup_first_pos,
		 D      => first_pos,
		 Q      => s_first_pos
	);

	third_init_pos: registrador_n
	generic map(
		 N => 5
	)
	port map (
		 clock => clock,
		 clear => clear,
		 enable => setup_first_pos,
		 D      => first_pos,
		 Q      => s_first_pos
	);

-- Setup do tipo de rotor: Registra o tipo de rotor para cada instancia

	first_rotor_setup: registrador_n
	generic map(
		 N => 3
	)
	port map (
		 clock => clock,
		 clear => clear,
		 enable => setup_first_type,
		 D      => first_rotor_type,
		 Q      => s_first_rotor_type
	);

	second_rotor_setup: registrador_n
	generic map(
		 N => 3
	)
	port map (
		 clock => clock,
		 clear => clear,
		 enable => setup_second_type,
		 D      => second_rotor_type,
		 Q      => s_second_rotor_type
	);

	third_rotor_setup: registrador_n
	generic map(
		 N => 3
	)
	port map (
		 clock => clock,
		 clear => clear,
		 enable => setup_third_type,
		 D      => third_rotor_type,
		 Q      => s_third_rotor_type
	);

	first_letter_in <=  s_plugboard(to_integer(unsigned(s_letra_recebia))) when direction = '0' else

											s_plugboard(to_integer(unsigned(letra_refletida))) when direction = '1';	

	gira_primeiro <= not direction;
	gira_segundo <= turnover_segundo and not direction;
	gira_terceiro <= turnover_terceiro and not direction;
	---------------------------------------
--
-- Preprocessamento primeiro rotor
--
----------------------------------------

first_preprocess: preparation 
port map(
	clock => clock,
	clear => clear,
	enable => enable_first_preprocess,

	letter_in => first_letter_in,
	ring_pos => s_first_ring_pos,
	rotor_post => s_first_pos,

	preprocess_letter => s_first_letter_preprocess,
	fim_preprocess  => fim_preprocess_first
);
------------------------------------------------------------------
--  Codificacao primeiro rotor                             -------
------------------------------------------------------------------

first_rotor: rotor
port map(
		clock  => clock,
		clear => clear,

		direction => direction,
		gira => recebe_gira_primeiro,

		letter_in => s_first_letter_preprocess,

		rotor_type => s_first_rotor_type,
		
		letter_out => s_second_letter_in,

		turn_next => turnover_segundo,
		fim_rotor => fim_first_rotor
	);

---------------------------------------
--
-- Preprocessamento segundo rotor
--
----------------------------------------

second_preprocess: preparation 
port map(
	clock => clock,
	clear => clear,
	enable => enable_second_preprocess,

	letter_in => second_letter_in,
	ring_pos => s_second_ring_pos,
	rotor_post => s_second_pos,

	preprocess_letter => s_second_letter_preprocess,
	fim_preprocess => fim_preprocess_second

);

------------------------------------------------------------------
--  Codificacao segundo rotor                                  -------
------------------------------------------------------------------

second_rotor: rotor
port map(
		clock  => clock,
		clear => clear,

		direction => direction,
		gira => recebe_gira_psegundo,

		letter_in => s_second_letter_preprocess,

		rotor_type => s_second_rotor_type,

		letter_out => s_second_letter_in,

		turn_next => turnover_terceiro,
		fim_rotor => fim_second_rotor

	);

---------------------------------------
--
-- Preprocessamento terceiro rotor
--
----------------------------------------
third_preprocess: preparation 
port map(
	clock => clock,
	clear => clear,
	enable => enable_third_preprocess,

	letter_in => third_letter_in,
	ring_pos => s_third_ring_pos,
	rotor_post => s_third_pos,

	preprocess_letter => s_third_letter_preprocess,
	fim_preprocess  => fim_preprocess_third

);

-----------------------------------------------------------------
--  Codificacao terceiro rotor                                  -------
------------------------------------------------------------------

terceiro_rotor: rotor
port map(
		clock  => clock,
		clear => clear,

		direction => direction,
		gira => recebe_gira_terceiro,

		letter_in => s_third_letter_preprocess,

		rotor_type => s_third_rotor_type,
		
		letter_out => s_third_letter_out,

		turn_next => '0',
		fim_rotor => fim_combinacao

	);

	 ativa_refletor <= '1' when fim_combinacao = '1' and direction = '0' else '0';

	Refletor: reflector
	port map(
		reflector_type => s_refletor_type,
		letter_in => s_third_letter_out,
		enable_reflector => enable_refletor,

		letter_out => letter_refletor
	);

third_letter_out <= s_third_letter_out;

end fd_arch;
