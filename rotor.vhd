library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity rotor is
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
end rotor;

architecture rotor_arch of rotor is
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

    component rotor_turnover is
        port(
                rotor_type : in std_logic_vector(2 downto 0); -- Temos 5 tipos diferentes de Rotor (I, II, III, IV e V)
                current_letter : in  std_logic_vector(4 downto 0); -- Valor atual da letra mostrada no rotor
                turnover_rotor : out  std_logic -- Se deve rotacionar ou nao o proximo rotor
            ); 
    end component;

    component contador_m is
        generic (
            constant M : integer := 26;  
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

	component translator_I is
    port (
				enable   : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
	end component;

	component translator_II is
    port (
				enable   : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
	end component;

	component translator_III is
    port (
				enable   : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
	end component;

	component translator_IV is
    port (
				enable   : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
	end component;

	component translator_V is
    port (
				enable   : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
	end component;

    signal s_gira_prox : std_logic;

    signal s_pos_anel, s_pos_ini, s_rot_atual, s_entrada_dir, s_saida_dir, s_conex_dir_in, s_conex_dir_out, s_conex_inv_out,
           s_conex_dir_out_1, s_conex_dir_out_2, s_conex_dir_out_3, s_conex_dir_out_4, s_conex_dir_out_5,
           s_conex_inv_out_1, s_conex_inv_out_2, s_conex_inv_out_3, s_conex_inv_out_4, s_conex_inv_out_5,
           s_entrada_inv, s_saida_inv, s_conex_inv_in, s_letra_visor, s_pos_rotor : std_logic_vector(4 downto 0);

begin
    s_entrada_dir <= entrada_dir;
    saida_dir <= s_saida_dir;
    s_entrada_inv <= entrada_inv;
    saida_inv <= s_saida_inv;
    
    letra_visor <= s_letra_visor;
    s_letra_visor <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_pos_ini))
                                                   + to_integer(unsigned(s_rot_atual))) mod 26), s_conex_dir_in'length));

    turnover_prox : rotor_turnover
        port map(
                rotor_type     => rotor_type,
                current_letter => s_pos_rotor,
                turnover_rotor => s_gira_prox
            );
    gira_prox <= s_gira_prox;
    s_pos_rotor <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_pos_ini))
                                                + to_integer(unsigned(s_rot_atual))) mod 26), s_conex_dir_in'length));

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
			M => 26,
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
                                                   - to_integer(unsigned(s_pos_anel))) mod 26), s_conex_dir_in'length));

    tradutor_I_dir : translator_I
        port map (
            enable   => rotor_type,
            original => s_conex_dir_in, -- Letra do comeco 
            direction => '0',
            saida    =>  s_conex_dir_out_1-- Combinacao
    ); 
    
    tradutor_II_dir : translator_II
        port map (
            enable   => rotor_type,
            original => s_conex_dir_in, -- Letra do comeco 
            direction => '0',
            saida    =>  s_conex_dir_out_2-- Combinacao
    ); 
    
    tradutor_III_dir : translator_III
        port map (
            enable   => rotor_type,
            original => s_conex_dir_in, -- Letra do comeco 
            direction => '0',
            saida    =>  s_conex_dir_out_3-- Combinacao
    ); 
    
    tradutor_IV_dir : translator_IV
        port map (
            enable   => rotor_type,
            original => s_conex_dir_in, -- Letra do comeco 
            direction => '0',
            saida    =>  s_conex_dir_out_4-- Combinacao
    ); 
    
    tradutor_V_dir : translator_V
        port map (
            enable   => rotor_type,
            original => s_conex_dir_in, -- Letra do comeco 
            direction => '0',
            saida    =>  s_conex_dir_out_5-- Combinacao
    );

    s_conex_dir_out <= s_conex_dir_out_1 when rotor_type = "000" else
                       s_conex_dir_out_2 when rotor_type = "001" else
                       s_conex_dir_out_3 when rotor_type = "010" else
                       s_conex_dir_out_4 when rotor_type = "011" else
                       s_conex_dir_out_5 when rotor_type = "100" else
                       "00000";

    s_saida_dir <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_conex_dir_out))
                                                - to_integer(unsigned(s_pos_ini))
                                                - to_integer(unsigned(s_rot_atual))
                                                + to_integer(unsigned(s_pos_anel))) mod 26), s_conex_dir_in'length));

    s_conex_inv_in <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_entrada_inv))
                                                   + to_integer(unsigned(s_pos_ini))
                                                   + to_integer(unsigned(s_rot_atual))
                                                   - to_integer(unsigned(s_pos_anel))) mod 26), s_conex_inv_in'length));

    tradutor_I_inv : translator_I
        port map (
            enable   => rotor_type,
            original => s_conex_inv_in, -- Letra do comeco 
            direction => '1',
            saida    =>  s_conex_inv_out_1-- Combinacao
    ); 
    
    tradutor_II_inv : translator_II
        port map (
            enable   => rotor_type,
            original => s_conex_inv_in, -- Letra do comeco 
            direction => '1',
            saida    =>  s_conex_inv_out_2-- Combinacao
    ); 
    
    tradutor_III_inv : translator_III
        port map (
            enable   => rotor_type,
            original => s_conex_inv_in, -- Letra do comeco 
            direction => '1',
            saida    =>  s_conex_inv_out_3-- Combinacao
    ); 
    
    tradutor_IV_inv : translator_IV
        port map (
            enable   => rotor_type,
            original => s_conex_inv_in, -- Letra do comeco 
            direction => '1',
            saida    =>  s_conex_inv_out_4-- Combinacao
    ); 
    
    tradutor_V_inv : translator_V
        port map (
            enable   => rotor_type,
            original => s_conex_inv_in, -- Letra do comeco 
            direction => '1',
            saida    =>  s_conex_inv_out_5-- Combinacao
    );

    s_conex_inv_out <= s_conex_inv_out_1 when rotor_type = "000" else
                       s_conex_inv_out_2 when rotor_type = "001" else
                       s_conex_inv_out_3 when rotor_type = "010" else
                       s_conex_inv_out_4 when rotor_type = "011" else
                       s_conex_inv_out_5 when rotor_type = "100" else
                       "00000";

    s_saida_inv <= std_logic_vector(to_unsigned(((to_integer(unsigned(s_conex_inv_out))
                                                - to_integer(unsigned(s_pos_ini))
                                                - to_integer(unsigned(s_rot_atual))
                                                + to_integer(unsigned(s_pos_anel))) mod 26), s_conex_inv_out'length));

end architecture;
