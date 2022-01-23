----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
-- 
-- Create Date: 01/22/2022 12:20:13 PM
-- Design Name: Top 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Top is
    Generic(
        data_width        : natural := 32;
        instruction_width : natural := 13;
        address_width     : natural := 4;
        PC_width          : natural := 8;
        counter_width     : natural := 16
    );
    Port ( 
        -- clock & reset
        clk_i : in std_logic;
        rst_i : in std_logic;
        
        -- Datapath inputs
        rdata_i         : in std_logic_vector(data_width - 1 downto 0);
        inst_mem_data_i : in std_logic_vector(address_width - 1 downto 0);
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
end Top;

architecture Behavioral of Top is

component Datapath is
    Generic(
        data_width        : natural := 32;
        instruction_width : natural := 13;
        address_width     : natural := 4;
        PC_width          : natural := 8;
        counter_width     : natural := 16
    );
    Port ( 
        clk_i : in std_logic;
        rst_i : in std_logic;
       
        rdata_i         : in std_logic_vector(data_width - 1 downto 0);
        sel_pc_ic_i     : in std_logic;        -- FSM  
        inst_mem_data_i : in std_logic_vector(address_width - 1 downto 0);
        write_en_RF_i   : in std_logic;
        waddress_RF_i   : in std_logic_vector(address_width - 1 downto 0);
        wdata_RF_i      : in std_logic_vector(data_width - 1 downto 0);
                
        write_en_o      : out std_logic;
        address_o       : out std_logic_vector(counter_width - 1 downto 0);
        is_eq_o         : out std_logic;        -- FSM                                   
        pc_o            : out std_logic_vector(PC_width - 1 downto 0);
        comp_pc_o       : out std_logic;        -- FSM  
        wdata_o         : out std_logic_vector(data_width - 1 downto 0)
    );
end component;

component BIST_Controller is
    Port(
            clk_i       : in std_logic;
            rst_i       : in std_logic;
            is_eq_i     : in std_logic;
            comp_pc_i   : in std_logic;
            start_i     : in std_logic;
            busy_i      : in std_logic;
            restart_i   : in std_logic;
            rdy_o       : out std_logic;
            sel_pc_ic_o : out std_logic
        );
end component;

signal sel_pc_ic_s, is_eq_s, comp_pc_s : std_logic;


begin

datapth: Datapath
    generic map(
        data_width        => data_width,
        instruction_width => instruction_width,
        address_width     => address_width,
        PC_width          => PC_width,
        counter_width     => counter_width
    )
    port map(
        clk_i => clk_i,
        rst_i => rst_i,
       
        rdata_i         => rdata_i,
        sel_pc_ic_i     => sel_pc_ic_s,
        inst_mem_data_i => inst_mem_data_i,
        write_en_RF_i   => write_en_RF_i,
        waddress_RF_i   => waddress_RF_i,
        wdata_RF_i      => wdata_RF_i,
                
        write_en_o => write_en_o,
        address_o  => address_o,
        is_eq_o    => is_eq_s,                             
        pc_o       => pc_o,
        comp_pc_o  => comp_pc_s,
        wdata_o    => wdata_o
    );

controlpath: BIST_Controller
    port map(
        clk_i       => clk_i,
        rst_i       => rst_i,
        is_eq_i     => is_eq_s,
        comp_pc_i   => comp_pc_s,
        start_i     => start_i,
        busy_i      => busy_i,
        restart_i   => restart_i,
        rdy_o       => rdy_o,
        sel_pc_ic_o => sel_pc_ic_s
    );

end Behavioral;
