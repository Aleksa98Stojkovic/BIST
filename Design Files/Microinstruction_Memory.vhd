----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
--
-- Create Date: 01/23/2022 03:14:49 PM
-- Design Name: Microinstruction_Memory
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity Microinstruction_Memory is
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
end Microinstruction_Memory;

architecture Behavioral of Microinstruction_Memory is

type matrix_type is array(0 to 2 ** address_width - 1) of std_logic_vector(data_width - 1 downto 0);
signal memory : matrix_type := ("0000000000000",
                                "1100000000000",
                                "0100000000000",
                                "0000000010000",
                                "0000000000000",
                                "0001100000000",
                                "0000100000000",
                                "0000111000000",
                                "0000110000000",
                                "0000000000001",
                                "0010000000000",
                                "0000000100011",
                                "0000000000011",
                                "0000000001001",
                                "0000000000100",
                                "0000000000000"
                                );

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
