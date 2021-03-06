-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
   port(clk, RegWrite: in std_logic;
        ReadRegister1, ReadRegister2, WriteRegister: in std_logic_vector(4 downto 0);
        WriteData: in std_logic_vector(31 downto 0);        
        ReadData1, ReadData2: out std_logic_vector(31 downto 0);
        -- Registers for test bench
        t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, s0, s1, s2, s3, s4, s5, s6, s7: out std_logic_vector(31 downto 0));
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
   23 => x"52AB37C1",
   others => (others => '0')); 

begin
   -- For test bench
   t0 <= registers(8);
   t1 <= registers(9);
   t2 <= registers(10);
   t3 <= registers(11);
   t4 <= registers(12);
   t5 <= registers(13);
   t6 <= registers(14);
   t7 <= registers(15);

   t8 <= registers(24);
   t9 <= registers(25);

   s0 <= registers(16);
   s1 <= registers(17);
   s2 <= registers(18);
   s3 <= registers(19);
   s4 <= registers(20);
   s5 <= registers(21);
   s6 <= registers(22);
   s7 <= registers(23);

   process(clk)
      variable justWrittenData: std_logic_vector(31 downto 0); 
   begin
      if rising_edge(clk) then
         -- Write to register, if specified
         if RegWrite = '1' then
            registers(to_integer(unsigned(WriteRegister))) <= WriteData;
            justWrittenData := WriteData;
         end if;

         -- if there are registers to read, read them
         if (not (ReadRegister1 = "UUUUU")) and (not (ReadRegister1 = "XXXXX")) then
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
