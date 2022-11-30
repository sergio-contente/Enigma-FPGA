------------------------------ENIGMA-------------------------------------
-- Arquivo   : crypto_unid.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Consiste na pcodificacao da letra final
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     29/11/2022  1.0     Sergio Magalhães Contente     	criacao
------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity CryptoUnit is
	port(
		
	);
end CryptoUnit;

architecture signal_path_arch of CryptoUnit is


component plugboard is
	port(
			clock : in  std_logic;
			clear : in  std_logic;
			switch_letters : in std_logic; -- Enable para trocar original_letter com new_letter
			from_letter : in std_logic_vector(4 downto 0); -- Letra original
			to_letter : in std_logic_vector(4 downto 0); -- Letra a ser trocada para o endereco da original
			final_letter : out std_logic_vector(4 downto 0)
	);
end component;

component SignalPath is
	port(
		clock  : in  std_logic;
		clear : in std_logic;
		direction : in std_logic;
		first_rotor: in std_logic_vector(2 downto 0);
		second_rotor: in std_logic_vector(2 downto 0);
		third_rotor: in std_logic_vector(2 downto 0);
		enable_inicial : in std_logic;
		enable_rotation : in std_logic;
		set_ring: in std_logic;
		ringstellung : in std_logic_vector(4 downto 0); -- posicao anel
		grundstellung : in std_logic_vector(4 downto 0); -- posicao inicial do rotor
		rotor_turnover : out std_logic;
		letter_in : in std_logic_vector(4 downto 0);
		letter_out : out std_logic_vector(4 downto 0)
	);
end component;

component reflector is
	port(
			reflector_type : in std_logic_vector(1 downto 0); -- "00": TIPO A, "01": TIPO B, "10": TIPO C
			letter_in : in std_logic_vector(4 downto 0);
			letter_out: out std_logic_vector(4 downto 0)
	);
end component;

begin


	
end architecture;
