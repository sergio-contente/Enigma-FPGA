------------------------------------------------------------------
-- Arquivo   : rx_serial_7E2_fd.vhd
-- Projeto   : Experiencia 3 - Recepcao Serial Assincrona
------------------------------------------------------------------
-- Descricao : fluxo de dados do circuito da experiencia 3 
--             > implementa configuracao 7E2
--             > 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rx_serial_7E2_fd is
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
   end entity;

architecture rx_serial_7E2_fd_arch of rx_serial_7E2_fd is
     
    component deslocador_n
    generic (
        constant N : integer
    );
    port (
        clock          : in  std_logic;
        reset          : in  std_logic;
        carrega        : in  std_logic; 
        desloca        : in  std_logic; 
        entrada_serial : in  std_logic; 
        dados          : in  std_logic_vector (N-1 downto 0);
        saida          : out std_logic_vector (N-1 downto 0)
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

    signal s_dados, s_saida: std_logic_vector (11 downto 0);
	signal paridade: std_logic;
begin
    reg_desloc: deslocador_n 
        generic map (
            N => 12
        )  
        port map (
            clock          => clock, 
            reset          => reset, 
            carrega        => carrega, 
            desloca        => desloca, 
            entrada_serial => entrada_serial, 
            dados          => s_dados, 
            saida          => s_saida
        );

    

    registrador: registrador_n
        generic map(
            N => 9
        )
        port map(
           clock    => clock,
           clear    => limpa,
           enable   => registra,
           D        => s_saida(9 downto 1),
           Q        => dado_recebido 
        );

        U2: contador_m 
        generic map (
            M => 12, 
            N => 4
        ) 
        port map (
            clock => clock, 
            zera  => zera, 
            conta => conta, 
            Q     => open, 
            fim   => fim,
            meio  => open
        );

    
end architecture;

