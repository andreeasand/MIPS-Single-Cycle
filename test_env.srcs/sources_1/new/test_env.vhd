----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2022 10:42:57
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
  Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
           );
end test_env;


architecture Behavioral of test_env is                

component MPG is
Port(clock: in STD_LOGIC;
        btn:in STD_LOGIC;
        en:out STD_LOGIC);
end component;

component SSD is
    Port ( clk: in STD_LOGIC;
           digits: in STD_LOGIC_VECTOR(15 downto 0);
           anod: out STD_LOGIC_VECTOR(3 downto 0);
           catod: out STD_LOGIC_VECTOR(6 downto 0));
end component;

component reg_file1 is
port (
    clk : in std_logic;
    ra1 : in std_logic_vector (2 downto 0);
    ra2 : in std_logic_vector (2 downto 0);
    wa : in std_logic_vector (2 downto 0);
    wd : in std_logic_vector (15 downto 0);
    regwr : in std_logic;
    en: in std_logic;
    rd1 : out std_logic_vector (15 downto 0);
    rd2 : out std_logic_vector (15 downto 0)
);
end component;

component IF1 is
    Port (Instruction: out std_logic_vector(15 downto 0);
    NextInstruction: out std_logic_vector(15 downto 0);
    Jump: in std_logic;
    PCSrc: in std_logic;
    clk: in std_logic;
    enable: in std_logic;
    reset: in std_logic;
    JumpAddress: in std_logic_vector(15 downto 0);
    BranchAddress: in std_logic_vector(15 downto 0));
end component;


--component rams_no_change is
-- port ( clk : in std_logic;
--       we : in std_logic;
--       en : in std_logic;
--       addr : in std_logic_vector(3 downto 0);
--       di : in std_logic_vector(15 downto 0);
--       do : out std_logic_vector(15 downto 0));
-- end component;

component MainControl is
    Port(
    Instr: in std_logic_vector(2 downto 0);
    RegDst: out std_logic;
    ExtOp: out std_logic;
    ALUSrc: out std_logic;
    BranchOnEqual: out std_logic;
    BranchOnNotEqual: out std_logic;
    Jump: out std_logic;
    ALUOp: out std_logic_vector(2 downto 0);
    MemWrite: out std_logic;
    MemToReg: out std_logic;
    RegWrite: out std_logic);
end component;

component ID is
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
end component;


component MEM is
    Port ( ALUResIn : in STD_LOGIC_VECTOR (15 downto 0);
    RD2: in std_logic_vector(15 downto 0);
    MemWrite: in std_logic;
    en: in std_logic;
    clk: in std_logic;
    ALUResOut: out std_logic_vector(15 downto 0);
    MemData: out std_logic_vector(15 downto 0));
end component;

component EX is
    Port ( NextInstr: in std_logic_vector(15 downto 0);
    RD1: in std_logic_vector(15 downto 0);
    RD2: in std_logic_vector(15 downto 0);
    Ext_Imm: in std_logic_vector(15 downto 0);
    ALUSrc: in std_logic;
    sa: in std_logic;
    func: in std_logic_vector(2 downto 0);
    ALUOp: in std_logic_vector(2 downto 0);
    zero: out std_logic;
    BranchAddress: out std_logic_vector(15 downto 0);
    ALURes: out std_logic_vector(15 downto 0));
end component;

--signal cnt: std_logic_vector (3 downto 0):= "0000";
--signal digitSSD: std_logic_vector (15 downto 0):= (others=> '0');
--signal zero: std_logic :='0';
--signal enable_reg: std_logic := '0';  --pt al doilea mpg
--signal do: std_logic_vector(15 downto 0) := (others => '0');
--signal pcSrc: std_logic := '0' ;
--signal jump: std_logic := '0';
--signal ext_func : std_logic_vector(15 downto 0) := (others => '0');
--signal ext_sa : std_logic_vector(15 downto 0) := (others => '0');
--signal reg_dst : std_logic := '0';

--type MEM is array ( 0 to 255) of std_logic_vector (15 downto 0);

--signal rom: MEM := (x"0000",
 --                   x"0001",
 --                   x"0010",
 --                   x"0011",
 --                   x"0100",
 --                   others => "0000000000000000");
--signal data : std_logic_vector(15 downto 0);    

signal Instruction, NextInstruction, RD1, RD2, WD, Ext_Imm: std_logic_vector(15 downto 0);
signal JumpAddress, BranchAddress, ALURes, ALURes1, MemData: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal sa, zero, enable, reset, PCSrc: std_logic;
signal digits: std_logic_vector(15 downto 0);
signal RegDst, ExtOp, ALUSrc, BranchOnEqual, BranchOnNotEqual, Jump, MemWrite, MemToReg, RegWrite: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);

begin

    enableWriting: mpg port map(clk, btn(0), enable);
    enableReset: mpg port map(clk, btn(1), reset);
    
    inst_IF: IF1 port map(Instruction, NextInstruction, Jump, PCSrc, clk, enable, reset, JumpAddress, BranchAddress);
    inst_ID: ID port map(Instruction(12 downto 0), RegDst, ExtOp, RegWrite, WD, clk, RD1, RD2, Ext_Imm, enable, func, sa);
    inst_UC: MainControl port map(Instruction(15 downto 13), RegDst, ExtOp, ALUSrc, BranchOnEqual, BranchOnNotEqual, Jump, ALUOp, MemWrite, MemToReg, RegWrite);
    inst_EX: EX port map(NextInstruction, RD1, RD2, Ext_Imm, ALUSrc, sa, func, ALUOp, zero, BranchAddress, ALURes);
    inst_Mem: MEM port map(ALURes, RD2, MemWrite, enable, clk, ALURes1, MemData);

    -- WriteBack
    with MemToReg select
        WD <= MemData when '1',
              ALURes when '0',
              (others => '0') when others;
              
    -- branch control
    PCSrc <= (zero and BranchOnEqual) or (not zero and BranchOnNotEqual);
    
    -- jump address
    JumpAddress <= NextInstruction(15 downto 13) & Instruction(12 downto 0);
    
    -- afisor
    with sw(7 downto 5) select
        digits <= Instruction when "000",
                  NextInstruction when "001",
                  RD1 when "010",
                  RD2 when "011",
                  Ext_Imm when "100",
                  ALURes when "101",
                  MemData when "110",
                  WD when "111",
                  (others => '0') when others;
    
    afisor: SSD port map(clk, digits, an, cat);
    
    led(12 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & BranchOnEqual & BranchOnNotEqual & zero & Jump & MemWrite & MemToReg & RegWrite;              
--data<= rom(conv_integer(cnt));

--reg: reg_file port map(clk, cnt(3 downto 0), cnt (3 downto 0), cnt(3 downto 0),rez,enable_reg, rd1, rd2);

--ramm: rams_no_change port map(clk,enable_reg, en, cnt, digits, do);
--monopulse_regwr: mpg port map(clk,btn(1),enable_reg);

--digits <= pcout when sw(7) ='1' else instr;

--    ralu <= rd1 + rd2;
        
    

--    ext_func <= "0000000000000" & func;
--    ext_sa <= "000000000000000" & sa;
    


--alu

--process(cnt)
  --  begin
   --     case cnt is
   --         when "00" => digitSSD <= ("000000000000" & sw(3 downto 0)) + ("000000000000" & sw(7 downto 4)); 
    --        when "01" => digitSSD <= ("000000000000" & sw(3 downto 0)) - ("000000000000" & sw(7 downto 4));              
    --        when "10" => digitSSD <= "000000" & sw(7 downto 0) & "00";
    --        when "11" => digitSSD <= "0000000000000" & sw(7 downto 5);
    --    end case;
    --    if digitSSD = x"0000" then
      --              zero <= '1';
    --            else
    --                zero <= '0';
    --            end if;
 --   end process;
    --led(7) <= zero;

--
--process (clk,en)
--begin
--if rising_edge(clk) then
--   if en ='1' then
--     if sw(0)='1' then
--      cnt<= cnt+1;
--     else
--      cnt<= cnt-1;
--     end if;
--    end if;
-- end if;
--end process;

--rez<= rd1+rd2;

--led <= cnt;
   
end Behavioral;
