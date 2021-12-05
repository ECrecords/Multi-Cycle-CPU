----------------------------------------------------------------------------------
-- Company: CSUN
-- Engineer: Diego Cobian and Elvis Chino-Islas
-- Create Date: 11/27/2021 09:39:46 AM
-- Design Name: 32 32-Bit Registers
-- Module Name: REG_FILE - RTL
-- Project Name: MULTi CYCLE CPU
-- Target Devices: Zybo Z7-20 
-- Tool Versions: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity REG_FILE is
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
end REG_FILE;

architecture RTL of REG_FILE is
    -- 32 registers of 32 bits
    type register_arr is array (1 to DATA_BUS-1) of STD_LOGIC_VECTOR(DATA_BUS-1 downto 0);
    signal regs : register_arr := (others => X"0000_0000");
begin
    process (CLK)
    begin
        if rising_edge(CLk) then
            if RST = '1' then
                regs <= (others => (others => '0'));
            else
                    if (RS1 = b"0_0000") then
                        D1 <= (others => '0');
                    else
                        D1 <= regs(to_integer(unsigned(RS1)));
                    end if;
                    if (RS2 = b"0_0000") then
                        D2 <= (others => '0');
                    else
                        D2 <= regs(to_integer(unsigned(RS2)));
                    end if;
                if (WE = '1') then
                    if (WA /= b"0_0000") then
                        regs(to_integer(unsigned(WA))) <= WD;
                    end if;
                end if;
            end if;
        end if;
    end process;
end RTL;