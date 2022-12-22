library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity enigma_tb is
end entity;

architecture tb of enigma_tb is
  
    -- Declara��o de sinais para conectar o componente a ser testado (DUT)
    signal clock_in              : std_logic  := '0';
    signal reset_in              : std_logic  := '0';
    -- saidas
    signal saida_serial_out      : std_logic  := '0';
    signal estado_db_out         : std_logic_vector(6 downto 0) := "0000000";
  
    -- para procedimento UART_WRITE_BYTE
    signal entrada_serial_in : std_logic := '1';
    signal serialData        : std_logic_vector(7 downto 0) := "00000000";
  
    -- Configura��es do clock
    constant clockPeriod : time := 20 ns;            -- 50MHz
    constant bitPeriod   : time := 5208*clockPeriod; -- 5208 clocks por bit (9.600 bauds)
    -- constant bitPeriod   : time := 434*clockPeriod;  -- 434 clocks por bit (115.200 bauds)
    
    ---- UART_WRITE_BYTE()
    -- Procedimento para geracao da sequencia de comunicacao serial 8N2
    -- adaptacao de codigo acessado de:
    -- https://www.nandland.com/goboard/uart-go-board-project-part1.html
    procedure UART_WRITE_BYTE (
        Data_In : in  std_logic_vector(7 downto 0);
        signal Serial_Out : out std_logic ) is
    begin
  
        -- envia Start Bit
        Serial_Out <= '0';
        wait for bitPeriod;
  
        -- envia 8 bits seriais (dados + paridade)
        for ii in 0 to 7 loop
            Serial_Out <= Data_In(ii);
            wait for bitPeriod;
        end loop;  -- loop ii
  
        -- envia 2 Stop Bits
        Serial_Out <= '1';
        wait for 2*bitPeriod;
  
    end UART_WRITE_BYTE;
    -- fim procedure
  
    ---- Array de casos de teste
    type caso_teste_type is record
        id   : natural;
        data : std_logic_vector(7 downto 0);     
    end record;
  
    type casos_teste_array is array (natural range <>) of caso_teste_type;
    constant casos_teste : casos_teste_array :=
        (
            (1, "01000001"),    -- D
            (2, "01000001"),    -- C
            (3, "01000001"),    -- E
            (4, "01000001"),    -- B
            (5, "01000001"),    -- A
            (6, "01000001"),    -- A
            (7, "01000001"),    -- A
            (8, "01000001"),    -- A
            (9, "01000001"),    -- A
            (10, "01000001"),    -- A FIM PLUG CONFIG
            (11, "01000001"),    -- A ROT 1
            (12, "01000001"),    -- A
            (13, "01000001"),    -- A
            (14, "01000010"),    -- B ROT 2
            (15, "01000001"),    -- B
            (16, "01000001"),    -- B
            (17, "01000011"),    -- C ROT 3
            (18, "01000001"),    -- C
            (19, "01000001"),    -- C
            (20, "01000001"),    -- B REFLETOR TIPO 2
            (21, "01010100"),    -- T
            (22, "01000101"),    -- E
            (23, "01010011"),    -- S
            (24, "01010100"),    -- T
            (25, "01000101")     -- E
            -- (21, "01000001"),    -- T
            -- (22, "01000001"),    -- E
            -- (23, "01000001"),    -- S
            -- (24, "01000001"),    -- T
            -- (25, "01000001")     -- E
            -- inserir aqui outros casos de teste (inserir "," na linha anterior)
        );
    signal caso : natural;
  
    ---- controle do clock e simulacao
    signal keep_simulating: std_logic := '0'; -- delimita o tempo de gera��o do clock
  
  
begin
 
    ---- Gerador de Clock
    clock_in <= (not clock_in) and keep_simulating after clockPeriod/2;
    
    -- Instancia��o direta DUT (Device Under Test)
    DUT: entity work.enigma
         port map (  
            clock          => clock_in,
            reset          => reset_in,
            entrada_serial => entrada_serial_in,
            saida_serial   => saida_serial_out,
            -- rotor_1     => ,
            -- rotor_2     => ,
            -- rotor_3     => ,
            estado_db      => estado_db_out
         );
    
    ---- Geracao dos sinais de entrada (estimulo)
    stimulus: process is
    begin
    
        ---- inicio da simulacao
        assert false report "inicio da simulacao" severity note;
        keep_simulating <= '1';
        -- reset com 5 periodos de clock
        reset_in <= '0';
        -- wait for bitPeriod;
        reset_in <= '1', '0' after 5*clockPeriod; 
        wait for bitPeriod;
      
        ---- loop pelos casos de teste
        for i in casos_teste'range loop
            caso <= casos_teste(i).id;
            assert false report "Caso de teste " & integer'image(casos_teste(i).id) severity note;
            serialData <= casos_teste(i).data; -- caso de teste "i"
            -- aguarda 2 periodos de bit antes de enviar bits
            wait for 2*bitPeriod;
      
            -- 1) envia bits seriais para circuito de recepcao
            UART_WRITE_BYTE ( Data_In=>serialData, Serial_Out=>entrada_serial_in );
            entrada_serial_in <= '1'; -- repouso
            wait for bitPeriod;
      
            -- 2) intervalo entre casos de teste
            wait for 2*bitPeriod;
        end loop;
      
        ---- final dos casos de teste da simulacao
        -- reset
        reset_in <= '0';
        wait for bitPeriod;
        reset_in <= '1', '0' after 5*clockPeriod; 
        wait for bitPeriod;
      
        ---- final da simulacao
        assert false report "fim da simulacao" severity note;
        keep_simulating <= '0';
        
        wait; -- fim da simula��o: aguarda indefinidamente
    
    end process stimulus;

end architecture tb;