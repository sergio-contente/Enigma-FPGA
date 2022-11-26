------------------------------ENIGMA-------------------------------------
-- Arquivo   : translator_II.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Traducao do teclado:
-- =========================================================================
--							ABCDEFGHIJKLMNOPQRSTUVWXYZ-
--							AJDK-IRUXBLHWTMCQGZNPYFVOES
--
-- ========================================================================
--							por combinar as letras de entrada.
----------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     23/11/2022  1.0     Sergio Magalhaes Contente 		criacao
------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity translator_II is
    port (
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
end entity;

architecture translator_II_arch of translator_II is
	signal s_letter_in, s_letter_out: std_logic_vector(4 downto 0);
begin
	s_letter_in <= original;
	rotation_rotor_I: process (s_letter_in, s_letter_out, direction)
	begin
			case s_letter_in is
				when "00000" => -- A	
					if (direction = '0') then
						s_letter_out <= "00000"; -- rotor 2, A
					else
						s_letter_out <= "00000"; -- rotor 2, A
					end if;
				when "00001" =>    -- B
					if (direction = '0') then
						s_letter_out <= "01001"; -- rotor 2, J
					else
						s_letter_out <= "01001"; -- rotor 2, J
					end if;
				when "00010" =>    -- C
					if (direction = '0') then
						s_letter_out <= "00011"; -- rotor 2, D
					else
						s_letter_out <= "01111"; -- rotor 2, P
					end if;
				when "00011" =>    -- D
					if (direction = '0') then
						s_letter_out <= "01010"; -- rotor 2, K
					else
						s_letter_out <= "00010"; -- rotor 2, C
					end if;
				when "00100" =>    -- E
					if (direction = '0') then
						s_letter_out <= "11010"; -- rotor 2, -
					else
						s_letter_out <= "11001"; -- rotor 2, Z
					end if;
				when "00101" =>    -- F
					if (direction = '0') then
						s_letter_out <= "01000"; -- rotor 2, I
					else
						s_letter_out <= "10110"; -- rotor 2, W
					end if;
				when "00110" =>    -- G
					if (direction = '0') then
						s_letter_out <= "10001"; -- rotor 2, R
					else
						s_letter_out <= "10001"; -- rotor 2, R
					end if;
				when "00111" =>    -- H
					if (direction = '0') then
						s_letter_out <= "10100"; -- rotor 2, U
					else
						s_letter_out <= "01011"; -- rotor 2, L
					end if;
				when "01000" =>    -- I
					if (direction = '0') then
						s_letter_out <= "10111"; -- rotor 2, X
					else
						s_letter_out <= "00101"; -- rotor 2, F
					end if;
				when "01001" =>    -- J
					if (direction = '0') then
						s_letter_out <= "00001"; -- rotor 2, B
					else
						s_letter_out <= "00001"; -- rotor 2, B
					end if;
				when "01010" =>    -- K
					if (direction = '0') then
						s_letter_out <= "01011"; -- rotor 2, L
					else
						s_letter_out <= "00011"; -- rotor 2, D
					end if;
				when "01011" =>    -- L
					if (direction = '0') then
						s_letter_out <= "00111"; -- rotor 2, H
					else
						s_letter_out <= "01010"; -- rotor 2, K
					end if;
				when "01100" =>    -- M
					if (direction = '0') then
						s_letter_out <= "10110"; -- rotor 2, W
					else
						s_letter_out <= "01110"; -- rotor 2, O
					end if;
				when "01101" =>    -- N
					if (direction = '0') then
						s_letter_out <= "10011"; -- rotor 2, T
					else
						s_letter_out <= "10011"; -- rotor 2, T
					end if;
				when "01110" =>    -- O
					if (direction = '0') then
						s_letter_out <= "01100"; -- rotor 2, M
					else
						s_letter_out <= "11000"; -- rotor 2, Y
					end if;
				when "01111" =>    -- P
					if (direction = '0') then
						s_letter_out <= "00010"; -- rotor 2, C
					else
						s_letter_out <= "10100"; -- rotor 2, U
					end if;
				when "10000" =>    -- Q
					if (direction = '0') then
						s_letter_out <= "10000"; -- rotor 2, Q
					else
						s_letter_out <= "10000"; -- rotor 2, Q
					end if;
				when "10001" =>    -- R
					if (direction = '0') then
						s_letter_out <= "00110"; -- rotor 2, G
					else
						s_letter_out <= "00110"; -- rotor 2, G
					end if;
				when "10010" =>    -- S
					if (direction = '0') then
						s_letter_out <= "11001"; -- rotor 2, Z
					else
						s_letter_out <= "11010"; -- rotor 2, -
					end if;
				when "10011" =>    -- T
					if (direction = '0') then
						s_letter_out <= "01101"; -- rotor 2, N
					else
						s_letter_out <= "01101"; -- rotor 2, N
					end if;
				when "10100" =>    -- U
					if (direction = '0') then
						s_letter_out <= "01111"; -- rotor 2, P
					else
						s_letter_out <= "00111"; -- rotor 2, H
					end if;
				when "10101" =>    -- V
					if (direction = '0') then
						s_letter_out <= "11000"; -- rotor 2, Y
					else
						s_letter_out <= "10111"; -- rotor 2, X
					end if;
				when "10110" =>    -- W
					if (direction = '0') then
						s_letter_out <= "00101"; -- rotor 2, F
					else
						s_letter_out <= "01100"; -- rotor 2, M
					end if;
				when "10111" =>    -- X
					if (direction = '0') then
						s_letter_out <= "10101"; -- rotor 2, V
					else
						s_letter_out <= "01000"; -- rotor 2, I
					end if;
				when "11000" =>    -- Y
					if (direction = '0') then
						s_letter_out <= "01110"; -- rotor 2, O
					else
						s_letter_out <= "10101"; -- rotor 2, V
					end if;
				when "11001" =>    -- Z
					if (direction = '0') then
						s_letter_out <= "00100"; -- rotor 2, E
					else
						s_letter_out <= "10010"; -- rotor 2, S
					end if;
				when "11010" =>    -- " "
					if (direction = '0') then
								s_letter_out <= "11001"; -- rotor 1, S
					else
								s_letter_out <= "00100"; -- rotor 1, E
					end if;
				when others =>     -- should never be reached
					s_letter_out <= (others => '1'); -- non-existing letter code ("11111")
		end case;
	end process rotation_rotor_I;
	saida <= s_letter_out;
end architecture;
