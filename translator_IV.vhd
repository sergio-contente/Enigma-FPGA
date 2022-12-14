------------------------------ENIGMA-------------------------------------
-- Arquivo   : translator_IV.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Traducao do teclado:
-- =========================================================================
--							ABCDEFGHIJKLMNOPQRSTUVWXYZ-
--							ESOVPZJ-YQUIRHXLNFTGKDCMWBA
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

entity translator_IV is
    port (
				enable: in std_logic_vector(2 downto 0);
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
end entity;

architecture translator_IV_arch of translator_IV is
	signal s_letter_in, s_letter_out: std_logic_vector(4 downto 0);
begin
	s_letter_in <= original;
	rotation_rotor_IV: process (s_letter_in, s_letter_out, direction)
	begin
		if(enable = "011") then
			case s_letter_in is
				when "00000" => -- A	
					if (direction = '0') then
						s_letter_out <= "00100"; -- rotor 4, E
					else
						s_letter_out <= "00111"; -- rotor 4, H
					end if;
				when "00001" =>    -- B
					if (direction = '0') then
						s_letter_out <= "10010"; -- rotor 4, S
					else
						s_letter_out <= "11001"; -- rotor 4, Z
					end if;
				when "00010" =>    -- C
					if (direction = '0') then
						s_letter_out <= "01110"; -- rotor 4, O
					else
						s_letter_out <= "10110"; -- rotor 4, W
					end if;
				when "00011" =>    -- D
					if (direction = '0') then
						s_letter_out <= "10101"; -- rotor 4, V
					else
						s_letter_out <= "10101"; -- rotor 4, V
					end if;
				when "00100" =>    -- E
					if (direction = '0') then
						s_letter_out <= "01111"; -- rotor 4, P
					else
						s_letter_out <= "00000"; -- rotor 4, A
					end if;
				when "00101" =>    -- F
					if (direction = '0') then
						s_letter_out <= "11001"; -- rotor 4, Z
					else
						s_letter_out <= "10001"; -- rotor 4, R
					end if;
				when "00110" =>    -- G
					if (direction = '0') then
						s_letter_out <= "01001"; -- rotor 4, J
					else
						s_letter_out <= "10011"; -- rotor 4, T
					end if;
				when "00111" =>    -- H
					if (direction = '0') then
						s_letter_out <= "00000"; -- rotor 4, A
					else
						s_letter_out <= "01101"; -- rotor 4, N
					end if;
				when "01000" =>    -- I
					if (direction = '0') then
						s_letter_out <= "11000"; -- rotor 4, Y
					else
						s_letter_out <= "01011"; -- rotor 4, L
					end if;
				when "01001" =>    -- J
					if (direction = '0') then
						s_letter_out <= "10000"; -- rotor 4, Q
					else
						s_letter_out <= "00110"; -- rotor 4, G
					end if;
				when "01010" =>    -- K
					if (direction = '0') then
						s_letter_out <= "10100"; -- rotor 4, U
					else
						s_letter_out <= "10100"; -- rotor 4, U
					end if;
				when "01011" =>    -- L
					if (direction = '0') then
						s_letter_out <= "01000"; -- rotor 4, I
					else
						s_letter_out <= "01111"; -- rotor 4, P
					end if;
				when "01100" =>    -- M
					if (direction = '0') then
						s_letter_out <= "10001"; -- rotor 4, R
					else
						s_letter_out <= "10111"; -- rotor 4, X
					end if;
				when "01101" =>    -- N
					if (direction = '0') then
						s_letter_out <= "00111"; -- rotor 4, H
					else
						s_letter_out <= "10000"; -- rotor 4, Q
					end if;
				when "01110" =>    -- O
					if (direction = '0') then
						s_letter_out <= "10111"; -- rotor 4, X
					else
						s_letter_out <= "00010"; -- rotor 4, C
					end if;
				when "01111" =>    -- P
					if (direction = '0') then
						s_letter_out <= "01011"; -- rotor 4, L
					else
						s_letter_out <= "00100"; -- rotor 4, E
					end if;
				when "10000" =>    -- Q
					if (direction = '0') then
						s_letter_out <= "01101"; -- rotor 4, N
					else
						s_letter_out <= "01001"; -- rotor 4, J
					end if;
				when "10001" =>    -- R
					if (direction = '0') then
						s_letter_out <= "00101"; -- rotor 4, F
					else
						s_letter_out <= "01100"; -- rotor 4, M
					end if;
				when "10010" =>    -- S
					if (direction = '0') then
						s_letter_out <= "10011"; -- rotor 4, T
					else
						s_letter_out <= "00001"; -- rotor 4, B
					end if;
				when "10011" =>    -- T
					if (direction = '0') then
						s_letter_out <= "00110"; -- rotor 4, G
					else
						s_letter_out <= "10010"; -- rotor 4, S
					end if;
				when "10100" =>    -- U
					if (direction = '0') then
						s_letter_out <= "01010"; -- rotor 4, K
					else
						s_letter_out <= "01010"; -- rotor 4, K
					end if;
				when "10101" =>    -- V
					if (direction = '0') then
						s_letter_out <= "00011"; -- rotor 4, D
					else
						s_letter_out <= "00011"; -- rotor 4, D
					end if;
				when "10110" =>    -- W
					if (direction = '0') then
						s_letter_out <= "00010"; -- rotor 4, C
					else
						s_letter_out <= "11000"; -- rotor 4, Y
					end if;
				when "10111" =>    -- X
					if (direction = '0') then
						s_letter_out <= "01100"; -- rotor 4, M
					else
						s_letter_out <= "01110"; -- rotor 4, O
					end if;
				when "11000" =>    -- Y
					if (direction = '0') then
						s_letter_out <= "10110"; -- rotor 4, W
					else
						s_letter_out <= "01000"; -- rotor 4, I
					end if;
				when "11001" =>    -- Z
					if (direction = '0') then
						s_letter_out <= "00001"; -- rotor 4, B
					else
						s_letter_out <= "00101"; -- rotor 4, F
					end if;
				when others =>     -- should never be reached
					s_letter_out <= (others => '1'); -- non-existing letter code ("11111")
		end case;
	end if;
	end process rotation_rotor_IV;
	saida <= s_letter_out;
end architecture;
