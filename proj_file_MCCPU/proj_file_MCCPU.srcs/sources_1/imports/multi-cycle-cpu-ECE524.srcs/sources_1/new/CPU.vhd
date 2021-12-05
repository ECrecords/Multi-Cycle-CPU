----------------------------------------------------------------------------------
-- Company: California State University
-- Engineer: Elvis Chino-Islas & Diego Cobain
-- Create Date: 11/28/2021 10:47:03 AM
-- Design Name: Top Module CPU
-- Module Name: CPU - Behavioral
-- Project Name: Multi-Cycle CPU
-- Target Devices: Zybo Z7-20
-- Tool Versions: Vivado 2019.1
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity CPU is
    generic (DATA_BUS : INTEGER := 32);
    port (
        GCLK     : in STD_LOGIC;
        MRST     : in STD_LOGIC;
        BYTE_SEL : in STD_LOGIC_VECTOR(3 downto 0);
        CSR0_SW  : in STD_LOGIC_VECTOR(3 downto 0);
        CSR1_LED : out STD_LOGIC_VECTOR(7 downto 0));
end CPU;

architecture Behavioral of CPU is

    component PRGM_CNTR is
        generic (DATA_BUS : INTEGER := 32);
        port (
            CLK    : in STD_LOGIC;
            RST    : in STD_LOGIC;
            LD     : in STD_LOGIC;
            PC_IN  : in STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
            PC_OUT : out STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0));
    end component PRGM_CNTR;

    component SIG_EXTEN is
        port (
            INSTR     : in STD_LOGIC_VECTOR (31 downto 0);
            IMM_SEL   : in STD_LOGIC_VECTOR (2 downto 0);
            EXTEN_IMM : out STD_LOGIC_VECTOR (31 downto 0));
    end component SIG_EXTEN;

    component ALU is
        generic (
            DATA_BUS  : INTEGER := 32;
            SEL_WIDTH : INTEGER := 4);

        port (
            SEL : in STD_LOGIC_VECTOR(SEL_WIDTH - 1 downto 0);
            A   : in STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
            B   : in STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
            C   : out STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0));
    end component ALU;

    component ALU_CTRL is
        port (
            OP_MODE : in STD_LOGIC_VECTOR(1 downto 0);
            FUNC3   : in STD_LOGIC_VECTOR(14 downto 12);
            FUNC7   : in STD_LOGIC_VECTOR(31 downto 25);
            ALU_OP  : out STD_LOGIC_VECTOR(3 downto 0));
    end component ALU_CTRL;

    component REG_FILE is
        generic (DATA_BUS : INTEGER := 32);
        port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            WE  : in STD_LOGIC;
            RS1 : in STD_LOGIC_VECTOR (4 downto 0);
            RS2 : in STD_LOGIC_VECTOR (4 downto 0);
            WA  : in STD_LOGIC_VECTOR (4 downto 0);
            WD  : in STD_LOGIC_VECTOR (DATA_BUS - 1 downto 0);
            D1  : out STD_LOGIC_VECTOR (DATA_BUS - 1 downto 0);
            D2  : out STD_LOGIC_VECTOR (DATA_BUS - 1 downto 0));
    end component REG_FILE;

    component BRANCH_LOGIC is
        generic (
            SEL_WIDTH : INTEGER := 3;
            DATA_BUS  : INTEGER := 32);
        port (
            reg_Adata_in : in STD_LOGIC_VECTOR (DATA_BUS - 1 downto 0);
            reg_Bdata_in : in STD_LOGIC_VECTOR (DATA_BUS - 1 downto 0);
            cond_sel     : in STD_LOGIC_VECTOR (SEL_WIDTH - 1 downto 0);
            BRANCH       : out STD_LOGIC);
    end component BRANCH_LOGIC;

    component MEMORY
        port (
            clka  : in STD_LOGIC;
            ena   : in STD_LOGIC;
            wea   : in STD_LOGIC_VECTOR(0 downto 0);
            addra : in STD_LOGIC_VECTOR(15 downto 0);
            dina  : in STD_LOGIC_VECTOR(31 downto 0);
            douta : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component FSM_CONTROL is
        generic (
            SEL_WIDTH : INTEGER := 3);
        port (
            CLK          : in STD_LOGIC;
            RST          : in STD_LOGIC;
            OPCODE       : in STD_LOGIC_VECTOR (6 downto 0);
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
    end component;

    --Control Signals====================================
    ----MUX
    signal mem_addr_sel : STD_LOGIC;
    signal rf_wdata_sel : STD_LOGIC;
    signal rf_wcsr      : STD_LOGIC;
    signal aluA_sel     : STD_LOGIC;
    signal aluB_sel     : STD_LOGIC_VECTOR(1 downto 0);
    signal is_branch    : STD_LOGIC;
    ----PC
    signal pc_we : STD_LOGIC;
    ----Memory
    signal mem_we   : STD_LOGIC;
    signal mem_re   : STD_LOGIC;
    signal mem_addr : STD_LOGIC_VECTOR(15 downto 0);
    ----Instruction Register
    signal ir_we : STD_LOGIC;
    ----Register File
    signal rf_we : STD_LOGIC;
    ----Immediate Generator
    signal imm_sel : STD_LOGIC_VECTOR(2 downto 0);
    ----CSR
    signal csr_we : STD_LOGIC;
    ----ALU
    signal alu_op : STD_LOGIC_VECTOR(1 downto 0);
    --====================================================

    --Registers===========================================
    --Instruction Register
    signal ir : STD_LOGIC_VECTOR(31 downto 0);
    ----ALU Result
    signal alu_rslt : STD_LOGIC_VECTOR(31 downto 0);
    signal alu_sel  : STD_LOGIC_VECTOR(3 downto 0);
    ----CSR
    signal CSR0 : STD_LOGIC_VECTOR(31 downto 0);
    signal CSR1 : STD_LOGIC_VECTOR(31 downto 0);
    --====================================================
    --WIRES=======================================================
    --Program Counter
    signal pc_out    : STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
    signal pc_din    : STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
    signal pc_ld     : STD_LOGIC;
    signal pc_branch : STD_LOGIC;
    ----Memory
    signal mem_out : STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
    ----Register File
    signal rf_din : STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
    signal x1     : STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
    signal x2     : STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
    ----Immediate Gen
    signal ext_imm : STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
    ----ALU
    signal alu_a   : STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
    signal alu_b   : STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
    signal alu_out : STD_LOGIC_VECTOR(DATA_BUS - 1 downto 0);
    ------ALU B SELECT OPTIONS
    constant RF_X2      : STD_LOGIC_VECTOR(1 downto 0) := b"00";
    constant FOUR       : STD_LOGIC_VECTOR(1 downto 0) := b"01";
    constant IG_EXT_IMM : STD_LOGIC_VECTOR(1 downto 0) := b"10";
    constant SL_EXT_IMM : STD_LOGIC_VECTOR(1 downto 0) := b"11";
    ----Branch Logic
    signal branch_rslt : STD_LOGIC;
    signal br_cond     : STD_LOGIC_VECTOR(2 downto 0);
    --============================================================

    ----BYTE SEL OPTIONS
    constant U_HALFWORD_UPPER : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant U_HALFWORD_LOWER : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant L_HALFWORD_UPPER : STD_LOGIC_VECTOR(3 downto 0) := "0100";
    constant L_HALFWORD_LOWER : STD_LOGIC_VECTOR(3 downto 0) := "1000";

    signal tmp_mem_re : STD_LOGIC_VECTOR(0 downto 0);
    signal mem_en     : STD_LOGIC;

begin
    BYTE_OUT : process (BYTE_SEL, CSR1)
    begin
        case BYTE_SEL is
            when U_HALFWORD_UPPER =>
                CSR1_LED <= CSR1(31 downto 24);
            when U_HALFWORD_LOWER =>
                CSR1_LED <= CSR1(23 downto 16);
            when L_HALFWORD_UPPER =>
                CSR1_LED <= CSR1(15 downto 8);
            when L_HALFWORD_LOWER =>
                CSR1_LED <= CSR1(7 downto 0);
            when others         =>
                CSR1_LED <= (others => '1');
        end case;
    end process BYTE_OUT;

    BYTE_IN : process (GCLK, MRST)
    begin
        if MRST = '1' then
            CSR0 <= (others => '0');
        elsif rising_edge(GCLK) then
            case BYTE_SEL is
                when U_HALFWORD_UPPER =>
                    CSR0(15 downto 12) <= CSR0_SW;
                when U_HALFWORD_LOWER =>
                    CSR0(11 downto 8) <= CSR0_SW;
                when L_HALFWORD_UPPER =>
                    CSR0(7 downto 4) <= CSR0_SW;
                when L_HALFWORD_LOWER =>
                    CSR0(3 downto 0) <= CSR0_SW;
                when others                  =>
                    CSR0(31 downto 0) <= (others => '0');
            end case;
        end if;
    end process BYTE_IN;

    csr_out : process (GCLK, MRST)
    begin
        if MRST = '1' then
            CSR1 <= (others => '0');
        elsif rising_edge(GCLK) then
            if csr_we = '1' then
                CSR1 <= x1;
            end if;
        end if;
    end process csr_out;

    pc_ld <= pc_we or pc_branch;

    program_cntr : PRGM_CNTR port map(
        CLK    => GCLK,
        RST    => MRST,
        LD     => pc_ld,
        PC_IN  => alu_out,
        PC_OUT => pc_out
    );

    tmp_mem_re <= (others => mem_we);
    mem_en     <= mem_we or mem_re;

    ADDR_MEM : process (mem_addr_sel, alu_rslt, pc_out)
    begin
        if mem_addr_sel = '1' then
            mem_addr <= alu_rslt(15 downto 0);
        else
            mem_addr <= pc_out(15 downto 0);
        end if;
    end process ADDR_MEM;

    mem : MEMORY port map(
        clka  => GCLK,
        ena   => '1',
        wea   => tmp_mem_re,
        addra => mem_addr,
        dina  => x2,
        douta => mem_out
    );

    instruct_reg : process (GCLK, MRST)
    begin
        if MRST = '1' then
            ir <= (others => '0');
        elsif rising_edge(GCLK) then
            if ir_we = '1' then
                ir <= mem_out;
            end if;
        end if;
    end process instruct_reg;

    rf : REG_FILE port map(
        CLK => GCLK,
        RST => MRST,
        WE  => rf_we,
        RS1 => ir(19 downto 15),
        RS2 => ir(24 downto 20),
        WA  => ir(11 downto 7),
        WD  => rf_din,
        D1  => x1,
        D2  => x2
    );

    RF_WD : process (rf_wdata_sel, rf_wcsr, mem_out, alu_rslt, CSR0)
        variable inter : STD_LOGIC_VECTOR(31 downto 0);
    begin
        if rf_wcsr = '1' then
            rf_din <= CSR0;
        else
            if rf_wdata_sel = '1' then
                rf_din <= mem_out;
            else
                rf_din <= alu_rslt;
            end if;
        end if;
    end process RF_WD;

    imm_gen : SIG_EXTEN port map(
        INSTR     => ir,
        IMM_SEL   => imm_sel,
        EXTEN_IMM => ext_imm
    );

    X1X2_SEL : process (aluA_sel, aluB_sel, x1, x2, pc_out, ext_imm)
    begin
        if aluA_sel = '1' then
            alu_a <= pc_out;
        else
            alu_a <= x1;
        end if;

        if aluB_sel = RF_X2 then
            alu_b <= X2;
        elsif aluB_sel = FOUR then
            alu_b <= STD_LOGIC_VECTOR(TO_SIGNED(4, DATA_BUS));
        else
            alu_b <= EXT_IMM;
        end if;
    end process X1X2_SEL;

    alu_comp : ALU port map(
        SEL => alu_sel,
        A   => alu_a,
        B   => alu_b,
        C   => alu_out
    );

    ctrl_alu : ALU_CTRL port map(
        OP_MODE => alu_op,
        FUNC3   => ir(14 downto 12),
        FUNC7   => ir(31 downto 25),
        ALU_OP  => alu_sel
    );

    alu_reg : process (GCLK, MRST)
    begin
        if MRST = '1' then
            alu_rslt <= (others => '0');
        elsif rising_edge(GCLK) then
            alu_rslt <= alu_out;
        end if;
    end process alu_reg;

    br_cond <= ir(14 downto 12);

    brl : BRANCH_LOGIC port map(
        reg_Adata_in => x1,
        reg_Bdata_in => x2,
        cond_sel     => br_cond,
        BRANCH       => branch_rslt
    );

    PC_SEL : process (is_branch, branch_rslt)
    begin
        if is_branch = '1' then
            pc_branch <= branch_rslt;
        else
            pc_branch <= '0';
        end if;
    end process PC_SEL;

    ctrl_unt : FSM_CONTROL port map(
        CLK          => GCLK,
        RST          => MRST,
        OPCODE       => ir(6 downto 0),
        PC_WE        => pc_we,
        MEM_ADDR_SEL => mem_addr_sel,
        MEM_WE       => mem_we,
        MEM_RE       => mem_re,
        IR_WE        => ir_we,
        CSR_WE       => csr_we,
        RF_WCSR      => rf_wcsr,
        RF_WDATA_SEL => rf_wdata_sel,
        RF_WE        => rf_we,
        IMM_SEL      => imm_sel,
        ALUA_SEL     => aluA_sel,
        ALUB_SEL     => aluB_sel,
        ALU_OP       => alu_op,
        IS_BRANCH    => is_branch
    );

end Behavioral;