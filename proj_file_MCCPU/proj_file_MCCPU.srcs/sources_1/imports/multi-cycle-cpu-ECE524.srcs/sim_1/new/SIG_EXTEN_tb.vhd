----------------------------------------------------------------------------------
-- Company: CSUN
-- Engineer: Diego Cobian and Elvis Chino-Islas
-- 
-- Create Date: 11/27/2021 03:40:25 PM
-- Design Name: IMMEDIATE instructions tb
-- Module Name: SIG_EXTEN_tb - RTL
-- Project Name: MULTI CYCLE CPU
-- Target Devices: Zybo Z7-20
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

entity SIG_EXTEN_tb is
--  Port ( );
end SIG_EXTEN_tb;

architecture RTL of SIG_EXTEN_tb is

component SIG_EXTEN is
    Port ( INSTR : in STD_LOGIC_VECTOR (31 downto 0);
           IMM_SEL : in STD_LOGIC_VECTOR (2 downto 0);
           EXTEN_IMM : out STD_LOGIC_VECTOR (31 downto 0));
end component SIG_EXTEN;

signal INSTR_tb : STD_LOGIC_VECTOR (31 downto 0);
signal IMM_SEL_tb : STD_LOGIC_VECTOR (2 downto 0);
signal EXTEN_IMM_tb : STD_LOGIC_VECTOR (31 downto 0);

begin

UUT: SIG_EXTEN port map(INSTR => INSTR_tb, IMM_SEL => IMM_SEL_tb, EXTEN_IMM => EXTEN_IMM_tb);

testIMM:process
begin 

INSTR_tb <= X"FFFF33AE";
wait for 100ns;
IMM_SEL_tb  <= "100";
wait for 100ns;
IMM_SEL_tb  <= "110";
wait for 40ns;
IMM_SEL_tb  <= "101";
wait for 40ns;
IMM_SEL_tb  <= "111";
wait for 40ns;
IMM_SEL_tb  <= "011";
wait for 40ns;
end process; 

end RTL;
