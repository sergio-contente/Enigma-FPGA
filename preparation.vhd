library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity preparation is
	port (
		clock : in std_logic;
		clear : in std_logic;
		enable : in std_logic;

		letter_in : in std_logic_vector(4 downto 0);
		ring_pos : in std_logic_vector(4 downto 0);
		rotor_post : in std_logic_vector(4 downto 0);

		preprocess_letter : out std_logic_vector(4 downto 0)
		fim_preprocess  : out std_logic
	);

architecture preparation_arch of preparation is
begin
	signal s_preprocess_letter : std_logic_vector(4 downto 0);

	preeprocessing: process(clock, clear, enable)
	begin
		s_preprocess_letter <= std_logic_vector((((unsigned(letter_in) + "011010") - unsigned(ring_pos)) rem 26) + unsigned(rotor_pos));
	end preparation;
end architecture;


