----------------------------------------------------------------------------------
-- Company: California State University, Northridge
-- Engineer: Diego Cobian and Elvis Chino-Islas
-- Create Date: 12/04/2021 10:30:29 AM
-- Design Name: FSM Test Bench
-- Module Name: FSM_CONTROL_tb - Behavioral
-- Project Name: MULTI-CYCLE CPU
-- Target Devices: ZYBO Z7-20
-- Tool Versions: 2019.1
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

entity FSM_CONTROL_tb is
--  Port ( );
end FSM_CONTROL_tb;

architecture Behavioral of FSM_CONTROL_tb is
component FSM_CONTROL is
     generic (
          SEL_WIDTH : INTEGER := 3);
     port (
          CLK          : in STD_LOGIC;
          RST          : in STD_LOGIC;
          OPCODE       : in STD_LOGIC_VECTOR(6 downto 0); 
          PC_WE        : out STD_LOGIC;
          MEM_ADDR_SEL : out STD_LOGIC;
          MEM_WE       : out STD_LOGIC;
          MEM_RE       : out STD_LOGIC;
          IR_WE        : out STD_LOGIC;
          CSR_WE       : out STD_LOGIC;
          RF_WCSR      : out STD_LOGIC;
          RF_WDATA_SEL : out STD_LOGIC;
          RF_WE        : out STD_LOGIC;
          IMM_SEL      : out STD_LOGIC_VECTOR(2 downto 0);
          ALUA_SEL     : out STD_LOGIC;
          ALUB_SEL     : out STD_LOGIC_VECTOR(1 downto 0);
          ALU_OP       : out STD_LOGIC_VECTOR(1 downto 0);
          IS_BRANCH    : out STD_LOGIC;
          COND_SEL     : out STD_LOGIC_VECTOR(2 downto 0)
     );
end component FSM_CONTROL;

  signal  CLK_tb : STD_LOGIC;
  signal  RST_tb          : STD_LOGIC;
  signal  OPCODE_tb       : STD_LOGIC_VECTOR(6 downto 0); 
  signal  PC_WE_tb        : STD_LOGIC;
  signal  MEM_ADDR_SEL_tb : STD_LOGIC;
  signal  MEM_WE_tb       : STD_LOGIC;
  signal  MEM_RE_tb       : STD_LOGIC;
  signal  IR_WE_tb        : STD_LOGIC;
  signal  CSR_WE_tb       : STD_LOGIC;
  signal  RF_WCSR_tb      : STD_LOGIC;
  signal  RF_WDATA_SEL_tb : STD_LOGIC;
  signal  RF_WE_tb        : STD_LOGIC;
  signal  IMM_SEL_tb      : STD_LOGIC_VECTOR(2 downto 0);
  signal  ALUA_SEL_tb     : STD_LOGIC;
  signal  ALUB_SEL_tb     : STD_LOGIC_VECTOR(1 downto 0);
  signal  ALU_OP_tb       : STD_LOGIC_VECTOR(1 downto 0);
  signal  IS_BRANCH_tb    : STD_LOGIC;
  signal  COND_SEL_tb     : STD_LOGIC_VECTOR(2 downto 0);

constant clk_per : time := 10ns; 
begin

UUT: FSM_CONTROL port map( 
      CLK => CLK_tb,
      RST => RST_tb,
      OPCODE => OPCODE_tb,
      PC_WE  => PC_WE_tb,
      MEM_ADDR_SEL => MEM_ADDR_SEL_tb,
      MEM_WE => MEM_WE_tb,
      MEM_RE => MEM_RE_tb,
      IR_WE => IR_WE_tb,
      CSR_WE => CSR_WE_tb,
      RF_WCSR => RF_WCSR_tb,
      RF_WDATA_SEL => RF_WDATA_SEL_tb,
      RF_WE => RF_WE_tb,
      IMM_SEL => IMM_SEL_tb,
      ALUA_SEL => ALUA_SEL_tb,
      ALUB_SEL => ALUB_SEL_tb,
      ALU_OP => ALU_OP_tb,
      IS_BRANCH => IS_BRANCH_tb,
      COND_SEL => COND_SEL_tb);

clk_process :process
begin
   CLK_tb <= '0';
   wait for clk_per/2;
   CLK_tb <= '1';
   wait for clk_per/2;
end process clk_process;
 
rst_process: process 
begin 
RST_tb <= '1'; 
wait for clk_per;
rst_tb <= '0';
wait;
end process; 

FSM_test:process
begin 
  OPCODE_tb <= "1100011"; 
  wait for (7*clk_per)+clk_per/2; 
  OPCODE_tb <= "1100111"; 
  wait for (5*clk_per);
  OPCODE_tb <= "1101011"; 
   wait for (4*clk_per);
  OPCODE_tb <= "1101111"; 
  wait for (5*clk_per);
  OPCODE_tb <= "1110011"; 
  wait for (4*clk_per);
  OPCODE_tb <= "1110111"; 
  wait for (6*clk_per);
  OPCODE_tb <= "1111011"; 
  wait for (5*clk_per);
  OPCODE_tb <= "1111111"; 
  wait for (5*clk_per);

end process; 


end Behavioral;
