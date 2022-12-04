library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity uc is
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
end uc;

architecture uc_arch of uc is
    type tipo_estado is (inicial, espera_to_plug, registra_to_letter, espera_from_plug, conf_plug,
                         espera_rot_1, registra_rot_1, espera_anel_1, registra_anel_1, espera_pos_1,
                         registra_pos_1, espera_rot_2, registra_rot_2, espera_anel_2, registra_anel_2,
                         espera_pos_2, registra_pos_2, espera_rot_3, registra_rot_3, espera_anel_3, registra_anel_3,
                         espera_pos_3, registra_pos_3, espera_refl, registra_refl, espera_letra, gira_rot,
                         transmite_cifra);
    signal Eatual: tipo_estado;  -- estado atual
    signal Eprox:  tipo_estado;  -- proximo estado
begin
    process (reset, clock)
    begin
        if reset = '1' then
            Eatual <= inicial;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox; 
        end if;
    end process;

    process (tem_dado, pronto_config_plug, pronto_tx, Eatual) 
    begin
      case Eatual is
  
        when inicial =>             Eprox <= espera_to_plug;
  
        when espera_to_plug =>      if tem_dado='1' then Eprox <= registra_to_letter;
                                    else                 Eprox <= espera_to_plug;
                                    end if;
  
        when registra_to_letter =>      Eprox <= espera_from_plug;
  
        when espera_from_plug =>    if tem_dado='1' then Eprox <= conf_plug;
                                    else                 Eprox <= espera_from_plug;
                                    end if;
  
        when conf_plug =>           if pronto_config_plug='1' then Eprox <= espera_rot_1;
                                    elsif pronto_config_plug='0' then Eprox <= espera_to_plug;
                                    end if;
  
        when espera_rot_1 =>        if tem_dado='1' then Eprox <= registra_rot_1;
                                    else                 Eprox <= espera_rot_1;
                                    end if;
  
        when registra_rot_1 =>      Eprox <= espera_anel_1;
  
        when espera_anel_1 =>       if tem_dado='1' then Eprox <= registra_anel_1;
                                    else                 Eprox <= espera_anel_1;
                                    end if;
  
        when registra_anel_1 =>     Eprox <= espera_pos_1;
  
        when espera_pos_1 =>        if tem_dado='1' then Eprox <= registra_pos_1;
                                    else                 Eprox <= espera_pos_1;
                                    end if;
  
        when registra_pos_1 =>      Eprox <= espera_rot_2;
  
        when espera_rot_2 =>        if tem_dado='1' then Eprox <= registra_rot_2;
                                    else                 Eprox <= espera_rot_2;
                                    end if;
  
        when registra_rot_2 =>      Eprox <= espera_anel_2;
  
        when espera_anel_2 =>       if tem_dado='1' then Eprox <= registra_anel_2;
                                    else                 Eprox <= espera_anel_2;
                                    end if;
  
        when registra_anel_2 =>     Eprox <= espera_pos_2;
  
        when espera_pos_2 =>        if tem_dado='1' then Eprox <= registra_pos_2;
                                    else                 Eprox <= espera_pos_2;
                                    end if;
  
        when registra_pos_2 =>      Eprox <= espera_rot_3;
  
        when espera_rot_3 =>        if tem_dado='1' then Eprox <= registra_rot_3;
                                    else                 Eprox <= espera_rot_3;
                                    end if;
  
        when registra_rot_3 =>      Eprox <= espera_anel_3;
  
        when espera_anel_3 =>       if tem_dado='1' then Eprox <= registra_anel_3;
                                    else                 Eprox <= espera_anel_3;
                                    end if;
  
        when registra_anel_3 =>     Eprox <= espera_pos_3;
  
        when espera_pos_3 =>        if tem_dado='1' then Eprox <= registra_pos_3;
                                    else                 Eprox <= espera_pos_3;
                                    end if;
  
        when registra_pos_3 =>      Eprox <= espera_refl;
  
        when espera_refl =>         if tem_dado='1' then Eprox <= registra_refl;
                                    else                 Eprox <= espera_refl;
                                    end if;
  
        when registra_refl =>       Eprox <= espera_letra;
  
        when espera_letra =>        if tem_dado='1' then Eprox <= gira_rot;
                                    else                 Eprox <= espera_letra;
                                    end if;
  
        when gira_rot =>            Eprox <= transmite_cifra;
  
        when transmite_cifra =>     if pronto_tx='1' then Eprox <= espera_letra;
                                    else                  Eprox <= transmite_cifra;
                                    end if;
                                  
        when others =>              Eprox <= inicial;
  
      end case;
    end process;

    -- logica de saida (Moore)
    with Eatual select
        set_config <= '1' when registra_to_letter,
                      '1' when conf_plug,
                      '1' when registra_rot_1,
                      '1' when registra_anel_1,
                      '1' when registra_pos_1,
                      '1' when registra_rot_2,
                      '1' when registra_anel_2,
                      '1' when registra_pos_2,
                      '1' when registra_rot_3,
                      '1' when registra_anel_3,
                      '1' when registra_pos_3,
                      '1' when registra_refl,
                      '0' when others;
  
    with Eatual select
        config_device <= "0000" when espera_to_plug,
                         "1011" when espera_from_plug,
                         "0001" when espera_rot_1,
                         "0010" when espera_anel_1,
                         "0011" when espera_pos_1,
                         "0100" when espera_rot_2,
                         "0101" when espera_anel_2,
                         "0110" when espera_pos_2,
                         "0111" when espera_rot_3,
                         "1000" when espera_anel_3,
                         "1001" when espera_pos_3,
                         "1010" when espera_refl,
                         "1111" when others;
  
    with Eatual select
        anel_not_pos_ini <= '1' when espera_anel_1,
                            '1' when espera_anel_2,
                            '1' when espera_anel_3,
                            '0' when others;
  
    with Eatual select
        gira <= '1' when gira_rot, '0' when others;
  
    with Eatual select
        transmite <= '1' when transmite_cifra, '0' when others;
  
  -- logica db_estado
      with Eatual select
          estado <= "00000" when inicial,
                    "00001" when espera_to_plug,
                    "00010" when registra_to_letter,
                    "00011" when espera_from_plug,
                    "00100" when conf_plug,
                    "00101" when espera_rot_1,
                    "00110" when registra_rot_1,
                    "00111" when espera_anel_1,
                    "01000" when registra_anel_1,
                    "01001" when espera_pos_1,
                    "01010" when registra_pos_1,
                    "01011" when espera_rot_2,
                    "01100" when registra_rot_2,
                    "01101" when espera_anel_2,
                    "01110" when registra_anel_2,
                    "01111" when espera_pos_2,
                    "10000" when registra_pos_2,
                    "10001" when espera_rot_3,
                    "10010" when registra_rot_3,
                    "10011" when espera_anel_3,
                    "10100" when registra_anel_3,
                    "10101" when espera_pos_3,
                    "10110" when registra_pos_3,
                    "10111" when espera_refl,
                    "11000" when registra_refl,
                    "11001" when espera_letra,
                    "11010" when gira_rot,
                    "11011" when transmite_cifra,
                    "11111" when others;
end architecture;
-- * - reset=1
-- inicial                        - 
-- espera_to_plug                (config_device=0000) - tem_dado=1
-- registra_to_letter                (set_config=1) - 
-- espera_from_plug                (config_device=1011) - tem_dado=1
-- conf_plug                (set_config=1) - pronto_config_plug=(0->espera_to_plug | 1->espera_rot_1)
-- espera_rot_1                (config_device=0001) - tem_dado=1
-- registra_rot_1                (set_config=1) -
-- espera_anel_1                (config_device=0010 and anel_not_pos_ini=1) - tem_dado=1
-- registra_anel_1                (set_config=1) -
-- espera_pos_1                (config_device=0011) - tem_dado=1
-- registra_pos_1                (set_config=1) -
-- espera_rot_2                (config_device=0100) - tem_dado=1
-- registra_rot_2                (set_config=1) -
-- espera_anel_2                (config_device=0101 and anel_not_pos_ini=1) - tem_dado=1
-- registra_anel_2                (set_config=1) -
-- espera_pos_2                (config_device=0110) - tem_dado=1
-- registra_pos_2                (set_config=1) -
-- espera_rot_3                (config_device=0111) - tem_dado=1
-- registra_rot_3                (set_config=1) -
-- espera_anel_3                (config_device=1000 and anel_not_pos_ini=1) - tem_dado=1
-- registra_anel_3                (set_config=1) -
-- espera_pos_3                (config_device=1001) - tem_dado=1
-- registra_pos_3                (set_config=1) -
-- espera_refl                (config_device=1010) - tem_dado=1
-- registra_refl                (set_config=1) -
-- espera_letra             - tem_dado=1
-- gira_rot                (gira=1) -
-- transmite_cifra                (transmite=1) - pronto_tx=1->espera_letra

-- set_config - 0 when others
-- anel_not_pos_ini - 0 when others
-- gira - 0 when others
-- transmite - 0 when others