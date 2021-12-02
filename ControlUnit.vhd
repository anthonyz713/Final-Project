-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
   port(clk, reset: in std_logic;
        opcode: in std_logic_vector(5 downto 0);
        RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite: out std_logic;
        ALUOP: out std_logic_vector(2 downto 0));
end ControlUnit;
-- ALUOp:
-- 000: add
-- 001: subtract
-- 010: R-type, look at function code
-- 011: jump
-- 100: AND
-- 101: OR
-- 110: XOR

architecture ControlUnitBehav of ControlUnit is
begin
   process(clk, reset)
      begin
         if reset = '1' then
            RegDst <= '0';
            Jump <= '0';
            Branch <= '0';
            MemRead <= '0';
            MemtoReg <= '0';
            MemWrite <= '0';
            ALUSrc <= '0';
            RegWrite <= '0';
            ALUOp <= "000";
         elsif rising_edge(clk) then
            if opcode = "000000" then -- R-type instruction
               RegDst <= '1';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc <= '0';
               RegWrite <= '1';
               ALUOp <= "010";
            elsif opcode = "100011" then -- lw
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '1';
               MemtoReg <= '1';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "000";
            elsif opcode = "101011" then -- sw
               RegDst <= 'X';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= 'X';
               MemWrite <= '1';
               ALUSrc <= '1';
               RegWrite <= '0';
               ALUOp <= "000";
            elsif opcode = "000100" then -- beq
               RegDst <= 'X';
               Jump <= '0';
               Branch <= '1';
               MemRead <= '0';
               MemtoReg <= 'X';
               MemWrite <= '0';
               ALUSrc <= '0';
               RegWrite <= '0';
               ALUOp <= "001";
            elsif opcode = "000010" then -- jump
               RegDst <= 'X';
               Jump <= '1';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= 'X';
               MemWrite <= '0';
               ALUSrc <= 'X';
               RegWrite <= '0';
               ALUOp <= "011";
            elsif opcode = "001000" then -- addi
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "000";
            elsif opcode = "001100" then -- andi
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "100";
            elsif opcode = "001101" then -- ori
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "101";
            elsif opcode = "001010" then -- slti
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "001"; -- subtract?
            end if;
         end if;
      end process;
end;