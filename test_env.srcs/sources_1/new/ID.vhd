----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2022 05:28:50 PM
-- Design Name: 
-- Module Name: ID_Unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
    Port (Instr: in std_logic_vector(12 downto 0);
    RegDest: in std_logic;
    ExtOp: in std_logic;
    RegWrite: in std_logic;
    WD: in std_logic_vector(15 downto 0);
    clk: in std_logic;
    RD1: out std_logic_vector(15 downto 0);
    RD2: out std_logic_vector(15 downto 0);
    Ext_Imm: out std_logic_vector(15 downto 0);
    enable: in std_logic;
    func: out std_logic_vector(2 downto 0);
    sa: out std_logic);
end ID;

architecture Behavioral of ID is

signal writeAddress: std_logic_vector(2 downto 0);
signal RegAddress: std_logic_vector(2 downto 0);

type regFileArray is array(0 to 7) of std_logic_vector(15 downto 0);
signal regFile: regFileArray := (
    x"0001",
    x"0002",
    x"0003",
    x"0004",
    x"0005",
    x"0006",
    x"0007",
    x"0008",
    others => x"0000");

begin

    -- Write on register file
    with RegDest select 
        writeAddress <= Instr(6 downto 4) when '1', -- rd
                        Instr(9 downto 7) when '0', -- rt
                        (others => '0') when others; -- unkown
                        
    process(clk)
    begin 
        if rising_edge(clk) then
            if enable = '1' and RegWrite = '1' then
                regFile(conv_integer(writeAddress)) <= wd;
            end if;
        end if;
    end process;
    
    --Read from register file
    RD1 <= regFile(conv_integer(Instr(12 downto 10))); -- rs
    RD2 <= regFile(conv_integer(Instr(9 downto 7))); -- rt
    
    -- immediate extend
    Ext_Imm(6 downto 0) <= Instr(6 downto 0);
    with ExtOp select
        Ext_Imm(15 downto 7) <= (others => Instr(6)) when '1',
                                (others => '0') when '0',
                                (others => '0') when others;

    func <= Instr(2 downto 0);
    sa <= Instr(3); 
    
end Behavioral;
