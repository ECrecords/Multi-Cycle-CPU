----------------------------------------------------------------------------------
-- Company: California State Universirty
-- Engineer: Elvis Chino-Islas
-- Create Date: 11/27/2021 10:30:00 AM
-- Design Name: Program Counter
-- Module Name: PRGM_CNTR - RTL
-- Project Name: Multi-Cycle CPU
-- Target Devices: Zybo Z7-20
-- Tool Versions: Vivado 2021.2 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PRGM_CNTR is
    Generic (   DATA_BUS : INTEGER := 32    );
    Port (      CLK     : in STD_LOGIC;
                RST     : in STD_LOGIC;
                LD      : in STD_LOGIC;
                PC_IN   : in STD_LOGIC_VECTOR(DATA_BUS-1 downto 0);
                PC_OUT  : out STD_LOGIC_VECTOR(DATA_BUS-1 downto 0) );
end entity PRGM_CNTR;

architecture RTL of PRGM_CNTR is
begin
    process( CLK )
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                PC_OUT <= (others => '0');
            else
                if (LD = '1') then
                    PC_OUT <= PC_IN;
                end if;
            end if;
        end if;
    end process;
end architecture RTL;