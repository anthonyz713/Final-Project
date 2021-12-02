-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionMemory is
   port(Clk, MemR: in std_logic;
        PC: inout std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
        Dout: out std_logic_vector(7 downto 0);
        IR: out std_logic_vector(31 downto 0));
end InstructionMemory;

architecture InstructionMemoryBehav of InstructionMemory is
signal Addr: std_logic_vector(4 downto 0) := PC(4 downto 0);
signal byteNum: Integer := 1; -- 1 = MSB, 4 = LSB

type ROM_array is array (0 to 19) of std_logic_vector(7 downto 0);
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
   "01000000",

   -- j 0x39796
   "00001000",
   "00000011",
   "10010111",
   "10010110"
   );

begin
   process(Clk)
   begin
      if rising_edge(Clk) and MemR = '1' then
         -- Dout = memory[Addr]
         Dout <= ROM(to_integer(unsigned(Addr)));

         -- IR[byteNum] = memory[Addr]
         -- update byteNum for next byte
         if byteNum = 1 then
            IR(31 downto 24) <= ROM(to_integer(unsigned(Addr)));
            byteNum <= 2;
         elsif byteNum = 2 then
            IR(23 downto 16) <= ROM(to_integer(unsigned(Addr)));
            byteNum <= 3;
         elsif byteNum = 3 then
            IR(15 downto 8) <= ROM(to_integer(unsigned(Addr)));
            byteNum <= 4;
         elsif byteNum = 4 then
            IR(7 downto 0) <= ROM(to_integer(unsigned(Addr)));
            byteNum <= 1;
         end if;
         
         -- Addr = Addr + 1
         Addr <= std_logic_vector(unsigned(Addr) + 1);
         PC(4 downto 0) <= std_logic_vector(unsigned(Addr) + 1);
      end if;
   end process;
end;