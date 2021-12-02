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
signal registers: register_file_type := (others => (others => '0')); 

begin
   process(clk, reset)
   begin
      if reset = '1' then
         registers <= (others => (others => '0'));
      elsif rising_edge(clk) then
         -- Read source registers
         ReadData1 <= registers(to_integer(unsigned(ReadRegister1)));
         ReadData2 <= registers(to_integer(unsigned(ReadRegister2)));

         -- Write to register, if specified
         if RegWrite = '1' then
            registers(to_integer(unsigned(WriteRegister))) <= WriteData;
         end if;
      end if;
   end process;
end;
