----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2021 09:45:58 AM
-- Design Name: 
-- Module Name: CPU_tb - Behavioral
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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU_tb is
    --  Port ( );
end CPU_tb;

architecture Behavioral of CPU_tb is
    component CPU is
        generic (DATA_BUS : INTEGER := 32);
        port (
            GCLK     : in STD_LOGIC;
            MRST     : in STD_LOGIC;
            BYTE_SEL : in STD_LOGIC_VECTOR(3 downto 0);
            CSR0_SW  : in STD_LOGIC_VECTOR(3 downto 0);
            CSR1_LED : out STD_LOGIC_VECTOR(7 downto 0));
    end component CPU;

    signal GCLK_tb : STD_LOGIC;
    signal MRST_tb : STD_LOGIC;
    signal CSR0_tb : STD_LOGIC_VECTOR(3 downto 0);
    signal CSR1_tb : STD_LOGIC_VECTOR(7 downto 0);

    constant CP : TIME := 10 ns;
begin
    UUT : CPU port map(GCLK => GCLK_tb, MRST => MRST_tb, BYTE_SEL => "0001", CSR0_SW => CSR0_tb, CSR1_LED => CSR1_tb);

    clk_process : process
    begin
        GCLK_tb <= '0';
        wait for CP/2;
        GCLK_tb <= '1';
        wait for CP/2;
    end process;

    stimuli : process
    begin
        CSR0_tb <= (others => '0');
        MRST_tb <= '1';
        wait for CP;
        MRST_tb <= '0';
        wait;
    end process;

end Behavioral;