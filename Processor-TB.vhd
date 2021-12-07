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

   -- Register values, only $t0 - $t7, $s0 - $s7, $t8, $t9 used
   signal t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, s0, s1, s2, s3, s4, s5, s6, s7: std_logic_vector(31 downto 0);

   -- Data memory values for sw
   signal m4, m5, m6, m7: std_logic_vector(7 downto 0);

   -- record type declaration
   type lookup_table_entry is record
      PC_val, ALU_val: Integer; -- Integer, not std_logic_vector, so easier to read

      -- Check registers
      RegWrite: std_logic; -- if high, instruction wrote back to register
      RegDst: Integer; -- which register instruction wrote back to
      RegValue: Integer; -- what value was written to the register

      -- Check memory, do not need an address since only one sw instruction, saves at mem address 4
      MemWrite: std_logic; -- if high, instruction wrote back to memory
      MemValue: Integer; -- what value was written to memory
   end record;

   -- declare look up table type
   type lookup_table_type is array (natural range <>) of lookup_table_entry;

   -- declare lookup table
   constant lookup_table: lookup_table_type := (
      (4, 0, '0', 0, 0, '0', 0),   -- Test Case #1, PC = 4, no ALU result, no reg or mem write
      (8, 0, '0', 0, 0, '0', 0),   -- Test Case #2, PC = 8, no ALU result, no reg or mem write
      (12, 1, '0', 0, 0, '0', 0),  -- Test Case #3, PC = 12, ALU = 1, no reg or mem write
      (16, 5, '0', 0, 0, '0', 0),  -- Test Case #4, PC = 16, ALU = 5, no reg or mem write
      (20, 4, '1', 14, 1, '0', 0),  -- Test Case #5, PC = 20, ALU = 4, reg write 1 to $14/$t6, no mem write

      (24, 5, '1', 15, 5, '0', 0),  -- Test Case #6, PC = 24, ALU = 5, reg write 5 to $15/$t7, no mem write
      (28, 0, '1', 24, 4, '0', 0),  -- Test Case #7, PC = 28, ALU = 0, reg write 4 to $24/$t8, no mem write
      (32, 1, '1', 25, 5, '0', 0),  -- Test Case #8, PC = 32, ALU = 1, reg write 5 to $25/$t9, no mem write
      (36, 0, '1', 8, 0, '0', 0),  -- Test Case #9, PC = 36, ALU = 0, reg write 0 to $8/$t0, no mem write
      (40, 1, '1', 9, 1, '0', 0),  -- Test Case #10, PC = 40, ALU = 1, reg write 1 to $9/$t1, no mem write

      (44, 40, '1', 10, 0, '0', 0), -- Test Case #11, PC = 44, ALU = 40, reg write 0 to $10/$t2, no mem write
      (48, 1, '1', 11, 1, '0', 0),  -- Test Case #12, PC = 48, ALU = 1, reg write 1 to $11/$t3, no mem write
      (52, 16, '1', 14, 40, '0', 0), -- Test Case #13, PC = 52, ALU = 16 (lw mem address), reg write 40 to $14/$t6, no mem write
      (56, 4, '1', 15, 1, '0', 0),  -- Test Case #14, PC = 56, ALU = 4 (sw mem address), reg write 1 to $15/$t7
      (60, -6, '1', 24, -10, '1', 1386952641), -- Test Case #15, PC = 60, ALU = -6, reg write -10 to $24/$t8, mem write 0x52AB37C1 (1386952641) to mem[4,5,6,7]

      (64, 1, '0', 0, 0, '0', 0),  -- Test Case #16, PC = 64, ALU = 1, no reg or mem write (sw in WB phase)
      (68, 7, '1', 16, -6, '0', 0),  -- Test Case #17, PC = 68, ALU = 7, reg write -6 to $16/$s0, no mem write
      (72, 0, '1', 17, 1, '0', 0),  -- Test Case #18, PC = 72, ALU = 0, reg write 1 to $17/$s1, no mem write
      (72, 0, '1', 18, 7, '0', 0),  -- Test Case #19, PC = 72, ALU = 0, reg write 7 to $18/$s2, no mem write
      (72, 1, '1', 19, 0, '0', 0),  -- Test Case #20, PC = 72, ALU = 1, reg write 0 to $19, $s3, no mem write

      (72, 0, '1', 21, 0, '0', 0),  -- Test Case #21, PC = 72, ALU = 0, reg write 0 to $21/$s5, no mem write
      (72, 0, '1', 20, 1, '0', 0),  -- Test Case #22, PC = 72, ALU = 0, last instruction in WB phase, reg write 1 to $20/$s4, no mem write

      (0, 0, '0', 0, 0, '0', 0)    -- Test Case #23, Reset = 1, PC = 0, ALU = 0, all instructions done
   );
      

begin
   UUT: entity work.Processor port map(clk => clk, reset => reset, 
           PC_out => PC_out, ALU_result => ALU_result, t0 => t0,
           t1 => t1, t2 => t2, t3 => t3, t4 => t4, t5 => t5, t6 => t6,
           t7 => t7, t8 => t8, t9 => t9, s0 => s0, s1 => s1, s2 => s2,
           s3 => s3, s4 => s4, s5 => s5, s6 => s6, s7 => s7, m4 => m4,
           m5 => m5, m6 => m6, m7 => m7);

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
      variable RegDst: Integer;
      variable ValueInReg: Integer;
      variable ValueInMemVector: std_logic_vector(31 downto 0);
   begin
      for j in lookup_table'range loop
         wait for T;

         -- Check if PC is correct
         assert(to_integer(unsigned(PC_out)) = lookup_table(j).PC_val)
            report "Test Case #" & integer'image(j + 1) & " failed - PC" severity error;

         -- Check if ALU output is correct
         if j > 2 then -- first two test cases have no ALU output since no instruction in EX phase
            assert(to_integer(signed(ALU_result)) = lookup_table(j).ALU_val)
               report "Test Case #" & integer'image(j + 1) & " failed - ALU" severity error;
         end if;

         -- Check if value written to register successfully
         if lookup_table(j).RegWrite = '1' then
            RegDst := lookup_table(j).RegDst;

            if RegDst = 8 then
               ValueInReg := to_integer(signed(t0));
            elsif RegDst = 9 then
               ValueInReg := to_integer(signed(t1));
            elsif RegDst = 10 then
               ValueInReg := to_integer(signed(t2));
            elsif RegDst = 11 then
               ValueInReg := to_integer(signed(t3));
            elsif RegDst = 12 then
               ValueInReg := to_integer(signed(t4));
            elsif RegDst = 13 then
               ValueInReg := to_integer(signed(t5));
            elsif RegDst = 14 then
               ValueInReg := to_integer(signed(t6));
            elsif RegDst = 15 then
               ValueInReg := to_integer(signed(t7));
            elsif RegDst = 16 then
               ValueInReg := to_integer(signed(s0));
            elsif RegDst = 17 then
               ValueInReg := to_integer(signed(s1));
            elsif RegDst = 18 then
               ValueInReg := to_integer(signed(s2));
            elsif RegDst = 19 then
               ValueInReg := to_integer(signed(s3));
            elsif RegDst = 20 then
               ValueInReg := to_integer(signed(s4));
            elsif RegDst = 21 then
               ValueInReg := to_integer(signed(s5));
            elsif RegDst = 22 then
               ValueInReg := to_integer(signed(s6));
            elsif RegDst = 23 then
               ValueInReg := to_integer(signed(s7));
            elsif RegDst = 24 then
               ValueInReg := to_integer(signed(t8));
            elsif RegDst = 25 then
               ValueInReg := to_integer(signed(t9));               
            end if;
            
            assert(ValueInReg = lookup_table(j).RegValue)
               report "Test Case #" & integer'image(j + 1) & " failed - Reg Value Wrong" severity error;
         end if;
   
         -- Check if value successfully written to memory
         if lookup_table(j).MemWrite = '1' then
            -- Read values from memory (big-endian)
            ValueInMemVector(31 downto 24) := m4;
            ValueInMemVector(23 downto 16) := m5;
            ValueInMemVector(15 downto 8) := m6;
            ValueInMemVector(7 downto 0) := m7;
            
            assert(to_integer(signed(ValueInMemVector)) = lookup_table(j).MemValue)
               report "Test Case #" & integer'image(j + 1) & " failed - Mem Value Wrong" severity error;
         end if;
      end loop;
      wait;
   end process;
end;
