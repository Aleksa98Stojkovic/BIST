----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
-- 
-- Create Date: 01/22/2022 12:19:54 PM
-- Design Name: Control_Signal_Generator
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Signal_Generator is
    Port(
            write_en_csg_i : in std_logic;
            write_en_o : out std_logic
        );
end Control_Signal_Generator;

architecture Behavioral of Control_Signal_Generator is

begin

    write_en_o <= write_en_csg_i;

end Behavioral;
