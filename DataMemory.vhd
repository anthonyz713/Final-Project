-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory is
   port(clk, MemRead, MemWrite: in std_logic;
        Address, WriteData: in std_logic_vector(31 downto 0);
        ReadData: out std_logic_vector(31 downto 0));
end DataMemory;

architecture DataMemoryBehav of DataMemory is
-- memory is byte-addressed, 4 bytes for 1 word, limit memory to 25 words
type data_memory_type is array (0 to 99) of std_logic_vector(7 downto 0);
signal data_memory: data_memory_type := (others => (others => '0'));

begin
   process(clk)
      variable baseAddress: Integer;
   begin
      if rising_edge(clk) then
         if MemRead = '1' then
            -- read from memory
            baseAddress := 4 * to_integer(unsigned(Address));
            ReadData(31 downto 24) <= data_memory(baseAddress);
            ReadData(23 downto 16) <= data_memory(baseAddress + 1);
            ReadData(15 downto 8) <=  data_memory(baseAddress + 2);
            ReadData(7 downto 0) <=  data_memory(baseAddress + 3);
         elsif MemWrite = '1' then
            -- write to memory
            baseAddress := 4 * to_integer(unsigned(Address));
            data_memory(baseAddress) <= WriteData(31 downto 24);
            data_memory(baseAddress + 1) <= WriteData(23 downto 16);
            data_memory(baseAddress + 2) <= WriteData(15 downto 8);
            data_memory(baseAddress + 3) <= WriteData(7 downto 0);
         end if;
      end if;
   end process;
end;
