-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
   port(clk, reset, RegWrite: in std_logic;
        ReadRegister1, ReadRegister2, WriteRegister: in std_logic_vector(4 downto 0);
        WriteData: in std_logic_vector(31 downto 0);        
        ReadData1, ReadData2: out std_logic_vector(31 downto 0));
end RegisterFile;

architecture RegisterFileBehav of RegisterFile is
-- 32 registers in MIPS, 32 bits per register
type register_file_type is array (0 to 31) of std_logic_vector(31 downto 0);
signal registers: register_file_type := (
   8 => std_logic_vector(to_signed(0, 32)), 
   9 => std_logic_vector(to_signed(-1, 32)),
   10 => std_logic_vector(to_signed(2, 32)),
   11 => std_logic_vector(to_signed(-3, 32)),
   12 => std_logic_vector(to_signed(4, 32)),
   13 => std_logic_vector(to_signed(5, 32)),
   others => (others => '0')); 

begin
   process(clk, reset)
      variable justWrittenData: std_logic_vector(31 downto 0); 
   begin
      if reset = '1' then
         registers <= (others => (others => '0'));
      elsif rising_edge(clk) then
         -- Write to register, if specified
         if RegWrite = '1' then
            registers(to_integer(unsigned(WriteRegister))) <= WriteData;
            justWrittenData := WriteData;
         end if;

         -- if no instruction, then no registers to read
         if (ReadRegister1 = "UUUUU" or ReadRegister1 = "XXXXX") then
            ReadData1 <= (others => 'X');
            ReadData2 <= (others => 'X');
         else -- if there are specified registers to read, read them
            -- If we are reading the value just written to the register, get it directly
            if (ReadRegister1 = WriteRegister) and RegWrite = '1' then
               ReadData1 <=  justWrittenData;
            else
               ReadData1 <= registers(to_integer(unsigned(ReadRegister1)));
            end if;

            -- Same, but for ReadData2
            if (ReadRegister2 = WriteRegister) and RegWrite = '1' then
               ReadData2 <=  justWrittenData;
            else
               ReadData2 <= registers(to_integer(unsigned(ReadRegister2)));
            end if;
         end if;
       
      end if;
   end process;
end;
