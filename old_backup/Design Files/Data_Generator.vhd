----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
-- 
-- Create Date: 01/22/2022 12:20:13 PM
-- Design Name: Data_Generator 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Generator is
    Generic(
            data_width : natural := 32
        );
    Port(
            clk_i, rst_i : in std_logic; 
            ce_dg_i, sel_bg_dg : in std_logic;
            bg_i : in std_logic_vector(data_width - 1 downto 0);
            bg_o, bg_inv_o, wdata_o : out std_logic_vector(data_width - 1 downto 0)  
        );
end Data_Generator;

architecture Behavioral of Data_Generator is

signal bg_reg : std_logic_vector(data_width - 1 downto 0) := (others => '0');

begin

reg: process(clk_i)
begin
    if(rising_edge(clk_i)) then
        if(rst_i = '1') then
            bg_reg <= (others => '0');
            --bg_reg <= X"0000FFFF";
        else
            bg_reg <= bg_reg;
            if(ce_dg_i = '1') then
                bg_reg <= bg_i;
            end if;
        end if;
    end if;
end process;

bg_o <= bg_reg;
bg_inv_o <= not bg_reg;
wdata_o <= bg_reg when sel_bg_dg = '1' else
           not bg_reg;

end Behavioral;
