-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity ProcessorTB is 
end ProcessorTB;

architecture ProcessorRBBehavioral of ProcessorTB is
   constant T: time := 20 ns; -- time for one clock cycle
   constant totalClockCycles: integer := 22; -- total clock cycles to simulate
   signal i: integer := 1; -- clock cycle counter   

   signal clk: std_logic;
   signal reset: std_logic := '0';
   signal PC_out, ALU_result:  std_logic_vector(31 downto 0);

begin
   UUT: entity work.Processor port map(clk => clk, reset => reset, 
           PC_out => PC_out, ALU_result => ALU_result);
   -- clock
   process 
   begin
      clk <= '0';
      wait for T/2;
      clk <= '1';
      wait for T/2;
      
      if i = totalClockCycles then
         wait;
      else
         i <= i + 1;
      end if;

   end process;
end;
