-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity MEMWBPipelineRegister is
   port(clk: std_logic;
        dataFromMemory, ALUResult: in std_logic_vector(31 downto 0);
        RegisterDestination: in std_logic_vector(4 downto 0);
        MemtoReg, RegWrite: in std_logic;

        dataFromMemoryOut, ALUResultOut: out std_logic_vector(31 downto 0);
        RegisterDestinationOut: out std_logic_vector(4 downto 0);
        MemtoRegOut, RegWriteOut: out std_logic);
end MEMWBPipelineRegister;

architecture MEMWBPipelineRegisterBehav of MEMWBPipelineRegister is
begin
   dataFromMemoryOut <= dataFromMemory;
   process(clk)
   begin
      if rising_edge(clk) then
         ALUResultOut <= ALUResult;
         RegisterDestinationOut <= RegisterDestination;
         MemtoRegOut <= MemtoReg;
         RegWriteOut <= RegWrite;
      end if;
   end process;
end;
