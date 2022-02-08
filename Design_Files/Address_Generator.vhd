----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
--
-- Create Date: 01/22/2022 12:20:38 PM
-- Design Name: Address_Generator
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Address_Generator is
    Generic(
            counter_width : natural := 16
        );
    Port(
            clk_i, rst_i : in std_logic;
            up_down_ag_i, load_en_ag_i, ce_ag_i, sel_load_ag_i, sel_ag_i : in std_logic;
            address_o : out std_logic_vector(counter_width - 1 downto 0);
            comp_ag_o : out std_logic
        );
end Address_Generator;

architecture Behavioral of Address_Generator is

constant zeros : std_logic_vector(counter_width - 1 downto 0) := (others => '0');
constant ones : std_logic_vector(counter_width - 1 downto 0) := (others => '1');

signal counter : std_logic_vector(counter_width - 1 downto 0) := (others => '0');
signal mux_comp : std_logic;
signal mux_load : std_logic_vector(counter_width - 1 downto 0);
signal comp_zero, comp_max : std_logic;

begin

Count: process(clk_i)
begin
    if(rising_edge(clk_i)) then
        if(rst_i = '1') then
            counter <= (others => '0');
        else
            counter <= counter;
            if(ce_ag_i = '1') then
                if(load_en_ag_i = '1') then
                    counter <= mux_load;
                else
                    if(up_down_ag_i = '1') then
                        counter <= std_logic_vector(unsigned(counter) + 1);
                    else
                        counter <= std_logic_vector(unsigned(counter) - 1);
                    end if;
                end if;
            end if;
        end if;
    end if;
end process;

-- Zašto ?ubre generiše ROM umesto komparatora?
comp_zero <= '0' when counter = zeros else
             '1';
comp_max <= '0' when counter = ones else
            '1';

mux_load <= zeros when sel_load_ag_i = '1' else
            ones;
mux_comp <= comp_zero when sel_ag_i = '1' else
            comp_max;
            
address_o <= counter;
comp_ag_o <= mux_comp;            

end Behavioral;
