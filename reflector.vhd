------------------------------ENIGMA-------------------------------------
-- Arquivo   : reflector.vhd
-- Projeto   : Enigma
-------------------------------------------------------------------------
-- Descricao : Refletor que faz a permutacao entre duas letras
--             usando Cifra de Cesar, com base nos 3 tipos de
--             refletores usados pelas forcas armadas alemas na WWII.
--             Basicamente consiste em um MUX.
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             						Descricao
--     22/11/2022  1.0     Sergio Magalhaes Contente 		criacao
------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reflector is
    port(
				reflector_type : in std_logic_vector(1 downto 0); -- "00": TIPO A, "01": TIPO B, "10": TIPO C
        letter_in : in std_logic_vector(4 downto 0);
        letter_out: out std_logic_vector(4 downto 0)
    );
end reflector;

architecture reflector_arch of reflector is
	signal s_letter_out : std_logic_vector(4 downto 0);
begin
	reflect: process (letter_in, reflector_type)
	begin
		case letter_in is
			when "00000" =>    -- A
				case reflector_type is
					when "00"		 => s_letter_out <= "00100"; -- reflector a, E
					when "01"    => s_letter_out <= "11000"; -- reflector b, Y
					when others => s_letter_out <= "00101"; -- reflector c, F
				end case;
			when "00001" =>    -- B
				case reflector_type is
					when "00"    => s_letter_out <= "01001"; 	-- reflector a, J
					when "01"    => s_letter_out <= "10001"; -- reflector b, R
					when others => s_letter_out <= "10101"; -- reflector c, V
				end case;
			when "00010" =>    -- C
				case reflector_type is
					when "00"		 => s_letter_out <= "01100"; 	-- reflector a, M
					when "01"    => s_letter_out <= "10100"; -- reflector b, U
					when others => s_letter_out <= "01111"; -- reflector c, P
				end case;
			when "00011" =>    -- D
				case reflector_type is
					when "00"		=> s_letter_out <= "11001"; 	-- reflector a, Z
					when "01"    => s_letter_out <= "00111"; -- reflector b, H
					when others => s_letter_out <= "01001"; -- reflector c, J
				end case;
			when "00100" =>    -- E
				case reflector_type is
					when "00"   =>  s_letter_out <= "00000";      -- reflector a, A
					when "01"    => s_letter_out <= "10000"; -- reflector b, Q
					when others => s_letter_out <= "01000"; -- reflector c, I
				end case;
			when "00101" =>    -- F
				case reflector_type is
				when "00"			=> s_letter_out <= "01011";  -- reflector a, L
					when "01"    => s_letter_out <= "10010"; -- reflector b, S
					when others => s_letter_out <= "00000"; -- reflector c, A
				end case;
			when "00110" =>    -- G
				case reflector_type is
					when "00"    => s_letter_out <= "11000";  -- reflector a, Y
					when "01"    => s_letter_out <= "01011"; -- reflector b, L
					when others => s_letter_out <= "01110"; -- reflector c, O
				end case;
			when "00111" =>    -- H
				case reflector_type is
					when "00"    => s_letter_out <= "10111"; -- reflector a, X
					when "01"    => s_letter_out <= "00011"; -- reflector b, D
					when others => s_letter_out <= "11000"; -- reflector c, Y
				end case;
			when "01000" =>    -- I
				case reflector_type is
					when "00"	 => s_letter_out <= "10101";  -- reflector a, V
					when "01"    => s_letter_out <= "01111"; -- reflector b, P
					when others => s_letter_out <= "00100"; -- reflector c, E
				end case;
			when "01001" =>    -- J
				case reflector_type is
					when "00"    => s_letter_out <= "00001"; -- reflector a, B
					when "01"    => s_letter_out <= "10111"; -- reflector b, X
					when others => s_letter_out <= "00011"; -- reflector c, D
				end case;
			when "01010" =>    -- K
				case reflector_type is
					when "00"    => s_letter_out <= "10110";      -- reflector a, W
					when "01"    => s_letter_out <= "01101"; -- reflector b, N
					when others => s_letter_out <= "10001"; -- reflector c, R
				end case;
			when "01011" =>    -- L
				case reflector_type is
					when "00"     => s_letter_out <= "00101";  -- reflector a, F
					when "01"    => s_letter_out <= "00110"; -- reflector b, G
					when others => s_letter_out <= "11001"; -- reflector c, Z
				end case;
			when "01100" =>    -- M
				case reflector_type is
					when "00" 	=> s_letter_out <= "00010"; 	-- reflector a, C
					when "01"    => s_letter_out <= "01110"; -- reflector b, O
					when others => s_letter_out <= "10111"; -- reflector c, X
				end case;
			when "01101" =>    -- N
				case reflector_type is
					when "00"    => s_letter_out <= "10001";   -- reflector a, R
					when "01"    => s_letter_out <= "01010"; -- reflector b, K
					when others => s_letter_out <= "10110"; -- reflector c, W
				end case;
			when "01110" =>    -- O
				case reflector_type is
					when "00"    => s_letter_out <= "10000";  -- reflector a, Q
					when "01"    => s_letter_out <= "01100"; -- reflector b, M
					when others => s_letter_out <= "00110"; -- reflector c, G
				end case;
			when "01111" =>    -- P
				case reflector_type is
					when "00" 	=> s_letter_out <= "10100";     -- reflector a, U
					when "01"    => s_letter_out <= "01000"; -- reflector b, I
					when others => s_letter_out <= "00010"; -- reflector c, C
				end case;
			when "10000" =>    -- Q
				case reflector_type is
					when "00"   => s_letter_out <= "01110"; -- reflector a, O
					when "01"    => s_letter_out <= "00100"; -- reflector b, E
					when others => s_letter_out <= "10011"; -- reflector c, T
				end case;
			when "10001" =>    -- R
				case reflector_type is
					when "00"    => s_letter_out <= "01101"; -- reflector a, N
					when "01"    => s_letter_out <= "00001"; -- reflector b, B
					when others => s_letter_out <= "01010"; -- reflector c, K
				end case;
			when "10010" =>    -- S
				case reflector_type is
					when "00" 	=> s_letter_out <= "10011"; -- reflector a, T
					when "01"    => s_letter_out <= "00101"; -- reflector b, F
					when others => s_letter_out <= "10100"; -- reflector c, U
				end case;
			when "10011" =>    -- T
				case reflector_type is
					WHEN "00"   => s_letter_out <= "10010"; -- reflector a, S
					when "01"    => s_letter_out <= "11001"; -- reflector b, Z
					when others => s_letter_out <= "10000"; -- reflector c, Q
				end case;
			when "10100" =>    -- U
				case reflector_type is
					when "00"    => s_letter_out <= "01111"; -- reflector a, P
					when "01"    => s_letter_out <= "00010"; -- reflector b, C
					when others => s_letter_out <= "10010"; -- reflector c, S
				end case;
			when "10101" =>    -- V
				case reflector_type is
					when "00"   => s_letter_out <= "01000"; -- reflector a,I
					when "01"    => s_letter_out <= "10110"; -- reflector b, W
					when others => s_letter_out <= "00001"; -- reflector c, B
				end case;
			when "10110" =>    -- W
				case reflector_type is
					when "00"    => s_letter_out <= "01010"; -- reflector a, K
					when "01"    => s_letter_out <= "10101"; -- reflector b, V
					when others => s_letter_out <= "01101"; -- reflector c, N
				end case;
			when "10111" =>    -- X
				case reflector_type is
					when "00"    => s_letter_out <= "00111";  -- reflector a, H
					when "01"    => s_letter_out <= "01001"; -- reflector b, J
					when others => s_letter_out <= "01100"; -- reflector c, M
				end case;
			when "11000" =>    -- Y
				case reflector_type is
					when "00"   => s_letter_out <= "00110"; -- reflector a, G
					when "01"    => s_letter_out <= "00000"; -- reflector b, A
					when others => s_letter_out <= "00111"; -- reflector c, H
				end case;
			when "11001" =>    -- Z
				case reflector_type is
					when "00"  => s_letter_out <= "00011";  -- reflector a, D
					when "01"    => s_letter_out <= "10011"; -- reflector b, T
					when others => s_letter_out <= "01011"; -- reflector c, L
				end case;
				when "11010" =>    -- ' '
				case reflector_type is
					when "00"  => s_letter_out <= "11010"; 
					when "01"    => s_letter_out <= "11010";
					when others => s_letter_out <= "11010";
				end case;
				when others =>
					s_letter_out <= (others => '1'); -- depuracao ("11111")
			end case;
		end process;
				
		letter_out <= s_letter_out;

end reflector_arch;
