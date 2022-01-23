----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
-- 
-- Create Date: 01/22/2022 12:42:54 PM
-- Design Name: Datapath
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Datapath is
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
end Datapath;

architecture Behavioral of Datapath is

--****************************** COMPONENTS ******************************

component Control_Signal_Generator is
    Port(
            write_en_csg_i : in std_logic;
            write_en_o : out std_logic
        );
end component;

component Data_Generator is
    Generic(
            data_width : natural := 32
        );
    Port(
            clk_i, rst_i : in std_logic;
            ce_dg_i, sel_bg_dg : in std_logic;
            bg_i : in std_logic_vector(data_width - 1 downto 0);
            bg_o, bg_inv_o : out std_logic_vector(data_width - 1 downto 0);
            wdata_o : out std_logic_vector(data_width - 1 downto 0)  
        );
end component;

component Address_Generator is
    Generic(
            counter_width : natural := 16
        );
    Port(
            clk_i, rst_i : in std_logic;
            up_down_ag_i, load_en_ag_i, ce_ag_i, sel_load_ag_i, sel_ag_i : in std_logic;
            address_o : out std_logic_vector(counter_width - 1 downto 0);
            comp_ag_o : out std_logic
        );
end component;

component Response_Analyzer is
    Generic(
            data_width : natural := 32
        );
    Port(
            rdata_i : in std_logic_vector(data_width - 1 downto 0);
            sel_bg_ra_i : in std_logic;
            bg_i, bg_inv_i : in std_logic_vector(data_width - 1 downto 0);
            is_eq_o : out std_logic
        );
end component;

component Instruction_Counter is
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
end component;

component Instruction_Decoder is
    Generic(
            address_width : natural := 4;
            data_width : natural := 12
        );
    Port(
            clk_i, rst_i : in std_logic;
            rdata_i : in std_logic_vector(address_width - 1 downto 0);
            ctrl_o : out std_logic_vector(data_width - 1 downto 0)
        );
end component;

component Register_File is
    Generic(
            data_width : natural := 32;
            address_width : natural := 4
        );
    Port(
            clk_i, rst_i : in std_logic;
            write_en_i : in std_logic;
            raddress_i, waddress_i : in std_logic_vector(address_width - 1 downto 0);
            wdata_i : in std_logic_vector(data_width - 1 downto 0);
            rdata_o : out std_logic_vector(data_width - 1 downto 0)
        );
end component;

--****************************************************************************

signal ctrl_s : std_logic_vector(instruction_width - 1 downto 0);
signal write_en_s : std_logic;
signal bg_s, bg_gen_s, bg_gen_inv_s : std_logic_vector(data_width - 1 downto 0);
signal comp_ag_s : std_logic;

begin

ctrl_signal_gen: Control_Signal_Generator
    port map(
        write_en_csg_i => ctrl_s(11),
        write_en_o => write_en_o  
    );

data_gen: Data_Generator
    generic map(
        data_width => data_width
    )
    port map(
        clk_i => clk_i,
        rst_i => rst_i,
        ce_dg_i => ctrl_s(10),
        sel_bg_dg => ctrl_s(12),
        bg_i => bg_s,
        bg_o => bg_gen_s,
        bg_inv_o => bg_gen_inv_s,
        wdata_o => wdata_o
    );

address_gen: Address_Generator 
    generic map(
        counter_width => counter_width
    )
    port map(
        clk_i => clk_i,
        rst_i => rst_i,
        up_down_ag_i => ctrl_s(9),
        load_en_ag_i => ctrl_s(7),
        ce_ag_i => ctrl_s(8),
        sel_load_ag_i => ctrl_s(6),
        sel_ag_i => ctrl_s(5),
        address_o => address_o,
        comp_ag_o => comp_ag_s
    );

resp_analyzer: Response_Analyzer
    generic map(
        data_width => data_width
    )
    port map(
        rdata_i => rdata_i,
        sel_bg_ra_i => ctrl_s(4),
        bg_i => bg_gen_s,
        bg_inv_i => bg_gen_inv_s,
        is_eq_o => is_eq_o
    );

instruction_cnt: Instruction_Counter
    generic map(
        PC_width => PC_width
    )
    port map(
        clk_i => clk_i,
        rst_i => rst_i,
        ce_ba_ic_i => ctrl_s(3),
        and_ic_i => ctrl_s(2),
        ce_comp_ic_i => ctrl_s(1),
        sel_pc_ic_i => sel_pc_ic_i,
        comp_ag_i => comp_ag_s,
        rdata_i => inst_mem_data_i,
        pc_o => pc_o, 
        comp_pc_o => comp_pc_o 
    );

instruction_dec: Instruction_Decoder 
    generic map(
        address_width => address_width,
        data_width => instruction_width
    )
    port map(
        clk_i => clk_i,
        rst_i => rst_i,
        rdata_i => inst_mem_data_i, 
        ctrl_o => ctrl_s
    );

reg_file: Register_File
    generic map(
        data_width => data_width,
        address_width => address_width
    )
    port map(
        clk_i => clk_i,
        rst_i => rst_i,
        write_en_i => write_en_RF_i,
        raddress_i => inst_mem_data_i,
        waddress_i => waddress_RF_i,
        wdata_i => wdata_RF_i,
        rdata_o => bg_s
    );

end Behavioral;
