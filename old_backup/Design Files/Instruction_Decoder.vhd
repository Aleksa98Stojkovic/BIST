----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
-- 
-- Create Date: 01/22/2022 12:21:32 PM
-- Design Name: Instruction_Decoder
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Instruction_Decoder is
    Generic(
            address_width : natural := 4;
            data_width : natural := 14
        );
    Port(
            clk_i, rst_i : in std_logic;
            rdata_i : in std_logic_vector(address_width - 1 downto 0);
            ctrl_o : out std_logic_vector(data_width - 1 downto 0)
        );
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is

component Microinstruction_Memory is
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
end component;

signal mux : std_logic_vector(address_width - 1 downto 0);
signal ctrl : std_logic_vector(data_width - 1 downto 0);
signal add : std_logic_vector(address_width - 1 downto 0);
signal last_addr : std_logic_vector(address_width - 1 downto 0);
signal combine : std_logic_vector(1 downto 0);

begin

Reg: process(clk_i)
begin
    if(rising_edge(clk_i)) then
        if(rst_i = '1') then
            last_addr <= (others => '0');
        else
            last_addr <= rdata_i;
        end if;
    end if;
end process;

MicroMemory: Microinstruction_Memory
    generic map(data_width => data_width, address_width => address_width)
    port map(clk_i => clk_i, address_A_i => (others => '0'), address_B_i => mux, write_en_A_i => '0', 
             wdata_A_i => (others => '0'), rdata_A_i => open, rdata_B_i => ctrl);

ctrl_o <= ctrl;
combine <= '0' & ctrl(5);
-- Kako se mapira ova jedinica na carry bit?
add <= std_logic_vector(unsigned(last_addr) + unsigned(combine) + 1);
mux <= rdata_i when ctrl(0) = '0' else
       add;

end Behavioral;
