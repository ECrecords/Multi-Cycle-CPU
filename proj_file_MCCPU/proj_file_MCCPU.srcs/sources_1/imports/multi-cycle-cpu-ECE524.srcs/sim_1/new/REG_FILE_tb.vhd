----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Diego Cobian and Elvis Chino-Islas
-- 
-- Create Date: 11/27/2021 10:01:32 AM
-- Design Name: 32 32-Bit Registers tb
-- Module Name: REG_FILE_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REG_FILE_tb is
--  Port ( );
end REG_FILE_tb;

architecture Behavioral of REG_FILE_tb is

component REG_FILE is
    Generic (   DATA_BUS : integer := 32);
    Port (      CLK : in STD_LOGIC;
                RST : in STD_LOGIC;
                WE  : in STD_LOGIC;
                RS1 : in STD_LOGIC_VECTOR (4 downto 0);
                RS2 : in STD_LOGIC_VECTOR (4 downto 0);
                WA  : in STD_LOGIC_VECTOR (4 downto 0);
                WD  : in STD_LOGIC_VECTOR (DATA_BUS-1 downto 0);
                D1  : out STD_LOGIC_VECTOR (DATA_BUS-1 downto 0);
                D2  : out STD_LOGIC_VECTOR (DATA_BUS-1 downto 0)  );
end component REG_FILE;


signal clk_tb   : std_logic;
signal en_tb    : std_logic;
signal rst_tb   : std_logic;
signal wen_tb    : std_logic;
signal selrA_tb  : std_logic_vector (4 downto 0);
signal selrB_tb  : std_logic_vector (4 downto 0);
signal selrD_tb  : std_logic_vector (4 downto 0);
signal dataD_in_tb : std_logic_vector (31 downto 0);
signal dataA_out_tb : std_logic_vector (31 downto 0);
signal dataB_out_tb : std_logic_vector (31 downto 0);

constant clk_per : time := 10ns; 

begin
UUT: REG_FILE port map (CLK => clk_tb, rst => rst_tb, WE => wen_tb, RS1 => selrA_tb, RS2 => selrB_tb, WA => selrD_tb,
 WD => dataD_in_tb, D1 => dataA_out_tb, D2 => dataB_out_tb);

clk_process :process
begin
   clk_tb <= '0';
   wait for clk_per/2;
   clk_tb <= '1';
   wait for clk_per/2;
end process clk_process;
 
rst_process: process 
begin 
rst_tb <= '1'; 
wait for clk_per;
rst_tb <= '0';
wait;
end process; 

 
reg_test: process
begin


   -- read both r0 and r1 and r0 = 0xAA6B
   selrA_tb <= "00000";
   selrB_tb <= "00001";
   selrD_tb <= "00000";
   dataD_in_tb <= X"AA6BAA6B";
   wen_tb <= '1';
   wait for clk_per*2;
   
    -- r2 = 0x2222
    selrA_tb <= "00000";
    selrB_tb <= "00001";
    selrD_tb <= "00010";
    dataD_in_tb <= X"22222222";
    wen_tb <= '1';
    wait for clk_per*2;
  
    -- Writing to same location, r2 = 0x3333
    selrA_tb <= "00000";
    selrB_tb <= "00001";
    selrD_tb <= "00010";
    dataD_in_tb <= X"33333333";
    wen_tb <= '1';
    wait for clk_per*2;
 
   -- Testing read, No writing
   selrA_tb <= "00000";
   selrB_tb <= "00001";
   selrD_tb <= "00000";
   dataD_in_tb <= X"BABEBABE";
   wen_tb <= '0';
   wait for clk_per*2;
 
   --dataA shouldn't have BABE
   selrA_tb <= "00001";
   selrB_tb <= "00010";
   wait for clk_per*2;
 
   selrA_tb <= "00011";
   selrB_tb <= "00100";
   wait for clk_per*2;
 
   -- r4 = 0X4444
   selrA_tb <= "00000";
   selrB_tb <= "00001";
   selrD_tb <= "00100";
   dataD_in_tb <= X"44444444";
   wen_tb <= '1';
   wait for clk_per*2;
 
   wen_tb <= '0';
   wait for clk_per*2;
 
   selrA_tb <= "00100";
   selrB_tb <= "00100";
   wait for clk_per*2;
   wait;
end process reg_test;

end Behavioral;
