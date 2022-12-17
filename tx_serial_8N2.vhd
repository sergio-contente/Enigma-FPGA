library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tx_serial_8N2 is
    port (
        clock, reset, partida: in  std_logic;
        protocol             : in  std_logic;
        dados_ascii          : in  std_logic_vector (7 downto 0);
        saida_serial, pronto : out std_logic;
        saida_protocol       : out std_logic;
        reset_o, partida_o   : out std_logic;
        dados_ascii_o        : out std_logic_vector (7 downto 0)
    );
end entity;

architecture tx_serial_8N2_arch of tx_serial_8N2 is
     
    component tx_serial_tick_uc port ( 
            clock, reset, partida, tick, fim:      in  std_logic;
            zera, conta, carrega, desloca, pronto: out std_logic 
    );
    end component;

    component tx_serial_8N2_fd port (
        clock, reset: in std_logic;
        zera, conta, carrega, desloca: in std_logic;
		  protocol: in  std_logic;
        dados_ascii: in std_logic_vector (7 downto 0);
        saida_serial, fim : out std_logic
    );
    end component;
    
    component contador_m
    generic (
        constant M: integer; 
        constant N: integer 
    );
    port (
        clock, zera, conta: in std_logic;
        Q: out std_logic_vector (N-1 downto 0);
        fim: out std_logic
    );
    end component;
    
    component edge_detector is port ( 
             clock         : in   std_logic;
             signal_in   : in   std_logic;
             outputt      : out  std_logic
    );
    end component;
    
    signal s_reset, s_partida, s_partida_ed, s_protocol: std_logic;
    signal s_zera, s_conta, s_carrega, s_desloca, s_tick, s_fim: std_logic;
	 signal s_saida: std_logic;

begin

    -- sinais resetm, partida e protocol mapeados na GPIO (ativos em alto)
    s_reset   <= reset;
    s_partida <= partida;
	 s_protocol <= protocol;

    -- unidade de controle
    U1_UC: tx_serial_tick_uc port map (clock, s_reset, s_partida_ed, s_tick, s_fim,
                                       s_zera, s_conta, s_carrega, s_desloca, pronto);

    -- fluxo de dados
    U2_FD: tx_serial_8N2_fd port map (clock, s_reset, s_zera, s_conta, s_carrega, s_desloca, 
                                      s_protocol, dados_ascii, s_saida, s_fim);

    -- gerador de tick
    -- fator de divisao 50MHz para 9.600 bauds (5208=50M/9600), 13 bits
    U3_TICK: contador_m generic map (M => 434, N => 13) port map (clock, s_zera, '1', open, s_tick);
 
    -- detetor de borda para tratar pulsos largos
    U4_ED: edge_detector port map (clock, s_partida, s_partida_ed);
	 
	 reset_o <= reset;
	 partida_o <= partida;
	 dados_ascii_o <= dados_ascii;
	 saida_protocol <= s_saida;
	 saida_serial <= s_saida;
    
end architecture;

