----------------------------------------------------------------------------------
-- Company: California State University
-- Engineer: Elvis Chino-Islas
-- Create Date: 11/27/2021 2:25:00 AM
-- Design Name: ALU Test-bench
-- Module Name: ALU_tb - RTL
-- Project Name: Multi-Cycle CPU
-- Target Devices: Zybo Z7-20
-- Tool Versions: Vivado 2021.2 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
end entity ALU_tb;

architecture RTL of ALU_tb is
    component ALU is
        Generic (   DATA_BUS    : INTEGER := 32;
                    SEL_WIDTH   : INTEGER := 4  );
    
        Port (      SEL : in STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0);
                    A   : in STD_LOGIC_VECTOR(DATA_BUS-1 downto 0);
                    B   : in STD_LOGIC_VECTOR(DATA_BUS-1 downto 0);
                    C   : out STD_LOGIC_VECTOR(DATA_BUS-1 downto 0)    );
    end component ALU;

    constant DELAY      : TIME := 10 ns;
    constant DATA_BUS   : INTEGER := 32;
    constant SEL_WIDTH  : INTEGER := 4;
    
    type TEST_VECTOR is array (natural range <>) of INTEGER;
    constant A_TEST : TEST_VECTOR (0 to 9) := (255, 127, 63, 31, 15, 7, 4, 511, -1023, 2047);
    constant B_TEST : TEST_VECTOR (0 to 9) := (-2047, 1023, 511, 4, 7, 15, 10, 4, 15, 255);

    signal sel_tb   : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0);
    signal a_tb     : SIGNED(DATA_BUS-1 downto 0);
    signal b_tb     : SIGNED(DATA_BUS-1 downto 0);
    signal c_tb     : STD_LOGIC_VECTOR(DATA_BUS-1 downto 0);
begin
    uut: ALU Port Map ( SEL => sel_tb, 
                        A => STD_LOGIC_VECTOR(a_tb), 
                        B => STD_LOGIC_VECTOR(b_tb), 
                        C => c_tb  );
    
    SEL_STIM: process
    begin 
        for i in 0 to 9 loop
            sel_tb <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, SEL_WIDTH));
            wait for DELAY;
        end loop;
    end process SEL_STIM;
    
    A_STIM: process
    begin
        for i in A_TEST'range loop
            a_tb <= TO_SIGNED(A_TEST(i), DATA_BUS);
            wait for DELAY;
        end loop;
    end process A_STIM;

    B_STIM: process
    begin
        for i in B_TEST'range loop
            b_tb <= TO_SIGNED(B_TEST(i), DATA_BUS);
            wait for DELAY;
        end loop;
    end process B_STIM;
    
end architecture RTL;