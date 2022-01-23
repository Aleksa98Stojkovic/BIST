----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
--
-- Create Date: 01/22/2022 12:20:55 PM
-- Design Name: Response_Analyzer
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Response_Analyzer is
    Generic(
            data_width : natural := 32
        );
    Port(
            rdata_i : in std_logic_vector(data_width - 1 downto 0);
            sel_bg_ra_i : in std_logic;
            bg_i, bg_inv_i : in std_logic_vector(data_width - 1 downto 0);
            is_eq_o : out std_logic
        );
end Response_Analyzer;

architecture Behavioral of Response_Analyzer is

signal mux : std_logic_vector(data_width - 1 downto 0);

begin

mux <= bg_i when sel_bg_ra_i = '1' else
       bg_inv_i;

is_eq_o <= '1' when rdata_i = mux else
           '0'; 

end Behavioral;
