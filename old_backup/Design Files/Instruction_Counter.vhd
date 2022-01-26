----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
--  
-- Create Date: 01/22/2022 12:21:13 PM
-- Design Name: Instruction_Counter
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Counter is
    Generic(
            PC_width : natural := 8
        );
    Port(
            clk_i, rst_i : in std_logic;
            ce_ba_ic_i, and_ic_i, ce_comp_ic_i : in std_logic;
            sel_pc_ic_i : in std_logic;
            comp_ag_i : in std_logic;
            rdata_i : in std_logic_vector(PC_width / 2 - 1 downto 0);
            pc_o : out std_logic_vector(PC_width - 1 downto 0);
            comp_pc_o : out std_logic
        );
end Instruction_Counter;

architecture Behavioral of Instruction_Counter is

signal pc_reg, pc_next : std_logic_vector(PC_width - 1 downto 0);
signal ba_reg, ba_next : std_logic_vector(PC_width / 2 - 1 downto 0);
signal brench_reg, brench_next : std_logic;

signal mux, mux_fsm : std_logic_vector(PC_width - 1 downto 0);
signal and_gate : std_logic;
signal inc : std_logic_vector(PC_width - 1 downto 0);
signal comp_zero : std_logic;
begin

Registers: process(clk_i)
begin
    if(rising_edge(clk_i)) then
        if(rst_i = '1') then
            pc_reg <= (others => '0');
            ba_reg <= (others => '0');
            brench_reg <= '0';
        else
            pc_reg <= pc_next;    
            if(ce_ba_ic_i = '1') then
                ba_reg <= ba_next;
            end if;
            if(ce_comp_ic_i = '1') then
                brench_reg <= brench_next;
            end if;
        end if;
    end if;        
end process;

ba_next <= rdata_i;
pc_next <= mux_fsm;
brench_next <= comp_ag_i;
and_gate <= brench_reg and and_ic_i;
inc <= std_logic_vector(unsigned(pc_reg) + 1);
comp_zero <= '1' when pc_reg = std_logic_vector(to_unsigned(0, pc_reg'length)) else
             '0';
mux <= inc when and_gate = '0' else
       rdata_i & ba_reg; 
mux_fsm <= mux when sel_pc_ic_i = '1' else
           (others => '0');
       
comp_pc_o <= comp_zero;
pc_o <= pc_reg;

end Behavioral;
