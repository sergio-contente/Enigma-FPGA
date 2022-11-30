library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fd is
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
end fd;

architecture fd_arch of fd is
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
            clock : in std_logic;
            reset : in std_logic;
            rotor_type : in std_logic_vector(2 downto 0);
            entrada_config : in std_logic_vector(4 downto 0);
            entrada_dir : in std_logic_vector(4 downto 0);
            entrada_inv : in std_logic_vector(4 downto 0);
            set_anel : in std_logic;
            set_pos_ini : in std_logic;
            gira_rotor : in std_logic;
            letra_visor : out std_logic_vector(4 downto 0);
            saida_dir : out std_logic_vector(4 downto 0);
            saida_inv : out std_logic_vector(4 downto 0);
            gira_prox : out std_logic
        );
    end component;

    component plugboard_2way is
        port(
            clock : in  std_logic;
            clear : in  std_logic;
            switch_letters : in std_logic; -- Enable para trocar original_letter com new_letter
            from_letter_dir : in std_logic_vector(4 downto 0); -- Letra original
            to_letter : in std_logic_vector(4 downto 0); -- Letra a ser trocada para o endereco da original
            from_letter_inv : in std_logic_vector(4 downto 0);
            final_letter_dir : out std_logic_vector(4 downto 0);  
            final_letter_inv : out std_logic_vector(4 downto 0)
        );
    end component;

    component reflector is
        port(
            reflector_type : in std_logic_vector(1 downto 0); -- "00": TIPO A, "01": TIPO B, "10": TIPO C
            letter_in : in std_logic_vector(4 downto 0);
            letter_out: out std_logic_vector(4 downto 0)
        );
    end component;

    signal s_plug_config_enable, s_rotor_1_enable, s_rotor_2_enable, s_rotor_3_enable, s_reflector_enable,
           s_set_anel_1, s_set_pos_1, s_gira_prox_1, s_set_anel_2, s_set_pos_2, s_gira_2, s_gira_prox_2,
           s_set_anel_3, s_set_pos_3, s_gira_3, s_switch_letters : std_logic;

    signal s_reflector_type : std_logic_vector(1 downto 0);
    
    signal s_rotor_1_type, s_rotor_2_type, s_rotor_3_type : std_logic_vector(2 downto 0);
    
    signal s_entrada_dir_1, s_saida_dir_1, s_entrada_inv_1, s_saida_inv_1, s_to_letter,
           s_entrada_dir_2, s_saida_dir_2, s_entrada_inv_2, s_saida_inv_2,
           s_entrada_dir_3, s_saida_dir_3, s_entrada_inv_3, s_saida_inv_3, : std_logic_vector(4 downto 0);
begin

    s_plug_config_enable <= '1' when set_config = '1' and config_device = "0000" else '0';

    plugboard_to_letter_temp : registrador_n
    generic map (
        N => 5
    )
    port map (
        clock => clock,
        clear => reset,
        enable => s_plug_config_enable,
        D => entrada,
        Q => s_to_letter
    );

    s_rotor_1_enable <= '1' when set_config = '1' and config_device = "0001" else '0';

    rotor_1_type : registrador_n
    generic map (
        N => 5
    )
    port map (
        clock => clock,
        clear => reset,
        enable => s_rotor_1_enable,
        D => entrada(2 downto 0),
        Q => s_rotor_1_type
    );

    s_rotor_2_enable <= '1' when set_config = '1' and config_device = "0100" else '0';

    rotor_2_type : registrador_n
    generic map (
        N => 5
    )
    port map (
        clock => clock,
        clear => reset,
        enable => s_rotor_2_enable,
        D => entrada(2 downto 0),
        Q => s_rotor_2_type
    );

    s_rotor_3_enable <= '1' when set_config = '1' and config_device = "0111" else '0';

    rotor_3_type : registrador_n
    generic map (
        N => 5
    )
    port map (
        clock => clock,
        clear => reset,
        enable => s_rotor_3_enable,
        D => entrada(2 downto 0),
        Q => s_rotor_3_type
    );

    s_reflector_enable <= '1' when set_config = '1' and config_device = "1010" else '0';

    reflector_type : registrador_n
    generic map (
        N => 5
    )
    port map (
        clock => clock,
        clear => reset,
        enable => s_reflector_enable,
        D => entrada(1 downto 0),
        Q => s_reflector_type
    );

    s_switch_letters <= '1' when set_config = '1' and config_device = "1011" else '0';

    plugboard : plugboard_2way
        port map(
            clock            => clock,
            clear            => reset,
            switch_letters   => s_switch_letters,
            from_letter_dir  => entrada,
            to_letter        => s_to_letter,
            from_letter_inv  => s_saida_inv_1,
            final_letter_dir => s_entrada_dir_1,
            final_letter_inv => saida
        );

    s_set_anel_1 <= '1' when set_config = '1' and config_device = "0010" else '0';
    s_set_pos_1 <= '1' when set_config = '1' and config_device = "0011" else '0';

    rotor_1 : rotor
        port map(
            clock          => clock,
            reset          => reset,
            rotor_type     => s_rotor_1_type,
            entrada_config => entrada,
            entrada_dir    => s_entrada_dir_1,
            entrada_inv    => s_entrada_inv_1,
            set_anel       => s_set_anel_1,
            set_pos_ini    => s_set_pos_1,
            gira_rotor     => gira,
            letra_visor    => letra_visor_1,
            saida_dir      => s_saida_dir_1,
            saida_inv      => s_saida_inv_1,
            gira_prox      => s_gira_prox_1
        );

    s_set_anel_2 <= '1' when set_config = '1' and config_device = "0101" else '0';
    s_set_pos_2 <= '1' when set_config = '1' and config_device = "0110" else '0';
    s_gira_2 <= '1' when gira = '1' and s_gira_prox_1 = '1' else '0';

    rotor_2 : rotor
        port map(
            clock          => clock,
            reset          => reset,
            rotor_type     => s_rotor_2_type,
            entrada_config => entrada,
            entrada_dir    => s_saida_dir_1,
            entrada_inv    => s_entrada_inv_2,
            set_anel       => s_set_anel_2,
            set_pos_ini    => s_set_pos_2,
            gira_rotor     => s_gira_2,
            letra_visor    => letra_visor_2,
            saida_dir      => s_saida_dir_2,
            saida_inv      => s_entrada_inv_1,
            gira_prox      => s_gira_prox_2
        );

    s_set_anel_3 <= '1' when set_config = '1' and config_device = "1000" else '0';
    s_set_pos_3 <= '1' when set_config = '1' and config_device = "1001" else '0';
    s_gira_3 <= '1' when gira = '1' and s_gira_prox_1 = '1' and s_gira_prox_2 = '1' else '0';

    rotor_3 : rotor
        port map(
            clock          => clock,
            reset          => reset,
            rotor_type     => s_rotor_3_type,
            entrada_config => entrada,
            entrada_dir    => s_saida_dir_2,
            entrada_inv    => s_entrada_inv_3,
            set_anel       => s_set_anel_3,
            set_pos_ini    => s_set_pos_3,
            gira_rotor     => s_gira_3,
            letra_visor    => letra_visor_3,
            saida_dir      => s_saida_dir_3,
            saida_inv      => s_entrada_inv_2,
            gira_prox      => open
        );

    reflector : reflector
        port map(
            reflector_type => s_reflector_type,
            letter_in      => s_saida_dir_3,
            letter_out     => s_entrada_inv_3
        );

end architecture;