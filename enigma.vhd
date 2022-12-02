library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity enigma is
	port(
		clock : in  std_logic;
		reset : in std_logic;
		entrada_serial : in std_logic;
		saida_serial : out std_logic;
		rotor_1 : out std_logic_vector(6 downto 0);
		rotor_2 : out std_logic_vector(6 downto 0);
		rotor_3 : out std_logic_vector(6 downto 0);
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
        config_device : out std_logic_vector(3 downto 0);
        transmite : out std_logic;
        estado : out std_logic_vector(4 downto 0)
    );
	end component;

	component rx_serial_7E2 is
    port (
        clock : in std_logic;
        reset : in std_logic;
        dado_serial : in std_logic;
        dado_recebido : out std_logic_vector(6 downto 0);
        paridade_recebida : out std_logic;
        tem_dado : out std_logic;
        paridade_ok : out std_logic;
        pronto_rx : out std_logic
    );
   end component;

	 component tx_serial_8N2 is
    port (
        clock, reset, partida: in  std_logic;
        protocol             : in  std_logic;
        dados_ascii          : in  std_logic_vector (7 downto 0);
        saida_serial, pronto : out std_logic;
        saida_protocol       : out std_logic;
        reset_o, partida_o   : out std_logic;
        dados_ascii_o        : out std_logic_vector (7 downto 0)
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
				ascii : in std_logic(6 downto 0);
				5bit : out std_logic(4 downto 0)
		);
	 end component;

	 component bit_to_ascii is
    port(
        5bit : out std_logic(4 downto 0);
        ascii : in std_logic(6 downto 0)
    );
	 end component;
begin
	enigma_fd : fd
		port map(
			clock            => clock,
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
			config_device      => s_config_device,
			transmite          => s_transmite,
			estado             => s_estado
		);
end architecture;
