------------------------------ENIGMA-------------------------------------
-- Arquivo   : translator_III.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Traducao do teclado:
-- =========================================================================
--							ABCDEFGHIJKLMNOPQRSTUVWXYZ-
--							BDFHJ-CPRTXVZNYEIWGAKMUSQOL
--
-- ========================================================================
--							por combinar as letras de entrada.
----------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     26/11/2022  1.0     Sergio Magalhaes Contente 		criacao
------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity translator_III is
    port (
				enable : in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
end entity;

architecture translator_III_arch of translator_III is
	signal s_letter_in, s_letter_out: std_logic_vector(4 downto 0);
begin
	s_letter_in <= original;
	rotation_rotor_III: process (s_letter_in, s_letter_out, direction)
	begin
		if(enable = "010") then
			case s_letter_in is
				when "00000" => -- A	
					if (direction = '0') then
						s_letter_out <= "00001"; -- rotor 3, B
					else
						s_letter_out <= "10011"; -- rotor 3, T
					end if;
				when "00001" =>    -- B
					if (direction = '0') then
						s_letter_out <= "00011"; -- rotor 3, D
					else
						s_letter_out <= "00000"; -- rotor 3, A
					end if;
				when "00010" =>    -- C
					if (direction = '0') then
						s_letter_out <= "00101"; -- rotor 3, F
					else
						s_letter_out <= "00110"; -- rotor 3, G
					end if;
				when "00011" =>    -- D
					if (direction = '0') then
						s_letter_out <= "00111"; -- rotor 3, H
					else
						s_letter_out <= "00001"; -- rotor 3, B
					end if;
				when "00100" =>    -- E
					if (direction = '0') then
						s_letter_out <= "01001"; -- rotor 3, J
					else
						s_letter_out <= "01111"; -- rotor 3, P
					end if;
				when "00101" =>    -- F
					if (direction = '0') then
						s_letter_out <= "11010"; -- rotor 3, " "
					else
						s_letter_out <= "00010"; -- rotor 3, C
					end if;
				when "00110" =>    -- G
					if (direction = '0') then
						s_letter_out <= "00010"; -- rotor 3, C
					else
						s_letter_out <= "10010"; -- rotor 3, S
					end if;
				when "00111" =>    -- H
					if (direction = '0') then
						s_letter_out <= "01111"; -- rotor 3, P
					else
						s_letter_out <= "00011"; -- rotor 3, D
					end if;
				when "01000" =>    -- I
					if (direction = '0') then
						s_letter_out <= "10001"; -- rotor 3, R
					else
						s_letter_out <= "10000"; -- rotor 3, Q
					end if;
				when "01001" =>    -- J
					if (direction = '0') then
						s_letter_out <= "10011"; -- rotor 3, T
					else
						s_letter_out <= "00100"; -- rotor 3, E
					end if;
				when "01010" =>    -- K
					if (direction = '0') then
						s_letter_out <= "10111"; -- rotor 3, X
					else
						s_letter_out <= "10100"; -- rotor 3, U
					end if;
				when "01011" =>    -- L
					if (direction = '0') then
						s_letter_out <= "10101"; -- rotor 3, V
					else
						s_letter_out <= "11010"; -- rotor 3, " "
					end if;
				when "01100" =>    -- M
					if (direction = '0') then
						s_letter_out <= "11001"; -- rotor 3, Z
					else
						s_letter_out <= "10101"; -- rotor 3, V
					end if;
				when "01101" =>    -- N
					if (direction = '0') then
						s_letter_out <= "01101"; -- rotor 3, N
					else
						s_letter_out <= "01101"; -- rotor 3, N
					end if;
				when "01110" =>    -- O
					if (direction = '0') then
						s_letter_out <= "11000"; -- rotor 3, Y
					else
						s_letter_out <= "11001"; -- rotor 3, Z
					end if;
				when "01111" =>    -- P
					if (direction = '0') then
						s_letter_out <= "00100"; -- rotor 3, E
					else
						s_letter_out <= "00111"; -- rotor 3, H
					end if;
				when "10000" =>    -- Q
					if (direction = '0') then
						s_letter_out <= "01000"; -- rotor 3, I
					else
						s_letter_out <= "11000"; -- rotor 3, Y
					end if;
				when "10001" =>    -- R
					if (direction = '0') then
						s_letter_out <= "10110"; -- rotor 3, W
					else
						s_letter_out <= "01000"; -- rotor 3, I
					end if;
				when "10010" =>    -- S
					if (direction = '0') then
						s_letter_out <= "00110"; -- rotor 3, G
					else
						s_letter_out <= "10111"; -- rotor 3, X
					end if;
				when "10011" =>    -- T
					if (direction = '0') then
						s_letter_out <= "00000"; -- rotor 3, A
					else
						s_letter_out <= "01001"; -- rotor 3, J
					end if;
				when "10100" =>    -- U
					if (direction = '0') then
						s_letter_out <= "01010"; -- rotor 3, K
					else
						s_letter_out <= "10110"; -- rotor 3, W
					end if;
				when "10101" =>    -- V
					if (direction = '0') then
						s_letter_out <= "01100"; -- rotor 3, M
					else
						s_letter_out <= "01011"; -- rotor 3, L
					end if;
				when "10110" =>    -- W
					if (direction = '0') then
						s_letter_out <= "10100"; -- rotor 3, U
					else
						s_letter_out <= "10001"; -- rotor 3, R
					end if;
				when "10111" =>    -- X
					if (direction = '0') then
						s_letter_out <= "10010"; -- rotor 3, S
					else
					s_letter_out <= "01010"; -- rotor 3, K
					end if;
				when "11000" =>    -- Y
					if (direction = '0') then
						s_letter_out <= "10000"; -- rotor 3, Q
					else
						s_letter_out <= "01110"; -- rotor 3, O
					end if;
				when "11001" =>    -- Z
					if (direction = '0') then
						s_letter_out <= "01110"; -- rotor 3, O
					else
						s_letter_out <= "01100"; -- rotor 3, M
					end if;
				when "11010" =>    -- " "
					if (direction = '0') then
								s_letter_out <= "01011"; -- rotor 1, L
					else
								s_letter_out <= "00101"; -- rotor 1, F
					end if;
				when others =>     -- should never be reached
					s_letter_out <= (others => '1'); -- non-existing letter code ("11111")
		end case;
	end if;
end process rotation_rotor_III;
saida <= s_letter_out;
end architecture;
