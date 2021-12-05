-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
   port(clk, reset: in std_logic;
        opcode: in std_logic_vector(5 downto 0);
        RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite: out std_logic;
        ALUOP: out std_logic_vector(3 downto 0));
end ControlUnit;
-- ALUFunction (Textbook 4.4 Pg. 259):
-- 0000: AND
-- 0001: OR
-- 0010: add
-- 0011: R-TYPE INSTRUCTION
-- 0110: sub
-- 0111: set on less than
-- 1100: NOR
-- 1101: XOR
-- 1110: shift left
-- 1111: shift right

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
            ALUOp <= "UUUU";
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
               ALUOp <= "0011";
            elsif opcode = "100011" then -- lw
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '1';
               MemtoReg <= '1';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "0010";
            elsif opcode = "101011" then -- sw
               RegDst <= 'X';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= 'X';
               MemWrite <= '1';
               ALUSrc <= '1';
               RegWrite <= '0';
               ALUOp <= "0010";
            --elsif opcode = "000100" then -- beq
            --   RegDst <= 'X';
            --   Jump <= '0';
            --   Branch <= '1';
            --   MemRead <= '0';
            --   MemtoReg <= 'X';
            --   MemWrite <= '0';
            --   ALUSrc <= '0';
            --   RegWrite <= '0';
            --   ALUOp <= "001";
            --elsif opcode = "000010" then -- jump
            --   RegDst <= 'X';
            --   Jump <= '1';
            --   Branch <= '0';
            --   MemRead <= '0';
            --  MemtoReg <= 'X';
            --   MemWrite <= '0';
            --   ALUSrc <= 'X';
            --   RegWrite <= '0';
            --   ALUOp <= "011";
            elsif opcode = "001000" then -- addi
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "0010";
            elsif opcode = "001100" then -- andi
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "0000";
            elsif opcode = "001101" then -- ori
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "0001";
            elsif opcode = "001010" then -- slti
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "0111";
            end if;
         end if;
      end process;
end;