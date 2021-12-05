----------------------------------------------------------------------------------
-- Company: California State Universirty
-- Engineer: Elvis Chino-Islas
-- Create Date: 11/27/2021 11:00:00 AM
-- Design Name: Program Counter Test-bench
-- Module Name: PRGM_CNTR_tb - RTL
-- Project Name: Multi-Cycle CPU
-- Target Devices: Zybo Z7-20
-- Tool Versions: Vivado 2021.2 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity PRGM_CNTR_tb is
end entity PRGM_CNTR_tb;

architecture SIMULATION of PRGM_CNTR_tb is

    component PRGM_CNTR is
        Generic (   DATA_BUS : INTEGER := 32    );
        Port (      CLK: in STD_LOGIC;
                    RST: in STD_LOGIC;
                    COUNT_SEL : in STD_LOGIC;
                    OFFSET : in STD_LOGIC_VECTOR(DATA_BUS-1 downto 0);
                    COUNT_OUT: out STD_LOGIC_VECTOR(DATA_BUS-1 downto 0) );
    end component PRGM_CNTR;

    constant CP         : TIME := 8 ns;
    constant BUS_WIDTH  : INTEGER := 32;
    signal clk_tb       : STD_LOGIC;
    signal rst_tb       : STD_LOGIC;
    signal cnt_sel_tb   : STD_LOGIC;
    signal OFFSET_tb    : STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
    signal COUNT_OUT_tb : STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
begin
    uut: PRGM_CNTR Port Map (   CLK => clk_tb, 
                                RST => rst_tb,
                                COUNT_SEL => cnt_sel_tb, 
                                OFFSET => OFFSET_tb, 
                                COUNT_OUT => COUNT_OUT_tb);
    CLK_STIM: process
    begin
        clk_tb <= '0';
        wait for CP/2;
        clk_tb <= '1';
        wait for CP/2;
    end process CLK_STIM;

    CNT_SEL_STIM: process
    begin
        cnt_sel_tb <= '0';
        wait for CP*10;
        cnt_sel_tb <= '1';
        wait for CP;
        cnt_sel_tb <= '0';
        wait for CP*5;
        cnt_sel_tb <= '1';
        wait for CP;
        cnt_sel_tb <= '0';
        wait;
    end process CNT_SEL_STIM;

    OFFSET_STIM: process
    begin
        OFFSET_tb <= STD_LOGIC_VECTOR(TO_SIGNED(0, 32));
        wait for CP*10;
        OFFSET_tb <= STD_LOGIC_VECTOR(TO_SIGNED(127, 32));
        wait for CP;
        OFFSET_tb <= STD_LOGIC_VECTOR(TO_SIGNED(0, 32));
        wait for CP*5;
        OFFSET_tb <= STD_LOGIC_VECTOR(TO_SIGNED(-63, 32));
        wait for CP;
        OFFSET_tb <= STD_LOGIC_VECTOR(TO_SIGNED(0, 32));
        wait;
    end process OFFSET_STIM;
    
    RST_STIM: process
    begin
        rst_tb <= '1';
        wait for CP;
        rst_tb <= '0';
        wait;
    end process RST_STIM;
    
end architecture SIMULATION;