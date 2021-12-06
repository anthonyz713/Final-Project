-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionMemory is
   port(clk, MemR, reset: in std_logic;
        PC: inout std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
        IR: out std_logic_vector(31 downto 0));
end InstructionMemory;

architecture InstructionMemoryBehav of InstructionMemory is
type ROM_array is array (0 to 71) of std_logic_vector(7 downto 0);
constant ROM: ROM_array := (
   -- #1 add $t6, $t1, $t2  -- $t6 = -1 + 2 = 1 = 0001
   "00000001",
   "00101010",
   "01110000",
   "00100000",

   -- #2 sub $t7, $t2, $t3  -- $t7 = 2 - (-3) = 5 = 0101
   "00000001",
   "01001011",
   "01111000",
   "00100010",

   -- #3 and $t8, $t1, $t4  -- $t8 = 1111... and 0100 = 4 = 0100
   "00000001",
   "00101100",
   "11000000",
   "00100100",

   -- #4 or $t9, t0, $t5    -- $t9 = 0000... or 0101 = 5 = 0101
   "00000001",
   "00001101",
   "11001000",
   "00100101",

   -- #5 slt $t0, $t3, $t3  -- $t0 = -3 == -3 => 0 = 0000
   "00000001",
   "01101011",
   "01000000",
   "00101010",

   -- #6 slt $t1, $t3, $t4  -- $t1 = -3 < 4 => 1 = 0001
   "00000001",
   "01101100",
   "01001000",
   "00101010",

   -- #7 slt $t2, t4, $t3   -- $t2 = 4 > -3 => 0 = 0000
   "00000001",
   "10001011",
   "01010000",
   "00101010",

   -- #8 xor $t3, $t4, $t5  -- $t3 = 0100 xor 0101 = 0001
   "00000001",
   "10001101",
   "01011000",
   "00100110",

   -- #9 sll $t6, $t7, 3    -- $t6 = 5 << 3, 0101 << 3 = 0101000
   "00000000",
   "00001111",
   "01110000",
   "11000000",

   -- #10 srl $t7, $t7, 2    -- $t7 = 5 >> 2, 000101 >> 2 = 0001
   "00000000",
   "00001111",
   "01111000",
   "10000010",

   -- #11 lw $t8, 12($t8)     -- $t8 = Memory[12 + 4] = -10 = 1111...0110
   "10001111",
   "00011000",
   "00000000",
   "00001100",

   -- #12 sw $s7, 4($t0)     -- Memory[4] = x"52AB37C1"
   "10101101",
   "00010111",
   "00000000",
   "00000100",

   -- #13 addi $s0, $t4, -10 -- $s0 = 4 + (-10) = -6 = 1111...1010
   "00100001",
   "10010000",
   "11111111",
   "11110110",

   -- #14 andi $s1, $t5, 3   -- $s1 = 0101 and 0011 = 0001
   "00110001",
   "10110001",
   "00000000",
   "00000011",

   -- #15 ori $s2, $t5, 3    -- $s2 = 0101 or 0011 = 0111
   "00110101",
   "10110010",
   "00000000",
   "00000011",

   -- #16 slti $s3, $t5, 5   -- 5 = 5 => 0 = 0000
   "00101001",
   "10110011",
   "00000000",
   "00000101",

   -- #17 slti $s5, $t5, 2   -- 5 > 2 => 0 = 0000
   "00101001",
   "10110101",
   "00000000",
   "00000010",

   -- #18 slti $s4, $t5, 10  -- 5 < 10 => 1 = 0001
   "00101001",
   "10110100",
   "00000000",
   "00001010");

begin
   process(clk)
   begin
      if reset = '1' then
         IR <= (others => '0');
         PC <= (others => '0');
      elsif rising_edge(clk) and MemR = '1' then
         if to_integer(unsigned(PC)) > 68 then -- after last instruction
            IR <= (others => '0');
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