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

begin

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
end fd_arch;
