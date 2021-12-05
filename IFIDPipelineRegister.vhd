-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity IFIDPipelineRegister is
   port(CurrentInstructionIn: in std_logic_vector(31 downto 0);
        CurrentInstructionOut: out std_logic_vector(31 downto 0));
end IFIDPipelineRegister;

architecture IFIDPipelineRegisterBehav of IFIDPipelineRegister is
begin
   CurrentInstructionOut <= CurrentInstructionIn;
end;
