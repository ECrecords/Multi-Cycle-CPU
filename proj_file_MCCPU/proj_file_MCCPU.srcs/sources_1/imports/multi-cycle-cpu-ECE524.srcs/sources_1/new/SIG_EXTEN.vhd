----------------------------------------------------------------------------------
-- Company: CSUN
-- Engineer: Diego Cobian and Elvis Chino-Islas
-- 
-- Create Date: 11/27/2021 03:01:17 PM
-- Design Name: IMMEDIATE instructions
-- Module Name: SIG_EXTEN - RTL
-- Project Name: MULTI CYCLE CPU
-- Target Devices: Zybo Z7-20
-- Tool Versions: 
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

entity SIG_EXTEN is
    Port ( INSTR      : in STD_LOGIC_VECTOR (31 downto 0);
           IMM_SEL    : in STD_LOGIC_VECTOR (2 downto 0);
           EXTEN_IMM  : out STD_LOGIC_VECTOR (31 downto 0));
end SIG_EXTEN;

architecture RTL of SIG_EXTEN is

signal Itype_imm : STD_LOGIC_VECTOR(31 downto 0); 
signal Stype_imm : STD_LOGIC_VECTOR(31 downto 0); 
signal Btype_imm : STD_LOGIC_VECTOR(31 downto 0); 
signal Utype_imm : STD_LOGIC_VECTOR(31 downto 0); 
signal Jtype_imm : STD_LOGIC_VECTOR(31 downto 0); 


begin
--R type remains  
--Immediate instructions 
process(INSTR) 
begin 
Itype_imm <= ((31 downto 11 => INSTR(31)) & INSTR(30 downto 25) & INSTR(24 downto 21) & INSTR(20)); 
Stype_imm <= ((31 downto 11 => INSTR(31)) & INSTR(30 downto 25) & INSTR(11 downto 8) & INSTR(7)); 
Btype_imm <= ((31 downto 12 => INSTR(31)) & INSTR(7) & INSTR(30 downto 25) & INSTR(11 downto 8)& '0');
Utype_imm <= (INSTR(31) & INSTR(30 downto 20) & INSTR(19 downto 12)& (11 downto 0 => '0')); 
Jtype_imm <= ((31 downto 20 => INSTR(31)) & INSTR(19 downto 12) & INSTR(20)& INSTR(30 downto 25) & INSTR(24 downto 21) & '0'); 
end process;  

process(IMM_SEL, Itype_imm, Stype_imm, Btype_imm, Utype_imm, Jtype_imm)
begin
case IMM_SEL is
  when "100" =>   EXTEN_IMM <= Itype_imm;
  when "110" =>   EXTEN_IMM <= Stype_imm;
  when "101" =>   EXTEN_IMM <= Btype_imm;
  when "111" =>   EXTEN_IMM <= Utype_imm; 
  when "011" =>   EXTEN_IMM <= Jtype_imm;
  when others =>  EXTEN_IMM <= (others => '-');
end case;
end process; 

end RTL;
