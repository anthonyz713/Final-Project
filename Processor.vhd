-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity Processor is
   port(clk, reset: in std_logic);
end Processor;

architecture ProcessorBehav of Processor is
-- Instruction Memory
signal PC, IR: std_logic_vector(31 downto 0);
signal MemR: std_logic := '1'; -- Instruction Memory enable

-- IF/ID Pipeline Register
signal IFIDInstruction: std_logic_vector(31 downto 0);

-- ControlUnit
signal RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite: std_logic;
signal ALUOp: std_logic_vector(3 downto 0);

-- RegisterFile
signal ReadData1, ReadData2: std_logic_vector(31 downto 0);

-- SignExtend
signal immediate32: std_logic_vector(31 downto 0);

-- ID/EX Pipeline Register
signal IDEXimmediate32, IDEXReadData1, IDEXReadData2: std_logic_vector(31 downto 0);
signal IDEXinstruction20to16, IDEXinstruction15to11: std_logic_vector(4 downto 0); 
signal IDEXRegDst, IDEXJump, IDEXBranch, IDEXMemRead, IDEXMemtoReg, IDEXMemWrite, IDEXALUSrc, IDEXRegWrite: std_logic;
signal IDEXALUOp: std_logic_vector(3 downto 0);

-- ALUControl
signal ALUFunction: std_logic_vector(3 downto 0);

-- input2 MUX
signal input2: std_logic_vector(31 downto 0);

-- ALU
signal ALUResult: std_logic_vector(31 downto 0);
signal Zero: std_logic;

-- RegDst MUX
signal MUXRegDst: std_logic_vector(4 downto 0);

-- EX/MEM Pipeline Register
signal EXMEMALUResult, EXMEMReadData2: std_logic_vector(31 downto 0);
signal EXMEMMUXRegDst: std_logic_vector(4 downto 0);
signal EXMEMZero: std_logic;
signal EXMEMJump, EXMEMBranch,EXMEMMemRead, EXMEMMemtoReg, EXMEMMemWrite, EXMEMRegWrite: std_logic;

-- DataMemory
signal ReadData: std_logic_vector(31 downto 0);

-- MEM/WB Pipeline Register
signal MEMWBReadData, MEMWBALUResult: std_logic_vector(31 downto 0);
signal MEMWBMUXRegDst: std_logic_vector(4 downto 0);
signal MEMWBMemtoReg, MEMWBRegWrite: std_logic;

-- MemtoReg MUX
signal MUXMemtoReg: std_logic_vector(31 downto 0);

begin
   -- IF
   InstructionMemory: entity work.InstructionMemory port map(clk => clk, MemR => MemR,
      PC => PC, IR => IR);

   IFIDPipelineRegister: entity work.IFIDPipelineRegister port map(
      CurrentInstructionIn => IR, CurrentInstructionOut => IFIDInstruction);

   -- ID
   ControlUnit: entity work.ControlUnit port map(clk => clk, reset => reset,
      opcode => IFIDInstruction(31 downto 26), RegDst => RegDst, Jump => Jump, 
      Branch => Branch, MemRead => MemRead, MemtoReg => MemtoReg, 
      MemWrite => MemWrite, ALUSrc => ALUSrc, RegWrite => RegWrite, ALUOp => ALUOp);

   RegisterFile: entity work.RegisterFile port map(clk => clk, reset => reset,
      RegWrite => MEMWBRegWrite, ReadRegister1 => IFIDInstruction(25 downto 21), 
      ReadRegister2 => IFIDInstruction(20 downto 16), WriteRegister => MEMWBMUXRegDst, 
      WriteData => MUXMemtoReg, ReadData1 => ReadData1, ReadData2 => ReadData2);

   SignExtend: entity work.SignExtend port map(clk => clk,
      immediate16 => IFIDInstruction(15 downto 0), immediate32 => immediate32);

   IDEXPipelineRegister: entity work.IDEXPipelineRegister port map(clk => clk, immediate32 => immediate32,
      ReadData1 => ReadData1, ReadData2 => ReadData2, instruction20to16 => IFIDInstruction(20 downto 16),
      instruction15to11 => IFIDInstruction(15 downto 11), RegDst => RegDst, Jump => Jump,
      Branch => Branch, MemRead => MemRead, MemtoReg => MemtoReg, MemWrite => MemWrite,
      ALUSrc => ALUSrc, RegWrite => RegWrite, ALUOP => ALUOp, 
      
      immediate32Out => IDEXimmediate32, ReadData1Out => IDEXReadData1, ReadData2Out => IDEXReadData2, 
      instruction20to16Out => IDEXinstruction20to16, instruction15to11Out => IDEXinstruction15to11, 
      RegDstOut => IDEXRegDst, JumpOut => IDEXJump, BranchOut => IDEXBranch, MemReadOut => IDEXMemRead, 
      MemtoRegOut => IDEXMemtoReg, MemWriteOut => IDEXMemWrite, ALUSrcOut => IDEXALUSrc, 
      RegWriteOut => IDEXRegWrite, ALUOPOut => IDEXALUOp);

   -- EX
   ALUControl: entity work.ALUControl port map(ALUOp => IDEXALUOp,
      FunctionCode => IDEXimmediate32(5 downto 0), ALUFunction => ALUFunction);

   -- input2 MUX
   input2 <= IDEXReadData2 when IDEXALUSrc = '0' else
             IDEXimmediate32 when IDEXALUSrc = '1' else
             (others => 'X');
   
   ALU: entity work.ALU port map(clk => clk, input1 => IDEXReadData1, input2 => input2,
      shamt => IDEXimmediate32(10 downto 6), ALUFunction => ALUFunction, ALUResult => ALUResult, Zero => Zero);

   -- RegDst MUX
   MUXRegDst <= IDEXinstruction20to16 when IDEXRegDst = '0' else
          IDEXinstruction15to11 when IDEXRegDst = '1' else
          (others => 'X');

   EXMEMPipelineRegister: entity work.EXMEMPipelineRegister port map(clk => clk, ALUResult => ALUResult,
      ReadData2 => IDEXReadData2, MUXRegDst => MUXRegDst, Zero => Zero, Jump => IDEXJump, Branch => IDEXBranch, 
      MemRead => IDEXMemRead, MemtoReg => IDEXMemtoReg, MemWrite => IDEXMemWrite, RegWrite => IDEXRegWrite,
      
      ALUResultOut => EXMEMALUResult, ReadData2Out => EXMEMReadData2, MUXRegDstOut => EXMEMMUXRegDst, 
      ZeroOut => EXMEMZero, JumpOut => EXMEMJump, BranchOut => EXMEMBranch, MemReadOut => EXMEMMemRead, 
      MemtoRegOut => EXMEMMemtoReg, MemWriteOut => EXMEMMemWrite, RegWriteOut => EXMEMRegWrite);

   -- MEM
   DataMemory: entity work.DataMemory port map(clk => clk, MemRead => EXMEMMemRead,
      MemWrite => EXMEMMemWrite, Address => EXMEMALUResult, WriteData => EXMEMReadData2,
      ReadData => ReadData);
   
   MEMWBPipelineRegister: entity work.MEMWBPipelineRegister port map(clk => clk, dataFromMemory => ReadData,
      ALUResult => EXMEMALUResult, RegisterDestination => EXMEMMUXRegDst,
      MemtoReg => EXMEMMemtoReg, RegWrite => EXMEMRegWrite,

      dataFromMemoryOut => MEMWBReadData, ALUResultOut => MEMWBALUResult, 
      RegisterDestinationOut => MEMWBMUXRegDst, MemtoRegOut => MEMWBMemtoReg, RegWriteOut => MEMWBRegWrite);

   -- WB
   -- MemtoReg MUX
   MUXMemtoReg <= MEMWBReadData when MEMWBMemtoReg = '1' else
                  MEMWBALUResult when MEMWBMemtoReg = '0' else
                  (others => 'X');
end;
