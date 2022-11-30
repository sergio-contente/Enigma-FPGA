------------------------------ENIGMA-------------------------------------
-- Arquivo   : RotorPass.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Consiste na passagem do sinal
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     29/11/2022  1.0     Sergio Magalhães Contente     	criacao
------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity TraduzLetra is
	port(
		rotor_type: in std_logic_vector(2 downto 0);
		letter_in : in std_logic_vector(4 downto 0);
		direction: in std_logic;
		letter_out : out std_logic_vector(4 downto 0)
	);
end TraduzLetra;

architecture traduz_letra_arch of TraduzLetra is
	signal s_letter_traducao: std_logic_vector(4 downto 0);

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

begin

tradutor_I: port map (
	enable   => rotor_type,
	original => s_letter_rotor_out, -- Letra do comeco 
	direction => direction,
	saida    =>  s_letter_traducao-- Combinacao
); 

tradutor_II: port map (
	enable   => rotor_type,
	original => s_letter_rotor_out, -- Letra do comeco 
	direction => direction,
	saida    =>  s_letter_traducao-- Combinacao
); 

tradutor_III: port map (
	enable   => rotor_type,
	original => s_letter_rotor_out, -- Letra do comeco 
	direction => direction,
	saida    =>  s_letter_traducao-- Combinacao
); 

tradutor_IV: port map (
	enable   => rotor_type,
	original => s_letter_rotor_out, -- Letra do comeco 
	direction => direction,
	saida    =>  s_letter_traducao-- Combinacao
); 

tradutor_V: port map (
	enable   => rotor_type,
	original => s_letter_rotor_out, -- Letra do comeco 
	direction => direction,
	saida    =>  s_letter_traducao-- Combinacao
); 

end architecture;
