library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity rotor_I is
    port(
        clock : in std_logic;
        reset : in std_logic;
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
end rotor_I;

architecture rotor_I_arch of rotor_I is
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

    component rom_rotor_I_dir is
        port (
            endereco : in  std_logic_vector(4 downto 0);
            saida    : out std_logic_vector(4 downto 0)
        );
    end component;

    component rom_rotor_I_inv is
        port (
            endereco : in  std_logic_vector(4 downto 0);
            saida    : out std_logic_vector(4 downto 0)
        ); 
    end component;

    signal s_pos_anel, s_pos_ini, s_rot_atual, s_entrada_dir, s_saida_dir, s_conex_dir_in, s_conex_dir_out, 
           s_entrada_inv, s_saida_inv, s_conex_inv_in, s_conex_inv_out, s_letra_visor, s_pos_rotor : std_logic_vector(4 downto 0);

begin
    entrada_dir <= s_entrada_dir;
    saida_dir <= s_saida_dir;
    entrada_inv <= s_entrada_inv;
    saida_inv <= s_saida_inv;
    
    letra_visor <= s_letra_visor;
    s_letra_visor <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_pos_ini))
                                                   + to_integer(unsigned(s_rot_atual))) mod 27), s_conex_dir_in'length));

    gira_prox <= s_gira_prox;
    s_gira_prox <= '1' when s_pos_rotor = "10000" else '0';
    s_pos_rotor <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_pos_ini))
                                                + to_integer(unsigned(s_rot_atual))
                                                - to_integer(unsigned(s_pos_anel))) mod 27), s_conex_dir_in'length));

    anel_config : registrador_n
        generic map (
            N => 5
        )
        port map (
			clock => clock,
			clear => reset,
			enable => set_anel,
			D => entrada_config,
			Q => s_pos_anel
        );

    pos_ini_config : registrador_n
        generic map (
            N => 5
        )
        port map (
			clock => clock,
			clear => reset,
			enable => set_pos_ini,
			D => entrada_config,
			Q => s_pos_ini
        );

	rotacao : contador_m
		generic map (
			M => 27,
			N => 5
		)
		port map (
			clock => clock,
			zera  => reset,
			conta => gira_rotor,
			Q 	  => s_rot_atual,
			fim   => open,
			meio  => open
		);

    s_conex_dir_in <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_entrada_dir))
                                                   + to_integer(unsigned(s_pos_ini))
                                                   + to_integer(unsigned(s_rot_atual))
                                                   - to_integer(unsigned(s_pos_anel))) mod 27), s_conex_dir_in'length));

    conexoes_dir : rom_rotor_I_dir
        port (
            endereco => s_conex_dir_in,
            saida    => s_conex_dir_out
        );

    s_saida_dir <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_conex_dir_out))
                                                - to_integer(unsigned(s_pos_ini))
                                                - to_integer(unsigned(s_rot_atual))
                                                + to_integer(unsigned(s_pos_anel))) mod 27), s_conex_dir_in'length));

    s_conex_inv_in <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_entrada_inv))
                                                   + to_integer(unsigned(s_pos_ini))
                                                   + to_integer(unsigned(s_rot_atual))
                                                   - to_integer(unsigned(s_pos_anel))) mod 27), s_conex_inv_in'length));

    conexoes_inv : rom_rotor_I_inv
        port (
            endereco => s_conex_inv_in,
            saida    => s_conex_inv_out
        );

    s_saida_inv <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_conex_inv_out))
                                                - to_integer(unsigned(s_pos_ini))
                                                - to_integer(unsigned(s_rot_atual))
                                                + to_integer(unsigned(s_pos_anel))) mod 27), s_conex_inv_out'length));

end architecture;