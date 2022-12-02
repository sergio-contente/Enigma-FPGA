------------------------------------------------------------------
-- Arquivo   : rx_serial_7E2.vhd
-- Projeto   : Experiencia 2 - Transmissao Serial Assincrona
------------------------------------------------------------------
-- Descricao : circuito base da experiencia 2 
--             > implementa configuracao 8N2
--             > 
--             > componente edge_detector (U4) trata pulsos largos
--             > da entrada PARTIDA (veja linha 139)
------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     09/09/2021  1.0     Edson Midorikawa  versao inicial
--     31/08/2022  2.0     Edson Midorikawa  revisao do codigo
------------------------------------------------------------------
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_serial_7E2 is
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
   end entity;

architecture rx_serial_7E2_arch of rx_serial_7E2 is
     
    component rx_serial_uc 
    port ( 
        clock       : in  std_logic;
        reset       : in  std_logic;
        tick        : in  std_logic;
        fim         : in  std_logic;
        dado_serial : in std_logic;
        zera        : out std_logic;
        conta       : out std_logic;
        carrega     : out std_logic;
        desloca     : out std_logic;
        pronto      : out std_logic;
        limpa       : out std_logic;
        registra    : out std_logic;
        tem_dado    : out std_logic;
        estado      : out std_logic_vector (3 downto 0)
    );
    end component;

    component rx_serial_7E2_fd 
    port (
        clock : in std_logic;
        reset : in std_logic;
        limpa   : in std_logic;
        carrega : in std_logic;
        zera    : in std_logic;
        desloca : in std_logic;
        conta   : in std_logic;
        registra : in std_logic;
        pronto  : in std_logic;
        tem_dado    : in std_logic;
        entrada_serial : in std_logic;
        fim     :   out std_logic;
        dado_recebido: out std_logic_vector(8 downto 0)
    );
    end component;

    component testador_paridade is
        port (
            dado     : in  std_logic_vector (6 downto 0);
            paridade : in  std_logic;
            par_ok   : out std_logic;
            impar_ok : out std_logic
        );
    end component;
    
    component contador_m
    generic (
        constant M : integer;
        constant N : integer
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
    
    component edge_detector 
    port (  
        clock     : in  std_logic;
        signal_in : in  std_logic;
        outputt    : out std_logic
    );
    end component;

    component hex7seg
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;
    
    signal s_reset, s_par_ok, s_impar_ok, s_dado_serial, s_dado_serial_ed: std_logic;
    signal s_zera, s_tick, s_fim: std_logic;
    signal s_saida_serial, s_conta, s_carrega, s_desloca, s_pronto, s_limpa, s_registra, s_tem_dado: std_logic;
    signal s_dado_recebido: std_logic_vector(8 downto 0);

begin

    -- sinais reset e partida ativos em alto
    s_reset   <= reset;
    pronto_rx <= s_pronto;

    U1_UC: rx_serial_uc
           port map (
            clock       => clock,
            reset       => s_reset,
            tick        => s_tick,
            fim         => s_fim,
            dado_serial => s_dado_serial,
            zera        => s_zera,
            conta       => s_conta,
            carrega     => s_carrega,
            desloca     => s_desloca,
            pronto      => s_pronto,
            limpa       => s_limpa,
            registra    => s_registra,
            tem_dado    => s_tem_dado
           );

    U2_FD: rx_serial_7E2_fd 
    port map(
        clock   => clock,
        reset   => s_reset,
        limpa   => s_limpa,
        carrega => s_carrega,
        zera    => s_zera,
        desloca => s_desloca,
        conta   => s_conta,
        registra => s_registra,
        pronto  => s_pronto,
        tem_dado   => s_tem_dado,
        entrada_serial => s_dado_serial,
        fim     => s_fim,
        dado_recebido => s_dado_recebido
        );
	
	dado_recebido <= s_dado_recebido(7 downto 1);

    tem_dado <= s_tem_dado;
    -- gerador de tick
    -- fator de divisao para 9600 bauds (5208=50M/9600)
    -- fator de divisao para 115.200 bauds (434=50M/115200)
    U3_TICK: contador_m 
             generic map (
                 M => 434, -- 115200 bauds
                 N => 13
             ) 
             port map (
                 clock => clock, 
                 zera  => s_zera, 
                 conta => '1', 
                 Q     => open, 
                 fim   => open,
                 meio  => s_tick
             );
 
    s_dado_serial <= dado_serial;
    U4_ED: edge_detector 
           port map (
               clock     => clock,
               signal_in => s_dado_serial,
               outputt   => s_dado_serial_ed
           );
    
    -- saida

    testador: testador_paridade
        port map(
            dado     => s_dado_recebido (7 downto 1),
            paridade => s_dado_recebido(0),
            par_ok   => s_par_ok,
            impar_ok => s_impar_ok
        );

    paridade_ok <= s_par_ok;
    paridade_recebida <= s_dado_recebido(0);

end architecture;

