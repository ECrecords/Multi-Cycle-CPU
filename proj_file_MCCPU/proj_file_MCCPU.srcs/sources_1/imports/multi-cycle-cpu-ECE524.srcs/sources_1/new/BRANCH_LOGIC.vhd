----------------------------------------------------------------------------------
-- Company: CSUN
-- Engineer: DIEGO COBIAN AND ELVIS CHINO-ISLAS
-- 
-- Create Date: 11/28/2021 10:08:55 AM
-- Design Name: Branch Jump
-- Module Name: BRANCH_LOGIC - Behavioral
-- Project Name: MULTI_CYCLE CPU
-- Target Devices: ZYBO Z7-20
-- Tool Versions: Vivado 2019.1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BRANCH_LOGIC is
    generic (
        SEL_WIDTH : INTEGER := 3;
        DATA_BUS  : INTEGER := 32);
    port (
        REG_ADATA_IN : in STD_LOGIC_VECTOR (DATA_BUS - 1 downto 0);
        REG_BDATA_IN : in STD_LOGIC_VECTOR (DATA_BUS - 1 downto 0);
        COND_SEL     : in STD_LOGIC_VECTOR (SEL_WIDTH - 1 downto 0);
        BRANCH       : out STD_LOGIC
    );
end BRANCH_LOGIC;

architecture RTL of BRANCH_LOGIC is

    constant BEQ  : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"000";
    constant BNE  : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"001";
    constant BLT  : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"010";
    constant BLTU : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"011";
    constant BLE  : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"100";
    constant BLEU : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"101";

    signal rAs : SIGNED(DATA_BUS - 1 downto 0);
    signal rBs : SIGNED(DATA_BUS - 1 downto 0);
    signal rAu : UNSIGNED(DATA_BUS - 1 downto 0);
    signal rBu : UNSIGNED(DATA_BUS - 1 downto 0);
begin

    

    process (reg_Adata_in, reg_Bdata_in, rAs, rBs, rAu, rBu, cond_sel)
    begin

        rAs <= SIGNED(reg_Adata_in);
        rBs <= SIGNED(reg_Bdata_in);

        rAu <= UNSIGNED(reg_Adata_in);
        rBu <= UNSIGNED(reg_Bdata_in);

        if (cond_sel = BEQ) then
            if (rAs = rBs) then
                BRANCH <= '1';
            else
                BRANCH <= '0';
            end if;
        elsif (cond_sel = BNE) then
            if (rAs /= rBs) then
                BRANCH <= '1';
            else
                BRANCH <= '0';
            end if;
        elsif (cond_sel = BLT) then
            if (rAs < rBs) then
                BRANCH <= '1';
            else
                BRANCH <= '0';
            end if;
        elsif (cond_sel = BLTU) then
            if (rAu < rBu) then
                BRANCH <= '1';
            else
                BRANCH <= '0';
            end if;
        elsif (cond_sel = BLE) then
            if (rAs <= rBs) then
                BRANCH  <= '1';
            else
                BRANCH <= '0';
            end if;
        elsif (cond_sel = BLEU) then
            if (rAu <= rBu) then
                BRANCH  <= '1';
            else
                BRANCH <= '0';
            end if;
        else
            BRANCH <= '-';
        end if;

    end process;
end RTL;