library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RISC.all;

entity TB is
end entity;

architecture TEST of TB is

component IRAM is 
port(
	RST : in std_logic;
	ADDRESS_READ : in std_logic_vector(31 downto 0);
	DATA_OUT : out std_logic_vector(31 downto 0));
end component;

component DRAM is
port(
	CLK : in std_logic;
	ADDRESS : in std_logic_vector(31 downto 0);
	DATA_IN : in std_logic_vector(31 downto 0);
	RST : in std_logic;
	ENABLE : in std_logic;
	READ_WRITE_n : in std_logic;
	DATA_OUT : out std_logic_vector(31 downto 0));
end component;

component RV32I is 
	port (
		CLK 			: in std_logic;
		RST_n 			: in std_logic;
		IRAM_DATA		: in std_logic_vector(31 downto 0);
		IRAM_ADDRESS	: out std_logic_vector(31 downto 0);
		DRAM_ADDRESS	: out std_logic_vector(31 downto 0);
		DRAM_DATA_IN	: out std_logic_vector(31 downto 0);
		DRAM_DATA_OUT	: in std_logic_vector(31 downto 0);
		DRAM_EN			: out std_logic;
		MEM_READ_WRITE_N: out std_logic);
end component;

signal RST_s: std_logic;
signal CLK_s: std_logic := '0';
signal ENABLE_s: std_logic;
signal READ_WRITE_n_s: std_logic;
signal IRAM_DATA_s:  std_logic_vector(31 downto 0);
signal IRAM_ADDRESS_s: std_logic_vector(31 downto 0);
signal DRAM_ADDRESS_s: std_logic_vector(31 downto 0);
signal DRAM_DATA_IN_s: std_logic_vector(31 downto 0);
signal DRAM_DATA_OUT_s: std_logic_vector(31 downto 0);	

begin

	processor: RV32I port map(	CLK => CLK_s,
								RST_n => RST_s,		
								IRAM_DATA => IRAM_DATA_s,		
								IRAM_ADDRESS => IRAM_ADDRESS_s,	
								DRAM_ADDRESS => DRAM_ADDRESS_s,	
								DRAM_DATA_IN => DRAM_DATA_IN_s,	
								DRAM_DATA_OUT => DRAM_DATA_OUT_s,
								DRAM_EN	=> ENABLE_s,
								MEM_READ_WRITE_N => READ_WRITE_n_s);
								
	instr_mem: IRAM port map(	RST => RST_s,
								ADDRESS_READ => IRAM_ADDRESS_s,
								DATA_OUT => IRAM_DATA_s);
	
	data_mem : DRAM port map(	CLK => CLK_s,
								ADDRESS => DRAM_ADDRESS_s,
								DATA_IN => DRAM_DATA_IN_s,
								RST => RST_s,
								ENABLE => ENABLE_s,
								READ_WRITE_n => READ_WRITE_n_s,
								DATA_OUT => DRAM_DATA_OUT_s);
	
	PCLOCK : process(CLK_s)
	begin
		CLK_s <= not(CLK_s) after 1 ns;	
	end process;
	
	test: process
	begin
		RST_s <= '0';
		wait for 3 ns;
		RST_s <= '1';
		wait for 500 ns;
	end process;

end architecture;