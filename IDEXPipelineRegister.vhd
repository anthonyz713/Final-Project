-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity IDEXPipelineRegister is
   port(clk: std_logic;
        immediate32: in std_logic_vector(31 downto 0);
        ReadData1, ReadData2: in std_logic_vector(31 downto 0);
        instruction20to16, instruction15to11: in std_logic_vector(4 downto 0);
        RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite: in std_logic;
        ALUOp: in std_logic_vector(3 downto 0);

        immediate32Out: out std_logic_vector(31 downto 0);
        ReadData1Out, ReadData2Out: out std_logic_vector(31 downto 0);
        instruction20to16Out, instruction15to11Out: out std_logic_vector(4 downto 0);
        RegDstOut, JumpOut, BranchOut, MemReadOut, MemtoRegOut, MemWriteOut, ALUSrcOut, RegWriteOut: out std_logic;
        ALUOpOut: out std_logic_vector(3 downto 0));
end IDEXPipelineRegister;

architecture IDEXPipelineRegisterBehav of IDEXPipelineRegister is
begin
   immediate32Out <= immediate32;
   ReadData1Out <= ReadData1;
   ReadData2Out <= ReadData2;
   RegDstOut <= RegDst;
   JumpOut <= Jump;
   BranchOut <= Branch;
   MemReadOut <= MemRead;
   MemtoRegOut <= MemtoReg;
   MemWriteOut <= MemWrite;
   ALUSrcOut <= ALUSrc;
   RegWriteOut <= RegWrite;
   ALUOpOut <= ALUOp;
   process(clk)
   begin
      if rising_edge(clk) then
         instruction20to16Out <= instruction20to16;
         instruction15to11Out <= instruction15to11;
      end if;
   end process;
end;
