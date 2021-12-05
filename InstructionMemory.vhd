-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionMemory is
   port(clk, MemR: in std_logic;
        PC: inout std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
        IR: out std_logic_vector(31 downto 0));
end InstructionMemory;

architecture InstructionMemoryBehav of InstructionMemory is
type ROM_array is array (0 to 15) of std_logic_vector(7 downto 0);
constant ROM: ROM_array := (
   -- add $t0, $t1, $t2
   "00000001",
   "00101010",
   "01000000",
   "00100000",

   -- addi $s0, $s1, 5
   "00100010",
   "00110000",
   "00000000",
   "00000101",

   -- lw $t4, 4($t5)
   "10001101",
   "10101100",
   "00000000",
   "00000100",

   -- sll $s0, $s1, 1
   "00000000",
   "00010001",
   "10000000",
   "01000000"
   );

begin
   process(clk)
   begin
      if rising_edge(clk) and MemR = '1' then
         if to_integer(unsigned(PC)) > 12 then -- after last instruction
            IR <= (others => 'X');
         else
            IR(31 downto 24) <= ROM(to_integer(unsigned(PC)));
            IR(23 downto 16) <= ROM(to_integer(unsigned(PC)) + 1);
            IR(15 downto 8) <= ROM(to_integer(unsigned(PC)) + 2);
            IR(7 downto 0) <= ROM(to_integer(unsigned(PC)) + 3);
            PC <= std_logic_vector(unsigned(PC) + 4);
         end if;
      end if;
   end process;
end;