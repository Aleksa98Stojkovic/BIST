----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
--
-- Create Date: 01/23/2022 12:15:28 PM
-- Design Name: BIST_Controller 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity BIST_Controller is
    Port(
            clk_i, rst_i : in std_logic;
            is_eq_i, comp_pc_i, start_i, busy_i, restart_i : in std_logic;
            rdy_o, sel_pc_ic_o : out std_logic
        );
end BIST_Controller;

architecture Behavioral of BIST_Controller is

type states is (IDLE, WORK, STOP);
signal current_state, next_state : states;

begin

FSM_mem: process(clk_i)
begin
    if(rising_edge(clk_i)) then
        if(rst_i = '1') then
            current_state <= IDLE;
        else
            current_state <= next_state;
        end if;
    end if;
end process;

FSM_comb: process(current_state, is_eq_i, start_i, comp_pc_i, busy_i, restart_i)
begin
    
    rdy_o <= '0';
    sel_pc_ic_o <= '1';
    
    case current_state is
        when IDLE =>
        
            sel_pc_ic_o <= '0';
            next_state <= IDLE;
            if(start_i = '1') then
                next_state <= WORK;
                sel_pc_ic_o <= '1';
            end if;
            
        when WORK =>
        
            next_state <= WORK;
            if(comp_pc_i = '1') then
                next_state <= IDLE;
            else
                if(is_eq_i = '0') then
                    next_state <= STOP;
                end if;
            end if;
        
        when STOP =>
        
            sel_pc_ic_o <= '0';
            next_state <= STOP;
            if(busy_i = '0') then
                if(restart_i = '1') then
                    next_state <= WORK;
                else
                    next_state <= IDLE;
                end if;
            end if;
        
    end case;
    
end process;

end Behavioral;
