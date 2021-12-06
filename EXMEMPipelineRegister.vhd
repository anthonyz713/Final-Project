-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity EXMEMPipelineRegister is
   port(clk: std_logic;
        ALUResult, ReadData2: in std_logic_vector(31 downto 0);
        MUXRegDst: in std_logic_vector(4 downto 0);
        Zero: in std_logic;
        Jump, Branch, MemRead, MemtoReg, MemWrite, RegWrite: in std_logic;

        ALUResultOut, ReadData2Out: out std_logic_vector(31 downto 0);
        MUXRegDstOut: out std_logic_vector(4 downto 0);
        ZeroOut: out std_logic;
        JumpOut, BranchOut, MemReadOut, MemtoRegOut, MemWriteOut, RegWriteOut: out std_logic);
end EXMEMPipelineRegister;

architecture EXMEMPipelineRegisterBehav of EXMEMPipelineRegister is
begin
   ALUResultOut <= ALUResult;
   ZeroOut <= Zero;
   process(clk)
   begin
      if rising_edge(clk) then
         ReadData2Out <= ReadData2;
         MUXRegDstOut <= MUXRegDst;
         JumpOut <= Jump;
         BranchOut <= Branch;
         MemReadOut <= MemRead;
         MemtoRegOut <= MemtoReg;
         MemWriteOut <= MemWrite;
         RegWriteOut <= RegWrite;
      end if;
   end process;
end;
