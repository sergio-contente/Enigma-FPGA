------------------------------ENIGMA-------------------------------------
-- Arquivo   : translator_I.vhd
-- Projeto   : Enigma
---------------------------------------------------------------------------
-- Descricao :  Traducao do teclado:
-- =========================================================================
--							ABCDEFGHIJKLMNOPQRSTUVWXYZ-
--							EKMFLGDQVZNTOWYHXUSPAIBR-JC
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

entity translator_I is
    port (
        original : in  std_logic_vector(4 downto 0); -- Letra do comeco 
				direction : in std_logic;
        saida    : out std_logic_vector(4 downto 0) -- Combinacao
    ); 
end entity;

architecture translator_I_arch of translator_I is
	signal s_letter_in, s_letter_out: std_logic_vector(4 downto 0);
begin
	s_letter_in <= original;
	rotation_rotor_I: process (s_letter_in, s_letter_out, direction)
	begin
			case s_letter_in is
				when "00000" => -- A	
					if (direction = '0') then
							 s_letter_out <= "00100"; --  entrando, E (ETW - I)
					else
							 s_letter_out <= "10100"; -- saindo, U (I - ETW)
					end if;
				when "00001" =>    -- B
					if (direction = '0') then
							 s_letter_out <= "01010"; -- entrando, K (ETW - I)
					else
							 s_letter_out <= "10110"; -- saindo, W (I - ETW)
					end if;
				when "00010" =>    -- C
					if (direction = '0') then
							 s_letter_out <= "01100"; -- entrando, M (I - ETW)
					else
							 s_letter_out <= "11010"; -- saindo, Y (ETW - I)
					end if;
				when "00011" =>    -- D
					if (direction = '0') then
							 s_letter_out <= "00101"; -- entrando, F (I - ETW)
					else
							 s_letter_out <= "00110"; -- saindo, G (ETW - I)
					end if;
				when "00100" =>    -- E
					if (direction = '0') then
							 s_letter_out <= "01011"; -- entrando, L (I - ETW)
					else
							 s_letter_out <= "00000"; -- saindo, A (ETW - I)
					end if;
				when "00101" =>    -- F
					if (direction = '0') then
							 s_letter_out <= "00110"; -- rotor 1, G
					else
							 s_letter_out <= "00011"; -- rotor 1, D
					end if;
				when "00110" =>    -- G
					if (direction = '0') then
							 s_letter_out <= "00011"; -- rotor 1, D
					else
							 s_letter_out <= "00101"; -- rotor 1, F
					end if;
				when "00111" =>    -- H
					if (direction = '0') then
							 s_letter_out <= "10000"; -- rotor 1, Q
					else
							 s_letter_out <= "01111"; -- rotor 1, P
					end if;
				when "01000" =>    -- I
					if (direction = '0') then
							 s_letter_out <= "10101"; -- rotor 1, V
					else
							 s_letter_out <= "10101"; -- rotor 1, V
					end if;
				when "01001" =>    -- J
					if (direction = '0') then
							 s_letter_out <= "11001"; -- rotor 1, Z
					else
							 s_letter_out <= "11001"; -- rotor 1, Z
					end if;
				when "01010" =>    -- K
					if (direction = '0') then
							 s_letter_out <= "01101"; -- rotor 1, N
					else
							 s_letter_out <= "00001"; -- rotor 1, B
					end if;
				when "01011" =>    -- L
					if (direction = '0') then
							 s_letter_out <= "10011"; -- rotor 1, T
					else
							 s_letter_out <= "00100"; -- rotor 1, E
					end if;
				when "01100" =>    -- M
					if (direction = '0') then
							 s_letter_out <= "01110"; -- rotor 1, O
					else
							 s_letter_out <= "00010"; -- rotor 1, C
					end if;
				when "01101" =>    -- N
					if (direction = '0') then
							 s_letter_out <= "10110"; -- rotor 1, W 
					else
							 s_letter_out <= "01010"; -- rotor 1, K
					end if;
				when "01110" =>    -- O
					if (direction = '0') then
								 s_letter_out <= "11000"; -- rotor 1, Y
						else
								 s_letter_out <= "01100"; -- rotor 1, M
						end if;
					when "01111" =>    -- P
						if (direction = '0') then
								 s_letter_out <= "00111"; -- rotor 1, H
						else
								 s_letter_out <= "10011"; -- rotor 1, T
						end if;
					when "10000" =>    -- Q
						if (direction = '0') then
								 s_letter_out <= "10111"; -- rotor 1, X 
						else
								 s_letter_out <= "00111"; -- rotor 1, H 
						end if;
					when "10001" =>    -- R
						if (direction = '0') then
								 s_letter_out <= "10100"; -- rotor 1, U
						else
								 s_letter_out <= "10111"; -- rotor 1, X
						end if;
					when "10010" =>    -- S
						if (direction = '0') then
								 s_letter_out <= "10010"; -- rotor 1, S
						else
								 s_letter_out <= "10010"; -- rotor 1, S
						end if;
					when "10011" =>    -- T
						if (direction = '0') then
								 s_letter_out <= "01111"; -- rotor 1, P
						else
								 s_letter_out <= "01011"; -- rotor 1, L
						end if;
					when "10100" =>    -- U
						if (direction = '0') then
								 s_letter_out <= "00000"; -- rotor 1, A
						else
								 s_letter_out <= "10001"; -- rotor 1, R
						end if;
					when "10101" =>    -- V
						if (direction = '0') then
								 s_letter_out <= "01000"; -- rotor 1, I 
						else
								 s_letter_out <= "01000"; -- rotor 1, I
						end if;
					when "10110" =>    -- W
						if (direction = '0') then
								 s_letter_out <= "00001"; -- rotor 1, B
						else
								 s_letter_out <= "01101"; -- rotor 1, N
						end if;
					when "10111" =>    -- X
						if (direction = '0') then
								 s_letter_out <= "10001"; -- rotor 1, R
						else
								 s_letter_out <= "10000"; -- rotor 1, Q
						end if;
					when "11000" =>    -- Y
						if (direction = '0') then
								 s_letter_out <= "11010"; -- rotor 1, " "
						else
								 s_letter_out <= "01110"; -- rotor 1, O
						end if;
					when "11001" =>    -- Z
						if (direction = '0') then
								 s_letter_out <= "01001"; -- rotor 1, J
						else
								 s_letter_out <= "01001"; -- rotor 1, J
						end if;
					when "11010" =>    -- " "
						if (direction = '0') then
								 s_letter_out <= "00010"; -- rotor 1, C
						else
								 s_letter_out <= "11000"; -- rotor 1, Y
						end if;
					when others =>     -- should never be reached
						s_letter_out <= (others => '1'); -- non-existing letter code ("11111")
			end case;
		end process rotation_rotor_I;
		saida <= s_letter_out;
end architecture;
