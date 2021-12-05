----------------------------------------------------------------------------------
-- Company: California State University
-- Engineer: Elvis Chino-Islas & Diego Cobain
-- Create Date: 12/03/2021 12:13:03 AM
-- Design Name: ALU CONTROL DESIGN
-- Module Name: ALU_CTRL - RTL
-- Project Name: Multi-Cycle CPU
-- Target Devices: Zybo Z7-20
-- Tool Versions: Vivado 2019.1 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ALU_CTRL is
    port (
        OP_MODE : in STD_LOGIC_VECTOR(1 downto 0);
        FUNC3   : in STD_LOGIC_VECTOR(14 downto 12);
        FUNC7   : in STD_LOGIC_VECTOR(31 downto 25);
        ALU_OP  : out STD_LOGIC_VECTOR(3 downto 0));
end entity ALU_CTRL;

architecture RTL of ALU_CTRL is

    constant ADD   : STD_LOGIC_VECTOR(3 downto 0) := b"0000";
    constant SLT   : STD_LOGIC_VECTOR(3 downto 0) := b"0001";
    constant SLTU  : STD_LOGIC_VECTOR(3 downto 0) := b"0010";
    constant L_AND : STD_LOGIC_VECTOR(3 downto 0) := b"0011";
    constant L_OR  : STD_LOGIC_VECTOR(3 downto 0) := b"0100";
    constant L_XOR : STD_LOGIC_VECTOR(3 downto 0) := b"0101";
    constant L_SLL : STD_LOGIC_VECTOR(3 downto 0) := b"0110";
    constant L_SRL : STD_LOGIC_VECTOR(3 downto 0) := b"0111";
    constant A_SRA : STD_LOGIC_VECTOR(3 downto 0) := b"1000";
    constant SUB   : STD_LOGIC_VECTOR(3 downto 0) := b"1001";

    constant f3_ADD    : STD_LOGIC_VECTOR(2 downto 0)   := b"000";
    constant f3_SUB    : STD_LOGIC_VECTOR(2 downto 0)   := b"000";
    constant f3_SLT    : STD_LOGIC_VECTOR(2 downto 0)   := b"001";
    constant f3_SLTU   : STD_LOGIC_VECTOR(2 downto 0)   := b"010";
    constant f3_AND    : STD_LOGIC_VECTOR(2 downto 0)   := b"011";
    constant f3_OR     : STD_LOGIC_VECTOR(2 downto 0)   := b"100";
    constant f3_XOR    : STD_LOGIC_VECTOR(2 downto 0)   := b"101";
    constant f3_SLL    : STD_LOGIC_VECTOR(2 downto 0)   := b"110";
    constant f3_SRL    : STD_LOGIC_VECTOR(2 downto 0)   := b"111";
    constant f3_SRA    : STD_LOGIC_VECTOR(2 downto 0)   := b"111";
    constant FUNC7_OP0 : STD_LOGIC_VECTOR(31 downto 25) := (others           => '0');
    constant FUNC7_OP1 : STD_LOGIC_VECTOR(31 downto 25) := ('0', '1', others => '0');

    --ALU OP MODE
    constant IMM_ARTH        : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant ARTH            : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant JMP_TARGET_CALC : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant LOAD_STORE      : STD_LOGIC_VECTOR(1 downto 0) := "11";

begin

    OPCODE_DECODE : process (OP_MODE, FUNC3, FUNC7)
    begin
        case OP_MODE is
            when IMM_ARTH =>
                if FUNC3 = f3_ADD then
                    ALU_OP <= ADD;

                elsif FUNC3 = f3_SLT then
                    ALU_OP <= SLT;

                elsif FUNC3 = f3_SLTU then
                    ALU_OP <= SLTU;

                elsif FUNC3 = f3_AND then
                    ALU_OP <= L_AND;

                elsif FUNC3 = f3_OR then
                    ALU_OP <= L_OR;

                elsif FUNC3 = f3_XOR then
                    ALU_OP <= L_XOR;

                else
                    if FUNC7 = FUNC7_OP0 then
                        if FUNC3 = f3_SLL then
                            ALU_OP <= L_SLL;
                        elsif FUNC3 = f3_SRL then
                            ALU_OP <= L_SRL;
                        else
                            ALU_OP <= (others => '-');
                        end if;
                    elsif FUNC7 = FUNC7_OP1 then
                        if FUNC3 = f3_SRA then
                            ALU_OP <= A_SRA;
                        else
                            ALU_OP <= (others => '-');
                        end if;
                    else
                        ALU_OP <= (others => '-');
                    end if;
                end if;
            when ARTH =>
                if FUNC7 = FUNC7_OP0 then
                    if FUNC3 = f3_ADD then
                        ALU_OP <= ADD;
                    elsif FUNC3 = f3_SLT then
                        ALU_OP <= SLT;
                    elsif FUNC3 = f3_SLTU then
                        ALU_OP <= SLTU;
                    elsif FUNC3 = f3_AND then
                        ALU_OP <= L_AND;
                    elsif FUNC3 = f3_OR then
                        ALU_OP <= L_OR;
                    elsif FUNC3 = f3_XOR then
                        ALU_OP <= L_XOR;
                    elsif FUNC3 = f3_SLL then
                        ALU_OP <= L_SLL;
                    elsif FUNC3 = f3_SRL then
                        ALU_OP <= L_SRL;
                    else
                        ALU_OP <= (others => '-');
                    end if;
                elsif FUNC7 = FUNC7_OP1 then
                    if FUNC3 = f3_SUB then
                        ALU_OP <= SUB;
                    elsif FUNC3 = f3_SRA then
                        ALU_OP <= A_SRA;
                    else
                        ALU_OP <= (others => '-');
                    end if;
                else
                    ALU_OP <= (others => '-');
                end if;
            when JMP_TARGET_CALC | LOAD_STORE =>
                ALU_OP <= ADD;
            when others       =>
                ALU_OP <= (others => '-');
        end case;
    end process OPCODE_DECODE;
end architecture RTL;