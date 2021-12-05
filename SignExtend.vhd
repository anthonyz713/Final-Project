-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtend is
   port(immediate16: in std_logic_vector(15 downto 0);
        immediate32: out std_logic_vector(31 downto 0));
end SignExtend;

architecture SignExtendBehav of SignExtend is
begin
   process(immediate16)
   begin
      if to_integer(signed(immediate16)) = 0 then
         immediate32 <= (others => '0');
      elsif to_integer(signed(immediate16)) > 0 then -- positive
         immediate32(31 downto 16) <= (others => '0');
         immediate32(15 downto 0) <= immediate16;
      else -- negative
         immediate32(31 downto 16) <= (others => '1');
         immediate32(15 downto 0) <= immediate16;
      end if;
   end process;
end;
