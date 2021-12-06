-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtend is
   port(clk: in std_logic;
        immediate16: in std_logic_vector(15 downto 0);
        immediate32: out std_logic_vector(31 downto 0));
end SignExtend;

architecture SignExtendBehav of SignExtend is
constant uArray: std_logic_vector(15 downto 0) := (others => 'U');
constant xArray: std_logic_vector(15 downto 0) := (others => 'X');

begin
   process(clk)
   begin
      -- on positive clock edge when there is an immediate value
      if rising_edge(clk) and ((not (immediate16 = uArray)) and (not (immediate16 = xArray))) then
         if to_integer(signed(immediate16)) = 0 then
            immediate32 <= (others => '0');
         elsif to_integer(signed(immediate16)) > 0 then -- positive
            immediate32(31 downto 16) <= (others => '0');
            immediate32(15 downto 0) <= immediate16;
         else -- negative
            immediate32(31 downto 16) <= (others => '1');
            immediate32(15 downto 0) <= immediate16;
         end if;
      end if;
   end process;
end;
