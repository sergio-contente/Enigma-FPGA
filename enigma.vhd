library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity enigma is
	port(
		clock : in  std_logic;
		reset : in std_logic;
		entrada_serial : in std_logic;
		saida_serial : out std_logic;
		-- rotor_1 : out std_logic_vector(6 downto 0);
		-- rotor_2 : out std_logic_vector(6 downto 0);
		-- rotor_3 : out std_logic_vector(6 downto 0);
		estado_db : out std_logic_vector(6 downto 0)
	);
end entity;

architecture enigma_arch of enigma is
	component fd is
    port(
			clock : in std_logic;
			reset : in std_logic;
			entrada : in std_logic_vector(4 downto 0);
			set_config : in std_logic;
			anel_not_pos_ini : in std_logic;
			gira  : in std_logic;
			config_device : in std_logic_vector(3 downto 0);
			letra_visor_1 : out std_logic_vector(4 downto 0);
			letra_visor_2 : out std_logic_vector(4 downto 0);
			letra_visor_3 : out std_logic_vector(4 downto 0);
			saida : out std_logic_vector(4 downto 0)
    );
	end component;

	component uc is
    port(
			clock : in std_logic;
			reset : in std_logic;
			tem_dado : in std_logic;
			pronto_config_plug : in std_logic;
			pronto_tx : in std_logic;
			set_config : out std_logic;
			anel_not_pos_ini : out std_logic;
			gira  : out std_logic;
			reg_let : out std_logic;
			config_device : out std_logic_vector(3 downto 0);
			transmite : out std_logic;
			reset_rx : out std_logic;
			estado : out std_logic_vector(4 downto 0)
    );
	end component;

	component rx is
		generic (baudrate     : integer := 9600);
		port (
			clock		   : in  std_logic;													
			reset		   : in  std_logic;								
			sin			: in  std_logic;							
			dado			: out std_logic_vector(7 downto 0);
			fim			: out std_logic									
		);
	end component;

	component tx is
		generic (baudrate     : integer := 9600);
		port (
			clock		   : in  std_logic;							
			reset		   : in  std_logic;							
			partida  	: in  std_logic;							
			dado			: in  std_logic_vector(7 downto 0);	
			sout			: out	std_logic;							
			out_dado	   : out std_logic_vector(7 downto 0);	
			pronto		: out std_logic							
		);
	end component;

	 component contador_m is
			 generic (
					 constant M : integer := 27;
					 constant N : integer := 5
			 );
			 port (
					 clock : in  std_logic;
					 zera  : in  std_logic;
					 conta : in  std_logic;
					 Q     : out std_logic_vector (N-1 downto 0);
					 fim   : out std_logic;
					 meio  : out std_logic
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

	 component hex7seg is
    port (
			hexa : in  std_logic_vector(3 downto 0);
			sseg : out std_logic_vector(6 downto 0)
    );
	 end component;

	 component ascii_to_5bit is
		port(
			ascii : in std_logic_vector(6 downto 0);
			fivebit : out std_logic_vector(4 downto 0)
		);
	 end component;

	 component bit_to_ascii is
    port(
			fivebit : in std_logic_vector(4 downto 0);
			ascii : out std_logic_vector(6 downto 0)
    );
	 end component;

	signal s_set_config, s_reset_rx, s_limpa_rx, s_anel_not_pos_ini, s_gira, s_tem_dado, s_pronto_config_plug, s_pronto_tx, s_transmite, s_conta_plug_config, s_not_clock : std_logic;
	signal s_config_device : std_logic_vector(3 downto 0);
	signal s_entrada : std_logic_vector(4 downto 0) := "00000";
	signal s_letra_visor_1,	s_letra_visor_2, s_letra_visor_3,	s_saida, s_estado : std_logic_vector(4 downto 0);
	signal s_saida_ascii : std_logic_vector(6 downto 0);
	signal s_entrada_ascii,	s_saida_ascii_8b : std_logic_vector(7 downto 0);

begin
	process(clock, s_not_clock)
	begin
		s_not_clock <= not clock;
	end process;

    letter_received : registrador_n
    generic map (
        N => 5
    )
    port map (
        clock => clock,
        clear => reset,
        enable => s_reg_let,
        D => s_entrada_prov,
        Q => s_entrada
    );

	enigma_fd : fd
		port map(
			clock            => s_not_clock,
			reset            => reset,
			entrada          => s_entrada,
			set_config       => s_set_config,
			anel_not_pos_ini => s_anel_not_pos_ini,
			gira             => s_gira,
			config_device    => s_config_device,
			letra_visor_1    => s_letra_visor_1,
			letra_visor_2    => s_letra_visor_2,
			letra_visor_3    => s_letra_visor_3,
			saida            => s_saida
		);

	enigma_uc : uc
		port map(
			clock              => clock,
			reset              => reset,
			tem_dado           => s_tem_dado,
			pronto_config_plug => s_pronto_config_plug,
			pronto_tx          => s_pronto_tx,
			set_config         => s_set_config,
			anel_not_pos_ini   => s_anel_not_pos_ini,
			gira               => s_gira,
			reg_let			 => s_reg_let,
			config_device      => s_config_device,
			transmite          => s_transmite,
			reset_rx           => s_reset_rx,
			estado             => s_estado
		);
	
	s_limpa_rx <= s_reset_rx or reset;
	
	s_conta_plug_config <= '1' when s_set_config = '1' and s_config_device = "1011" else '0';
	
	contador_plug_config : contador_m
		generic map (
			M => 5,
			N => 3
		)
		port map (
			clock => clock,
			zera  => reset,
			conta => s_conta_plug_config,
			Q 	  => open,
			fim   => s_pronto_config_plug,
			meio  => open
		);

	conversor_entrada : ascii_to_5bit
		port map(
			ascii => s_entrada_ascii(6 downto 0),
			fivebit  => s_entrada
		);
	
	
	conversor_saida : bit_to_ascii
    port map(
			fivebit  => s_saida,
			ascii => s_saida_ascii
    );
	
	s_saida_ascii_8b <= '0' & s_saida_ascii;
 
	receptor : rx
		generic map(baudrate => 9600)
		port map(
			clock		=> clock,
			reset		=> reset,
			sin			=> entrada_serial,
			dado		=> s_entrada_ascii,
			fim			=> s_tem_dado
		);

	transmissor : tx
		generic map(
			baudrate => 9600
		)
		port map(
			clock		    => clock,
			reset		    => reset,
			partida  	    => s_transmite,
			dado			=> s_saida_ascii_8b,
			sout			=> saida_serial,
			out_dado	    => open,
			pronto		    => s_pronto_tx
		);

	display: hex7seg 
		port map (
				hexa =>s_estado(3 downto 0),
				sseg => estado_db
		);
end architecture;
