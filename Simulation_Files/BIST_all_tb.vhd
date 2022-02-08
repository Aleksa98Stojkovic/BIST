library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BIST_all_tb is
--  Port ( );
end BIST_all_tb;

architecture Behavioral of BIST_all_tb is

component Top is
    Generic(
        data_width        : natural := 32;
        instruction_width : natural := 11;
        address_width     : natural := 4;
        inst_mem_width    : natural := 12;
        PC_width          : natural := 8;
        counter_width     : natural := 3
    );
    Port ( 
        -- clock & reset
        clk_i : in std_logic;
        rst_i : in std_logic;
        
        -- Datapath inputs
        rdata_i         : in std_logic_vector(data_width - 1 downto 0);
        inst_mem_data_i : in std_logic_vector(inst_mem_width - 1 downto 0);
        write_en_RF_i   : in std_logic;
        waddress_RF_i   : in std_logic_vector(address_width - 1 downto 0);
        wdata_RF_i      : in std_logic_vector(data_width - 1 downto 0);
        -- Datapath outputs
        write_en_o      : out std_logic;
        address_o       : out std_logic_vector(counter_width - 1 downto 0);                              
        pc_o            : out std_logic_vector(PC_width - 1 downto 0);
        wdata_o         : out std_logic_vector(data_width - 1 downto 0);
        
        -- Controlpath inputs
        start_i         : in std_logic;
        busy_i          : in std_logic;
        restart_i       : in std_logic;
        -- Controlpath outputs
        rdy_o           : out std_logic
    );
end component;

component Dual_Port_Memory is
    generic(
            data_width : natural := 4;
            address_width : natural := 8
            );
    Port(
            clk_i : in std_logic;
            address_A_i, address_B_i : in std_logic_vector(address_width - 1 downto 0);
            write_en_A_i : in std_logic;
            wdata_A_i : in std_logic_vector(data_width - 1 downto 0);
            rdata_A_i, rdata_B_i : out std_logic_vector(data_width - 1 downto 0)
         );
end component;


signal clk : std_logic;
signal rst, write_en_RF, write_en, start, busy, restart, rdy : std_logic;
signal rdata, wdata_RF, wdata : std_logic_vector(31 downto 0);
signal inst_mem_data : std_logic_vector(11 downto 0);
signal waddress_RF : std_logic_vector(3 downto 0);
signal address : std_logic_vector(2 downto 0);                              
signal pc : std_logic_vector(7 downto 0);

begin

BIST: Top
generic map(
        data_width => 32,
        instruction_width => 11,
        inst_mem_width => 12,
        address_width => 4,
        PC_width => 8,
        counter_width => 3
    )
port map(
        -- clock & reset
        clk_i => clk,
        rst_i => rst,                       -- Uradio
        
        -- Datapath inputs
        rdata_i => rdata,
        inst_mem_data_i => inst_mem_data,   -- Uradio
        write_en_RF_i => write_en_RF,       -- Uradio
        waddress_RF_i => waddress_RF,       -- Uradio
        wdata_RF_i => wdata_RF,             -- Uradio
        -- Datapath outputs
        write_en_o => write_en,
        address_o => address,                              
        pc_o => pc,
        wdata_o => wdata,
        
        -- Controlpath inputs
        start_i => start,                   -- Uradio
        busy_i => busy,                     -- Uradio
        restart_i => restart,               -- Uradio
        -- Controlpath outputs
        rdy_o => rdy
    );
    
Instruction_Memory: Dual_Port_Memory
    generic map(
        data_width => 12,
        address_width => 8
    )
    port map(
        clk_i => clk,
        address_A_i => (others => '0'),
        address_B_i => pc,
        write_en_A_i => '0',
        wdata_A_i => (others => '0'),
        rdata_A_i => open,
        rdata_B_i => inst_mem_data
    );
    
Test_Memory: Dual_Port_Memory
    generic map(
        data_width => 32,
        address_width => 3
    )
    port map(
        clk_i => clk,
        address_A_i => address,
        address_B_i => (others => '0'),
        write_en_A_i => write_en,
        wdata_A_i => wdata,
        rdata_A_i => rdata,
        rdata_B_i => open
    );    

clk_gen: process 
begin
    clk <= '0', '1' after 100ns;
    wait for 200ns;
end process;

data_gen: process
begin
    -- Reset Signal --
    rst <= '1', '0' after 300ns;

    -- Register File --
    write_en_RF <= '0';
    waddress_RF <= (others => '0');
    wdata_RF <= (others => '0');
    
    -- Control Signals --
    start <= '0', '1' after 900ns, '0' after 1100ns;
    busy <= '1';
    restart <= '0';
    
    wait;
end process;

end Behavioral;
