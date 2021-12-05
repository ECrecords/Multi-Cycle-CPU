----------------------------------------------------------------------------------
-- Company: California State University
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

entity ALU is
    Generic (   DATA_BUS    : INTEGER := 32;
                SEL_WIDTH   : INTEGER := 4  );

    Port (      SEL : in STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0);
                A   : in STD_LOGIC_VECTOR(DATA_BUS-1 downto 0);
                B   : in STD_LOGIC_VECTOR(DATA_BUS-1 downto 0);
                C   : out STD_LOGIC_VECTOR(DATA_BUS-1 downto 0)    );
end entity ALU;

architecture RTL of ALU is
    constant ADD        : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0) := b"0000";
    constant SLT        : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0) := b"0001";
    constant SLTU       : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0) := b"0010";
    constant L_AND      : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0) := b"0011";
    constant L_OR       : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0) := b"0100";
    constant L_XOR      : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0) := b"0101";
    constant L_SLL      : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0) := b"0110";
    constant L_SRL      : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0) := b"0111";
    constant A_SRA      : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0) := b"1000";
    constant SUB        : STD_LOGIC_VECTOR(SEL_WIDTH-1 downto 0) := b"1001";

    signal as : SIGNED(DATA_BUS-1 downto 0);
    signal bs : SIGNED(DATA_BUS-1 downto 0);
    signal au : UNSIGNED(DATA_BUS-1 downto 0);
    signal bu : UNSIGNED(DATA_BUS-1 downto 0);
begin
        
    ALU_COMB: process(SEL, A, B, as, bs, au, bu)
    begin

        as <= SIGNED(A);
        bs <= SIGNED(B);

        au <= UNSIGNED(A);
        bu <= UNSIGNED(B);

        case SEL is
            when ADD =>
                C <= STD_LOGIC_VECTOR(as + bs);
            when SUB =>
                C <= STD_LOGIC_VECTOR(as - bs);
            when SLT =>
                if (as < bs) then
                    C <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, DATA_BUS));
                else
                    C <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, DATA_BUS));
                end if;              
            when SLTU =>
                if (au < bu) then
                    C <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, DATA_BUS));
                else
                    C <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, DATA_BUS));
                end if;
            when L_AND =>
                C <= A and B;
            when L_OR =>
                C <= A or B;
            when L_XOR =>
                C <= A xor B;
            when L_SLL =>
                C <= STD_LOGIC_VECTOR(au sll TO_INTEGER(bu));
            when L_SRL =>
                C <= STD_LOGIC_VECTOR(au srl TO_INTEGER(bu));
            when A_SRA =>
                C <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) sra TO_INTEGER(bu));
            when others =>
                C <= (others => '-');
        end case;
    end process ALU_COMB;

end architecture RTL;