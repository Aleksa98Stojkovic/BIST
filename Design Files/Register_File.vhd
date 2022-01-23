----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
-- 
-- Create Date: 01/22/2022 12:42:54 PM
-- Design Name: Register_File
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File is
    Generic(
            data_width : natural := 32;
            address_width : natural := 4
        );
    Port(
            clk_i, rst_i : in std_logic;
            write_en_i : in std_logic;
            raddress_i, waddress_i : in std_logic_vector(address_width - 1 downto 0);
            wdata_i : in std_logic_vector(data_width - 1 downto 0);
            rdata_o : out std_logic_vector(data_width - 1 downto 0)
        );
end Register_File;

architecture Behavioral of Register_File is

type matrix_type is array(0 to 2 ** address_width - 1) of std_logic_vector(data_width - 1 downto 0);
signal reg_file : matrix_type := (others => (others => '0'));

begin

    RF: process(clk_i)
    begin
        if(rising_edge(clk_i)) then
            if(rst_i = '1') then
                reg_file <= (others => (others => '0'));
            else
                if(write_en_i = '1') then
                    reg_file(to_integer(unsigned(waddress_i))) <= wdata_i;
                end if;
            end if;
        end if;
    end process;
    
    rdata_o <= reg_file(to_integer(unsigned(raddress_i)));
    
end Behavioral;
