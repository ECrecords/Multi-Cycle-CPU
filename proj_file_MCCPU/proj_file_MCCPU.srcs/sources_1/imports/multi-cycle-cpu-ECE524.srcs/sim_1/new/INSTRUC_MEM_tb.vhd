----------------------------------------------------------------------------------
-- Company: California State Universirty
-- Engineer: Elvis Chino-Islas
-- Create Date: 11/27/2021 10:54:00 AM
-- Design Name: Instruction Memory Test-bench
-- Module Name: INSTRUC_MEM_tb - RTL
-- Project Name: Multi-Cycle CPU
-- Target Devices: Zybo Z7-20
-- Tool Versions: Vivado 2021.2 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRUC_MEM_tb is
end entity INSTRUC_MEM_tb;

architecture SIMULATION of INSTRUC_MEM_tb is
    component INSTRUC_MEM is
        Generic (   ADDR_BUS: INTEGER := 32;
                    DATA_BUS: INTEGER := 32 );
        Port (      CLK     : in STD_LOGIC;
                    ENA     : in STD_LOGIC;
                    ADDR    : in STD_LOGIC_VECTOR(ADDR_BUS-1 downto 0);
                    DATA    : out STD_LOGIC_VECTOR(DATA_BUS-1 downto 0) );
    end component INSTRUC_MEM;
    
    constant BUS_WIDTH  : INTEGER := 32;
    signal clk_tb       : STD_LOGIC;
    signal ena_tb       : STD_LOGIC;
    signal ADDR_tb      : STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
    signal DATA_tb      : STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
begin
    


    
    
end architecture SIMULATION;