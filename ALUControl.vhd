-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity ALUControl is
   port(ALUOp: in std_logic_vector(3 downto 0);
        FunctionCode: in std_logic_vector(5 downto 0);
        ALUFunction: out std_logic_vector(3 downto 0));
end ALUControl;
-- ALUFunction (Textbook 4.4 Pg. 259):
-- 0000: AND
-- 0001: OR
-- 0010: add
-- 0011: R-TYPE INSTRUCTION
-- 0110: sub
-- 0111: set on less than
-- 1100: NOR
-- 1101: XOR
-- 1110: shift left
-- 1111: shift right

architecture ALUControlBehav of ALUControl is
begin
   process(ALUOp, FunctionCode)
   begin
      -- if no ALUOp/no instruction, do not generate ALUFunction
      if (ALUOp = "XXXX") or (ALUOp = "UUUU") then
         ALUFunction <= (others => 'X');
      elsif ALUOp = "0011" then -- R-type, so look at function code
         if FunctionCode = "100000" then -- add
            ALUFunction <= "0010";
         elsif FunctionCode = "100010" then -- sub
            ALUFunction <= "0110";
         elsif FunctionCode = "100100" then -- and
            ALUFunction <= "0000";
         elsif FunctionCode = "100101" then -- or
            ALUFunction <= "0001";
         elsif FunctionCode = "100110" then -- xor
            ALUFunction <= "1101";
         elsif FunctionCode = "101010" then -- slt
            ALUFunction <= "0111";
         elsif FunctionCode = "000000" then -- sll
            ALUFunction <= "1110";
         elsif FunctionCode = "000010" then -- srl
            ALUFunction <= "1111";
         end if;
      else -- otherwise, ALUOp = ALUFunction
         ALUFunction <= ALUOp;
      end if;
   end process;
end;
