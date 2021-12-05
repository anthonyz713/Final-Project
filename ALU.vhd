-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
   port(clk: in std_logic;
        input1, input2: in std_logic_vector(31 downto 0);
        ALUFunction: in std_logic_vector(3 downto 0);
        ALUResult: out std_logic_vector(31 downto 0);
        Zero: out std_logic);
end ALU;
-- ALUFunction (Textbook 4.4 Pg. 259):
-- 0000: AND
-- 0001: OR
-- 0010: add
-- 0110: sub
-- 0111: set on less than
-- 1100: NOR
-- 1101: XOR
-- 1110: shift left
-- 1111: shift right

architecture ALUBehav of ALU is
begin
   process(clk)
   variable result: std_logic_vector(31 downto 0);
   begin
      if rising_edge(clk) then
         if ALUFunction = "0000" then
            result := input1 and input2;
         elsif ALUFunction = "0001" then
            result := input1 or input2;
         elsif ALUFunction = "0010" then
            result := std_logic_vector(signed(input1) + signed(input2));
         elsif ALUFunction = "0110" then
            result := std_logic_vector(signed(input1) - signed(input2));
         elsif ALUFunction = "0111" then
            if signed(input1) < signed(input2) then
               result := std_logic_vector(to_signed(1, result'length));
            else
               result := std_logic_vector(to_signed(0, result'length));
            end if;
         elsif ALUFunction = "1100" then
            result := input1 nor input2;
         elsif ALUFunction = "1101" then
            result := input1 xor input2;
         elsif ALUFunction = "1110" then
            result := std_logic_vector(shift_left(signed(input1), to_integer(signed(input2))));  -- shift input1 to the left input2 times
         elsif ALUFunction = "1111" then
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
