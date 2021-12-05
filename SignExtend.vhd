-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtend is
   port(instruction16: in std_logic_vector(15 downto 0);
        instruction32: out std_logic_vector(31 downto 0));
end SignExtend;

architecture SignExtendBehav of SignExtend is
begin
   process(instruction16)
   begin
      if to_integer(signed(instruction16)) = 0 then
         instruction32 <= (others => '0');
      elsif to_integer(signed(instruction16)) > 0 then -- positive
         instruction32(31 downto 16) <= (others => '0');
         instruction32(15 downto 0) <= instruction16;
      else -- negative
         instruction32(31 downto 16) <= (others => '1');
         instruction32(15 downto 0) <= instruction16;
      end if;
   end process;
end;
