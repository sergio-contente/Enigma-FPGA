------------------------------ENIGMA-------------------------------------
-- Arquivo   : rotor_rotate.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Consiste no rotacionamento dos rotores que sao responsaveis
--							por combinar as letras de entrada.
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     23/11/2022  1.0     Sergio Magalhaes Contente 		criacao
------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity rotor_rotate is
	port (
		clock : in std_logic;
		clear : in std_logic;
		enable_rotation : in std_logic;
		rotor_letter_in : in std_logic_vector(4 downto 0);
		rotor_type_in : in std_logic_vector(2 downto 0);
		rotor_out : out std_logic_vector(4 downto 0);
		rotate_next_rotor : out std_logic
	);
end rotor_rotate;

architecture rotor_rotate_arch of rotor_rotate is

-- =========INSTANCIACAO DE COMPONENTES ========================== --
----------------------------------Contador ------------------------------------------------------------------------------
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
------------------------------------------------------Entalho do Rotor-------------------------------------------------
component rotor_turnover is
	port(
			rotor_type : in std_logic_vector(2 downto 0); -- Temos 5 tipos diferentes de Rotor (I, II, III, IV e V)
			current_letter : in  std_logic_vector(4 downto 0); -- Valor atual da letra mostrada no rotor
		  turnover_rotor : out  std_logic -- Se deve rotacionar ou nao o proximo rotor
		); 
end component;

----======= Sinais internos =============----------------------------------------------------------------------------

 signal s_letter: std_logic_vector(4 downto 0);
 signal s_turnover : std_logic;

begin

 turnover_checker : rotor_turnover 
 		port map (
			rotor_type => rotor_type_in,
			current_letter => rotor_letter_in,
			turnover_rotor => s_turnover
		);

	gira_rotor: contador_m
		generic map (
			M => 27,
			N => 5
		)
		port map (
			clock => clock,
			zera  => clear,
			conta => enable_rotation,
			Q 		=> s_letter,
			fim   => open,
			meio  => open
		);


		rotate_next_rotor <= s_turnover; --Se vai ou nao girar o proximo rotor
		rotor_out <= s_letter; --Valor atual do rotor

end architecture;
