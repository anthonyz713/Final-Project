-- Group Members: Michelle Gamba, Jesus Ruelas-Perez, Anthony Zhang
library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
   port(clk, reset: in std_logic;
        opcode: in std_logic_vector(5 downto 0);
        RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite: out std_logic;
        ALUOP: out std_logic_vector(1 downto 0));
end ControlUnit;

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
            ALUOp <= "00";
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
               ALUOp <= "10";
            elsif opcode = "100011" then -- lw
               RegDst <= '0';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '1';
               MemtoReg <= '1';
               MemWrite <= '0';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "00";
            elsif opcode = "101011" then -- sw
               RegDst <= 'X';
               Jump <= '0';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= 'X';
               MemWrite <= '1';
               ALUSrc <= '1';
               RegWrite <= '0';
               ALUOp <= "00";
            elsif opcode = "000100" then -- beq
               RegDst <= 'X';
               Jump <= '0';
               Branch <= '1';
               MemRead <= '0';
               MemtoReg <= 'X';
               MemWrite <= '0';
               ALUSrc <= '0';
               RegWrite <= '0';
               ALUOp <= "01";
            elsif opcode = "000010" then -- jump
               RegDst <= 'X';
               Jump <= '1';
               Branch <= '0';
               MemRead <= '0';
               MemtoReg <= 'X';
               MemWrite <= '0';
               ALUSrc <= 'X';
               RegWrite <= '0';
               ALUOp <= "11";
            end if;
         end if;
      end process;
end;