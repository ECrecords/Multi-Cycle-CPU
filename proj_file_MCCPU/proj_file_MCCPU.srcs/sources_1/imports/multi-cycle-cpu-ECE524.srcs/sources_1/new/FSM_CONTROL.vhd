----------------------------------------------------------------------------------
-- Company: California State University, Northridge 
-- Engineer: Elvis Chino-Islas and Diego Cobian
-- Create Date: 12/02/2021 08:55:58 AM
-- Design Name: CPU Control Path
-- Module Name: FSM_CONTROL - RTL
-- Project Name: MULTI-CYCLE-CPU
-- Target Devices: ZYBO Z7-20
-- Tool Versions:  2019.1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FSM_CONTROL is
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
        IS_BRANCH    : out STD_LOGIC
    );
end FSM_CONTROL;

architecture RTL of FSM_CONTROL is
    type T_STATE is (FETCH, FETCH2, DECODE,
        EX_OP_IMM, EX_OP, EX_JAL, EX_BRANCH, EX_LOAD_STORE, EX_SYSTEM,
        WB_OP, WB_LOAD, WB_SYSTEM,
        MEM_LOAD, MEM_STORE);

    signal curr_state, next_state : T_STATE;

    alias opcode_seg : STD_LOGIC_VECTOR(2 downto 0) is OPCODE(4 downto 2);
    --===================================================================
    --opcode
    constant OP_IMM : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"000";
    constant OP     : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"001";
    constant JAL    : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"010";
    constant BRANCH : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"100";
    constant LOAD   : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"101";
    constant STORE  : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"110";
    constant SYSTEM : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"111";
    --===================================================================
    --IMMEDIATE TYPE
    constant I_TYPE : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"100";
    constant S_TYPE : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"110";
    constant B_TYPE : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"101";
    constant U_TYPE : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"111";
    constant J_TYPE : STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0) := b"011";
    --===================================================================
    --ALU B SELECT OPTIONS
    constant X1 : STD_LOGIC := '0';
    constant PC : STD_LOGIC := '1';
    --===================================================================
    --ALU B SELECT OPTIONS
    constant X2         : STD_LOGIC_VECTOR(1 downto 0) := b"00";
    constant FOUR       : STD_LOGIC_VECTOR(1 downto 0) := b"01";
    constant EXT_IMM    : STD_LOGIC_VECTOR(1 downto 0) := b"10";
    constant SL_EXT_IMM : STD_LOGIC_VECTOR(1 downto 0) := b"11";
    --===================================================================
    --ALU OP MODE
    constant IMM_ARTH        : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant ARTH            : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant JMP_TARGET_CALC : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant LOAD_STORE      : STD_LOGIC_VECTOR(1 downto 0) := "11";
    --===================================================================
begin

    STATE_REGISTER : process (CLK, RST)
    begin
        if (RST = '1') then
            curr_state <= FETCH;
        elsif (rising_edge(CLK)) then
            curr_state <= next_state;
        end if;
    end process;

    STATE_LOGIC : process (OPCODE, opcode_seg, curr_state)
    begin
        case curr_state is
            when FETCH =>
                next_state <= FETCH2;
            when FETCH2 =>
                next_state <= DECODE;
            when DECODE =>
                if (opcode_seg = OP_IMM) then
                    next_state <= EX_OP_IMM;
                elsif (opcode_seg = OP) then
                    next_state <= EX_OP;
                elsif (opcode_seg = JAL) then
                    next_state <= EX_JAL;
                elsif (opcode_seg = BRANCH) then
                    next_state <= EX_BRANCH;
                elsif (opcode_seg = LOAD or opcode_seg = STORE) then
                    next_state <= EX_LOAD_STORE;
                else
                    next_state <= EX_SYSTEM;
                end if;
            when EX_OP_IMM | EX_OP =>
                next_state <= WB_OP;
            when EX_JAL | EX_BRANCH =>
                next_state <= FETCH;
            when EX_LOAD_STORE =>
                if (opcode_seg = STORE) then
                    next_state <= MEM_STORE;
                else
                    next_state <= MEM_LOAD;
                end if;
            when EX_SYSTEM =>
                next_state <= WB_SYSTEM;
            when MEM_LOAD =>
                next_state <= WB_LOAD;
            when MEM_STORE =>
                next_state <= FETCH;
            when WB_OP | WB_LOAD | WB_SYSTEM =>
                next_state <= FETCH;
            when others =>
                next_state <= FETCH;
        end case;
    end process;

    OUTPUT_LOGIC : process (curr_state, next_state)
    begin
        case curr_state is
            when FETCH =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '1';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '1';
                MEM_ADDR_SEL <= '0';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '0';
                RF_WCSR      <= '0';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= (others => '0');
                --============================================
                --ALU
                ALUA_SEL <= PC;
                ALUB_SEL <= FOUR;
                ALU_OP   <= JMP_TARGET_CALC;
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when FETCH2 =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '0';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '1';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '-';
                RF_WCSR      <= '0';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= (others => '-');
                --============================================
                --ALU
                ALUA_SEL <= '-';
                ALUB_SEL <= (others => '-');
                ALU_OP   <= (others => '-');
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when DECODE =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '0';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '-';
                RF_WCSR      <= '-';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= (others => '-');
                --============================================
                --ALU
                ALUA_SEL <= '-';
                ALUB_SEL <= (others => '-');
                ALU_OP   <= (others => '-');
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when EX_OP_IMM =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '-';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '0';
                RF_WCSR      <= '0';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= I_TYPE;
                --============================================
                --ALU
                ALUA_SEL <= X1;
                ALUB_SEL <= EXT_IMM;
                ALU_OP   <= IMM_ARTH;
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when EX_OP =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '-';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '0';
                RF_WCSR      <= '0';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= (others => '-');
                --============================================
                --ALU
                ALUA_SEL <= X1;
                ALUB_SEL <= X2;
                ALU_OP   <= ARTH;
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when EX_JAL => --write back cycle should take the rd  and store in IR

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '1';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '-';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '0';
                RF_WCSR      <= '0';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= J_TYPE;
                --============================================
                --ALU
                ALUA_SEL <= PC;
                ALUB_SEL <= EXT_IMM;
                ALU_OP   <= JMP_TARGET_CALC;
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when EX_BRANCH =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '-';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '0';
                RF_WCSR      <= '0';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= B_TYPE;
                --============================================
                --ALU
                ALUA_SEL <= PC;
                ALUB_SEL <= EXT_IMM;
                ALU_OP   <= JMP_TARGET_CALC;
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '1';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when EX_LOAD_STORE =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '1';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '1';
                RF_WCSR      <= '0';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= I_TYPE;
                --============================================
                --ALU
                ALUA_SEL <= X1;
                ALUB_SEL <= EXT_IMM;
                ALU_OP   <= LOAD_STORE;
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when EX_SYSTEM =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '-';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '-';
                RF_WCSR      <= '1';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= (others => '-');
                --============================================
                --ALU
                ALUA_SEL <= '-';
                ALUB_SEL <= (others => '-');
                ALU_OP   <= (others => '-');
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '1';
                --============================================

            when MEM_LOAD =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '1';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '1';
                RF_WCSR      <= '0';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= I_TYPE;
                --============================================
                --ALU
                ALUA_SEL <= '-';
                ALUB_SEL <= (others => '-');
                ALU_OP   <= (others => '-');
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when MEM_STORE =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '1';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '1';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '-';
                RF_WCSR      <= '-';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= I_TYPE;
                --============================================
                --ALU
                ALUA_SEL <= '-';
                ALUB_SEL <= (others => '-');
                ALU_OP   <= (others => '0');
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when WB_OP =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '0';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '1';
                RF_WDATA_SEL <= '0';
                RF_WCSR      <= '0';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= I_TYPE;
                --============================================
                --ALU
                ALUA_SEL <= '-';
                ALUB_SEL <= (others => '-');
                ALU_OP   <= (others => '-');
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when WB_LOAD =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '-';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '1';
                RF_WDATA_SEL <= '1';
                RF_WCSR      <= '0';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= (others => '-');
                --============================================
                --ALU
                ALUA_SEL <= '-';
                ALUB_SEL <= (others => '-');
                ALU_OP   <= (others => '-');
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when WB_SYSTEM =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '-';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '1';
                RF_WDATA_SEL <= '-';
                RF_WCSR      <= '1';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= (others => '-');
                --============================================
                --ALU
                ALUA_SEL <= '-';
                ALUB_SEL <= (others => '-');
                ALU_OP   <= (others => '-');
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

            when others =>

                --============================================
                --PROGRAM COUNTER
                PC_WE <= '0';
                --============================================
                --MEMORY
                MEM_WE       <= '0';
                MEM_RE       <= '0';
                MEM_ADDR_SEL <= '0';
                --============================================
                --INSTRUCTION REGISTER
                IR_WE <= '0';
                --============================================
                --REGISTER FILE
                RF_WE        <= '0';
                RF_WDATA_SEL <= '-';
                RF_WCSR      <= '-';
                --============================================
                --IMMEDIATE GENERATOR
                IMM_SEL <= (others => '-');
                --============================================
                --ALU
                ALUA_SEL <= '-';
                ALUB_SEL <= (others => '-');
                ALU_OP   <= (others => '0');
                --============================================
                --BRANCH LOGIC
                IS_BRANCH <= '0';
                
                --============================================
                --CSR
                CSR_WE <= '0';
                --============================================

        end case;
    end process;
end RTL;