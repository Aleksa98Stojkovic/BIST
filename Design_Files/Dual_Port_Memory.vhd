----------------------------------------------------------------------------------
-- Faculty: Faculty of Technical Sciences 
-- Engineers: Aleksa Stojkovic, Boris Radovanovic 
-- 
-- Create Date: 01/22/2022 12:21:57 PM
-- Design Name: Dual_Port_Meomory
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use std.textio.all;

entity Dual_Port_Memory is
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
end Dual_Port_Memory;

architecture Behavioral of Dual_Port_Memory is

type matrix_type is array(0 to 2 ** address_width - 1) of std_logic_vector(data_width - 1 downto 0);

-- Funkcija koja inicijalizuje BRAM preko txt fajla --
impure function init_ram_hex return matrix_type is
  file text_file : text open read_mode is "C:\Users\bokir\Desktop\ram_content.txt"; -- staviti apsolutnu adresu
  variable text_line : line;
  variable ram_content : matrix_type;
  variable c : character;
  variable offset : integer;
  variable hex_val : std_logic_vector(3 downto 0);
begin
  for i in 0 to 2**address_width - 1 loop
    readline(text_file, text_line);
 
    offset := 0;
 
    while offset < ram_content(i)'high loop
      read(text_line, c);
 
      case c is
        when '0' => hex_val := "0000";
        when '1' => hex_val := "0001";
        when '2' => hex_val := "0010";
        when '3' => hex_val := "0011";
        when '4' => hex_val := "0100";
        when '5' => hex_val := "0101";
        when '6' => hex_val := "0110";
        when '7' => hex_val := "0111";
        when '8' => hex_val := "1000";
        when '9' => hex_val := "1001";
        when 'A' | 'a' => hex_val := "1010";
        when 'B' | 'b' => hex_val := "1011";
        when 'C' | 'c' => hex_val := "1100";
        when 'D' | 'd' => hex_val := "1101";
        when 'E' | 'e' => hex_val := "1110";
        when 'F' | 'f' => hex_val := "1111";
 
        when others =>
          hex_val := "XXXX";
          assert false report "Found non-hex character '" & c & "'";
      end case;
 
      ram_content(i)(ram_content(i)'high - offset
        downto ram_content(i)'high - offset - 3) := hex_val;
      offset := offset + 4;
 
    end loop;
  end loop;
 
  return ram_content;
end function;

signal memory : matrix_type := init_ram_hex;

begin

    Mem: process(clk_i)
    begin
        if(rising_edge(clk_i)) then
            -- Port A
            if(write_en_A_i = '1') then
                memory(to_integer(unsigned(address_A_i))) <= wdata_A_i;
            end if;
            rdata_A_i <= memory(to_integer(unsigned(address_A_i)));
            -- Port B 
            rdata_B_i <= memory(to_integer(unsigned(address_B_i)));
        end if;
    end process;

end Behavioral;
