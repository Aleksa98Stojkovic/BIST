----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
-- 
-- Create Date: 01/22/2022 12:21:57 PM
-- Design Name: Dual_Port_Meomory
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity Dual_Port_Memory is
    generic(
                data_width : natural := 4;
                address_width : natural := 4
            );
    Port(
            clk_i : in std_logic;
            address_A_i, address_B_i : in std_logic_vector(address_width - 1 downto 0);
            write_en_A_i : in std_logic;
            wdata_A_i : in std_logic_vector(data_width - 1 downto 0);
            rdata_A_i, rdata_B_i : out std_logic_vector(data_width - 1 downto 0)
         );
end Dual_Port_Memory;

architecture Behavioral of Dual_Port_Memory is

type matrix_type is array(0 to 2 ** address_width - 1) of std_logic_vector(data_width - 1 downto 0);
signal memory : matrix_type := (others => (others => '0'));

begin

    Mem: process(clk_i)
    begin
        if(rising_edge(clk_i)) then
            -- Port A
            if(write_en_A_i = '1') then
                memory(to_integer(unsigned(address_A_i))) <= wdata_A_i;
            end if;
            rdata_A_i <= memory(to_integer(unsigned(address_A_i)));
            -- Port B 
            rdata_B_i <= memory(to_integer(unsigned(address_B_i)));
        end if;
    end process;

end Behavioral;
