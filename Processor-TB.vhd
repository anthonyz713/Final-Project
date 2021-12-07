-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProcessorTB is 
end ProcessorTB;

architecture ProcessorRBBehavioral of ProcessorTB is
   constant T: time := 20 ns; -- time for one clock cycle
   constant totalClockCycles: integer := 23; -- total clock cycles to simulate
   signal i: integer := 1; -- clock cycle counter   

   signal clk: std_logic;
   signal reset: std_logic := '0';
   signal PC_out, ALU_result:  std_logic_vector(31 downto 0);

   -- record type declaration
   type lookup_table_entry is record
      PC_val, ALU_val: Integer; -- Integer, not std_logic_vector, so easier to read
   end record;

   -- declare look up table type
   type lookup_table_type is array (natural range <>) of lookup_table_entry;

   -- declare lookup table
   constant lookup_table: lookup_table_type := (
      (4, 0),   -- Test Case #1, PC = 4, no ALU result
      (8, 0),   -- Test Case #2, PC = 8, no ALU result
      (12, 1),  -- Test Case #3, PC = 12, ALU = 1
      (16, 5),  -- Test Case #4, PC = 16, ALU = 5
      (20, 4),  -- Test Case #5, PC = 20, ALU = 4

      (24, 5),  -- Test Case #6, PC = 24, ALU = 5
      (28, 0),  -- Test Case #7, PC = 28, ALU = 0
      (32, 1),  -- Test Case #8, PC = 32, ALU = 1
      (36, 0),  -- Test Case #9, PC = 36, ALU = 0
      (40, 1),  -- Test Case #10, PC = 40, ALU = 1

      (44, 40), -- Test Case #11, PC = 44, ALU = 40
      (48, 1),  -- Test Case #12, PC = 48, ALU = 1
      (52, 16), -- Test Case #13, PC = 52, ALU = 16 (lw mem address)
      (56, 4),  -- Test Case #14, PC = 56, ALU = 4 (sw mem address)
      (60, -6), -- Test Case #15, PC = 60, ALU = -6

      (64, 1),  -- Test Case #16, PC = 64, ALU = 1
      (68, 7),  -- Test Case #17, PC = 68, ALU = 7
      (72, 0),  -- Test Case #18, PC = 72, ALU = 0
      (72, 0),  -- Test Case #19, PC = 72, ALU = 0
      (72, 1),  -- Test Case #20, PC = 72, ALU = 1

      (72, 0),  -- Test Case #21, PC = 72, ALU = 0
      (72, 0),  -- Test Case #22, PC = 72, ALU = 0, last instruction in WB phase

      (0, 0)    -- Test Case #23, Reset = 1, PC = 0, ALU = 0
   );
      

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

   -- reset
   process
   begin
      wait for 22*T;
      reset <= '1';
      wait for T;
      reset <= '0';
      wait;
   end process;

   -- look up table
   process
   begin
      for j in lookup_table'range loop
         wait for T;
         assert(to_integer(unsigned(PC_out)) = lookup_table(j).PC_val)
            report "Test Case #" & integer'image(j + 1) & " failed - PC" severity error;

         if j > 2 then -- first two test cases have no ALU output since no instruction in EX phase
            assert(to_integer(signed(ALU_result)) = lookup_table(j).ALU_val)
               report "Test Case #" & integer'image(j + 1) & " failed - ALU" severity error;
         end if;
      end loop;
      wait;
   end process;
end;
