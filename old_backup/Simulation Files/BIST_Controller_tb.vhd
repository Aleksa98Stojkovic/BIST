library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity BIST_Controller_tb is
    --Port();
end BIST_Controller_tb;

architecture Behavioral of BIST_Controller_tb is

component BIST_Controller is
    Port(
            clk_i, rst_i : in std_logic;
            is_eq_i, comp_pc_i, start_i, busy_i, restart_i : in std_logic;
            rdy_o, sel_pc_ic_o : out std_logic
        );
end component;

signal clk, rst, is_eq, comp_pc, start, busy, restart, rdy, sel_pc : std_logic := '0';
signal mux, pc : std_logic_vector(7 downto 0) := (others => '0');

begin

BIST: BIST_Controller
port map(clk_i => clk, rst_i => rst, is_eq_i => is_eq, comp_pc_i => comp_pc, start_i => start, busy_i => busy, restart_i => restart,
         rdy_o => rdy, sel_pc_ic_o => sel_pc);

Reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(rst = '1') then
            pc <= (others => '0');
        else
            pc <= mux;
        end if;
    end if;
end process;

mux <= std_logic_vector(to_unsigned(5, 8)) when sel_pc = '1' else
       (others => '0');

clk_gen: process
begin
    clk <= not clk;
    wait for 100ns;
end process;

data_gen: process
begin
    rst <= '1', '0' after 300ns;
    start <= '0', '1' after 700ns, '0' after 900ns;
    is_eq <= '0', '1' after 1200ns, '0' after 1600ns;
    comp_pc <= '0', '1' after 5000ns, '0' after 5200ns;
    busy <= '1', '0' after 2000ns;
    restart <= '0', '1' after 2000ns, '0' after 2500ns;
    wait;
end process;

end Behavioral;
