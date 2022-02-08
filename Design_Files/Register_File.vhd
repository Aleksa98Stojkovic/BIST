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
signal reg_file : matrix_type := (X"F0F0F0F0",
                                  X"FFFF0000",
                                  X"FF00FF00",
                                  X"F000000F",
                                  X"0F0000F0",
                                  X"00000000",
                                  X"F0000000",
                                  X"0F000000",
                                  X"00F00000",
                                  X"000F0000",
                                  X"0000F000",
                                  X"00000F00",
                                  X"000000F0",
                                  X"0000000F",
                                  X"FFF0FFF0",
                                  X"00FF00FF"
                                  );
signal addr_next, addr_reg : std_logic_vector(address_width - 1 downto 0);

begin

    RF: process(clk_i)
    begin
        if(rising_edge(clk_i)) then
            if(rst_i = '1') then
                --reg_file <= (others => (others => '0'));
                reg_file <=  (X"F0F0F0F0",
                              X"FFFF0000",
                              X"FF00FF00",
                              X"F000000F",
                              X"0F0000F0",
                              X"000F0000",
                              X"F0000000",
                              X"0F000000",
                              X"00F00000",
                              X"000F0000",
                              X"0000F000",
                              X"00000F00",
                              X"000000F0",
                              X"0000000F",
                              X"FFF0FFF0",
                              X"00FF00FF"
                              );
                addr_reg <= (others => '0');
            else
                if(write_en_i = '1') then
                    reg_file(to_integer(unsigned(waddress_i))) <= wdata_i;
                end if;
                
                addr_reg <= addr_next;
            end if;
        end if;
    end process;
    
    rdata_o <= reg_file(to_integer(unsigned(addr_reg)));
    addr_next <= raddress_i;
    
    
end Behavioral;
