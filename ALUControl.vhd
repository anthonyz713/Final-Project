-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity ALUControl is
   port(clk: in std_logic;
        ALUOp: in std_logic_vector(2 downto 0);
        FunctionCode: in std_logic_vector(5 downto 0);
        ALUFunction: out std_logic_vector(3 downto 0));
end ALUControl;
-- ALUFunction (mostly same as ALUOp):
-- 000: add
-- 001: subtract
-- 010: shift left
-- 011: jump
-- 100: AND
-- 101: OR
-- 110: XOR
-- 111: shift right

architecture ALUControlBehav of ALUControl is
begin
   process(clk)
   begin
      if rising_edge(clk) then
         if ALUOp = "010" then -- R-type, so look at function code
            if FunctionCode = "100000" then -- add
               ALUFunction <= "000";
            elsif FunctionCode = "100010" then -- sub
               ALUFunction <= "001";
            elsif FunctionCode = "100100" then -- and
               ALUFunction <= "100";
            elsif FunctionCode = "100101" then -- or
               ALUFunction <= "101";
            elsif FunctionCode = "100110" then -- xor
               ALUFunction <= "110";
            elsif FunctionCode = "101010" then -- slt
               ALUFunction <= "001";
            elsif FunctionCode = "000000" then -- sll
               ALUFunction <= "010";
            elsif FunctionCode = "000010" then -- srl
               ALUFunction <= "111";
            end if;
         else -- otherwise, ALUOp = ALUFunction
            ALUFunction <= ALUOp;
         end if;
      end if;
   end process;
end;
