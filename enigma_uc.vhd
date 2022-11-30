------------------------------------------------------------------
-- Arquivo   : enigma_uc.vhd
-- Projeto   : Experiencia 3 - Recepcao Serial Assincrona
------------------------------------------------------------------
-- Descricao : unidade de controle do circuito da experiencia 3 
--             > implementa superamostragem (tick)
--             > 
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- SE RECEBER UM SINAL DE ! ELE PARA DE MEXER NA PLUGBOARD
-- ! = "11110"

entity enigma_uc is 
    port ( 
        clock       : in  std_logic;
        reset       : in  std_logic;

        letter_user : in std_logic_vector(4 downto 0);

        first_rotor_type : in std_logic_vector(2 downto 0);
        second_rotor_type : in std_logic_vector(2 downto 0);
        third_rotor_type : in std_logic_vector(2 downto 0);

        first_ring_pos : in std_logic_vector(4 downto 0);
        second_ring_pos : in std_logic_vector(4 downto 0);
        third_ring_pos : in std_logic_vector(4 downto 0);

        first_rotor_pos : in std_logic_vector(4 downto 0);
        second_ring_pos : in std_logic_vector(4 downto 0);
        third_ring_pos : in std_logic_vector(4 downto 0);

        reflector_type : in std_logic_vector(1 downto 0);

        fim_first_preprocess: in std_logic;
        fim_second_preprocess: in std_logic;
        fim_third_preprocess: in std_logic;

        gira_primeiro  : in std_logic;
        gira_segundo  : in std_logic;
        gira_terceiro : in std_logic;

        third_letter_out : in std_logic;

        envia_gira_primeiro  : out std_logic;
        envia_gira_segundo  : out std_logic;
        envia_gira_terceiro : out std_logic;

        tem_dado : out std_logic;

        setup_plugboard: out std_logic;

        setup_refletor : out std_logic;

        setup_first_ring: out std_logic;
        setup_second_ring: out std_logic;
        setup_third_ring: out std_logic;

        setup_first_pos: out std_logic;
        setup_second_pos: out std_logic;
        setup_third_pos: out std_logic;

        setup_first_type: out std_logic;
        setup_second_type: out std_logic;
        setup_third_type: out std_logic;

        ativa_reflector: out std_logic;

        letra_refletida : out std_logic_vector(4 downto 0)

    );
end entity;

architecture enigma_uc_arch of enigma_uc is

    type tipo_estado is (inicial, zera, set_plugboard, set_refletor, set_first_ring, set_second_ring, set_third_ring, 
    set_first_pos, set_second_post, set_third_pos, set_first_type, set_second_type, set_third_type,
    preprocessamento_primeiro, rotaciona_primeiro, preprocessamento_segundo, rotaciona_segundo, preprocessamento_terceiro, rotaciona_terceiro,
    reflete, final);
    signal Eatual: tipo_estado;  -- estado atual
    signal Eprox:  tipo_estado;  -- proximo estado

begin

  -- memoria de estado
  process (reset, clock)
  begin
      if reset = '1' then
          Eatual <= inicial;
      elsif clock'event and clock = '1' then
          Eatual <= Eprox; 
      end if;
  end process;

  -- logica de proximo estado
  process (dado_serial, tick, fim, Eatual) 
  begin

    case Eatual is

      when inicial =>      if dado_serial='0' then Eprox <= preparacao;
                           else                Eprox <= inicial;
                           end if;

      when preparacao =>   Eprox <= espera;

      when espera =>       if tick='1'                    then   Eprox <= recepcao;
                           elsif fim='0' and tick = '0'   then   Eprox <= espera;
                           elsif tick = '0' and fim = '1' then   Eprox <= armazenamento;
                           end if;

      when recepcao =>      Eprox <= espera;

      when armazenamento => Eprox <= final;

      when final =>         Eprox <= dado_presente;

      when dado_presente => if dado_serial = '1' then Eprox <= dado_presente;
                            else Eprox <= preparacao;
                            end if;
                                
      when others =>       Eprox <= inicial;

    end case;

  end process;
  -- logica de saida (Moore)
  with Eatual select
      carrega <= '1' when preparacao, '0' when others;

  with Eatual select
      zera <= '1' when preparacao, '0' when others;

  with Eatual select
      limpa <= '1' when preparacao, '0' when others;

  with Eatual select
      desloca <= '1' when recepcao, '0' when others;

  with Eatual select
      conta <= '1' when recepcao, '0' when others;

  with Eatual select
      pronto <= '1' when final, '0' when others;

  with Eatual select
      registra <= '1' when armazenamento, '0' when others;

  with Eatual select
      tem_dado <= '1' when dado_presente, '0' when others;

-- logica db_estado
    with Eatual select
        estado <= "0000" when inicial,
                  "0001" when preparacao,
                  "0010" when espera,
                  "0011" when recepcao,
                  "0100" when armazenamento,
                  "0101" when final,
                  "0110" when dado_presente,
                  "1111" when others;

end architecture enigma_uc_arch;
