----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/28/2021 05:38:56 PM
-- Design Name: 
-- Module Name: BRANCH_LOGIC_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BRANCH_LOGIC_tb is
--  Port ( );
end BRANCH_LOGIC_tb;

architecture Behavioral of BRANCH_LOGIC_tb is
component BRANCH_LOGIC is
    generic (
        SEL_WIDTH : integer := 3;
        DATA_BUS  : integer := 32);
    port (
        is_branch    : in std_logic;
        reg_Adata_in : in std_logic_vector (DATA_BUS - 1 downto 0);
        reg_Bdata_in : in std_logic_vector (DATA_BUS - 1 downto 0);
        IMM_in       : in std_logic_vector (DATA_BUS - 1 downto 0);
        cond_sel     : in std_logic_vector (SEL_WIDTH - 1 downto 0);
        BRANCH_SIG   : out std_logic_vector (DATA_BUS - 1 downto 0));
end component BRANCH_LOGIC;

 signal is_branch_tb : std_logic;
 signal reg_Adata_in_tb : std_logic_vector (31 downto 0);
 signal reg_Bdata_in_tb : std_logic_vector (31 downto 0);
 signal IMM_in_tb       : std_logic_vector (31 downto 0);
 signal cond_sel_tb     : std_logic_vector (2 downto 0);
 signal BRANCH_SIG_tb   : std_logic_vector (31 downto 0);

begin

UUT: BRANCH_LOGIC port map( is_branch => is_branch_tb, 
                            reg_Adata_in => reg_Adata_in_tb,
                            reg_Bdata_in => reg_Bdata_in_tb,
                            IMM_in => IMM_in_tb, 
                            cond_sel => cond_sel_tb, 
                            BRANCH_SIG => BRANCH_SIG_tb); 
                            
Test_BLogic: process 
begin 

-- Case with Dont cares
is_branch_tb<= '0'; 
reg_Adata_in_tb<= (others => 'X');
reg_Bdata_in_tb<= (others => 'X');
IMM_in_tb <= (others => 'X'); 
cond_sel_tb <= (others => 'X');
wait for 200ns;

-- Case 000 BEQ  4 != 5
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(2, 32)); 
cond_sel_tb <= "000"; 
wait for 200ns; 

-- Case 000 BEQ  4 = 4
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(3, 32)); 
cond_sel_tb <= "000"; 
wait for 200ns; 

-- Case 000 BEQ  -4 = -4
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(-4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(-4, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(3, 32)); 
cond_sel_tb <= "000"; 
wait for 200ns; 

-- Case 001 BNE  5 = 4
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(4, 32)); 
cond_sel_tb <= "001"; 
wait for 200ns; 

-- Case 001 BNE  4 = 4
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(4, 32)); 
cond_sel_tb <= "001"; 
wait for 200ns; 

-- Case 001 BNE  -5 = 6
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(-5, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(6, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(4, 32)); 
cond_sel_tb <= "001"; 
wait for 200ns; 

-- Case 010 BLT  4 < 5
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(5, 32)); 
cond_sel_tb <= "010"; 
wait for 200ns; 

-- Case 010 BLT  5 = 5
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(5, 32)); 
cond_sel_tb <= "010"; 
wait for 200ns; 

-- Case 010 BLT  -4 < 5
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(-4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(5, 32)); 
cond_sel_tb <= "010"; 
wait for 200ns; 


-- Case 011 BLTU  4 < -5
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(-5, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(6, 32)); 
cond_sel_tb <= "011"; 
wait for 200ns; 

-- Case 011 BLTU  5 = 5
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(6, 32)); 
cond_sel_tb <= "011"; 
wait for 200ns; 

-- Case 011 BLTU  -4 < 5
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(-4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(6, 32)); 
cond_sel_tb <= "011"; 
wait for 200ns; 

-- Case 100 BLE  4 < 6
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(6, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(7, 32)); 
cond_sel_tb <= "100"; 
wait for 200ns; 

-- Case 100 BLE  5 < 4
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(7, 32)); 
cond_sel_tb <= "100"; 
wait for 200ns; 

-- Case 100 BLE  5 = 5
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(7, 32)); 
cond_sel_tb <= "100"; 
wait for 200ns; 

-- Case 110 BLEU  4 < 7
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(7, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(8, 32)); 
cond_sel_tb <= "110"; 
wait for 200ns; 

-- Case 110 BLEU  5 = 5
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(5, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(8, 32)); 
cond_sel_tb <= "110"; 
wait for 200ns; 

-- Case 110 BLEU  4 < -7
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(-7, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(8, 32)); 
cond_sel_tb <= "110"; 
wait for 200ns; 

-- Case 110 BLEU  -7 <  4
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(-7, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(4, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(8, 32)); 
cond_sel_tb <= "110"; 
wait for 200ns; 



-- Case 111 UNC --> gets IMM_IN
is_branch_tb<= '1'; 
reg_Adata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(3, 32));
reg_Bdata_in_tb<= STD_LOGIC_VECTOR(TO_SIGNED(3, 32));
IMM_in_tb <= STD_LOGIC_VECTOR(TO_SIGNED(9, 32)); 
cond_sel_tb <= "111"; 
wait for 200ns; 
--STD_LOGIC_VECTOR(TO_SIGNED(4, 32))

end process; 
                            
                            
end Behavioral;
