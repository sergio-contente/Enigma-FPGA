library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_27x5 is
    port(
        clock : in std_logic;
        wr : in std_logic;
        address : in std_logic_vector(4 downto 0);
        data_in : in std_logic_vector(4 downto 0);
        data_out : out std_logic_vector(4 downto 0)
    );
end ram_27x5;

architecture ram_27x5_arch of ram_27x5 is
    type ram_type is array(0 to 26) of std_logic_vector(4 downto 0);
    signal ram : ram_type;
begin
    process(clock) is
    begin
        if clock'event and clock='1' then
            if wr='1' then
                ram(to_integer(unsigned(address))) <= data_in;
            end if;
        end if;
    end process;

    data_out <= ram(to_integer(unsigned(address)));
end ram_27x5_arch;