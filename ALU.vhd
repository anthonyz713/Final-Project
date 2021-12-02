-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
   port(clk: in std_logic;
        input1, input2: in std_logic_vector(31 downto 0);
        ALUFunction: in std_logic_vector(2 downto 0);
        ALUResult: out std_logic_vector(31 downto 0);
        Zero: out std_logic);
end ALU;
-- ALUFunction:
-- 000: add
-- 001: subtract
-- 010: shift left
-- 011: jump
-- 100: AND
-- 101: OR
-- 110: XOR
-- 111: shift right

architecture ALUBehav of ALU is
begin
   process(clk)
   variable result: std_logic_vector(31 downto 0);
   begin
      if rising_edge(clk) then
         if ALUFunction = "000" then
            result := std_logic_vector(signed(input1) + signed(input2));
         elsif ALUFunction = "001" then
            result := std_logic_vector(signed(input1) - signed(input2));
         elsif ALUFunction = "100" then
            result := input1 and input2;
         elsif ALUFunction = "101" then
            result := input1 or input2;
         elsif ALUFunction = "110" then
            result := input1 xor input2;
         elsif ALUFunction = "010" then
            result := std_logic_vector(shift_left(signed(input1), to_integer(signed(input2))));  -- shift input1 to the left input2 times
         elsif ALUFunction = "111" then
            result := std_logic_vector(shift_right(signed(input1), to_integer(signed(input2)))); -- shift input1 to the right input2 times
         end if;

         if to_integer(unsigned(result)) = 0 then
            Zero <= '1';
         else
            Zero <= '0';
         end if;

         ALUResult <= result;
      end if;
   end process;
end;
