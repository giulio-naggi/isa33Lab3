library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RISC.all;

entity RV32I is 
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
end entity;

architecture structural of RV32I is

	component DATAPATH is
		port(	CLK 			: in std_logic;
				RST_n 			: in std_logic;
				IRAM_DATA		: in std_logic_vector(31 downto 0);
				IRAM_ADDRESS	: out std_logic_vector(31 downto 0);
				DRAM_ADDRESS	: out std_logic_vector(31 downto 0);
				DRAM_DATA_IN	: out std_logic_vector(31 downto 0);
				DRAM_DATA_OUT	: in std_logic_vector(31 downto 0);
				STALL 			: out std_logic;
				OPCODE			: out std_logic_vector(6 downto 0);
				FUNC			: out std_logic_vector(9 downto 0);
				--CU SIGNALS
				--ID
				INSTR_ID		: in INSTR_TYPE;
				RF_W_EN			: in std_logic;
				LOAD_INSTR 		: in std_logic;
				--EX
				SRA_INSTR 		: in std_logic;
				ALU_FUNC		: in std_logic_vector(2 downto 0);
				I_TYPE_EX		: in std_logic; 
				AUIPC_INSTR_EX	: in std_logic;
				LUI_INSTR_EX	: in std_logic;
				--MEM
				MEM_INSTR		: in std_logic;
				--WB
				JAL_INSTR 		: in std_logic);
	end component;
	
	component CU is
		port(	CLK 		: in std_logic;
				RESET 		: in std_logic;
				STALL_FLUSH	: in std_logic;
				OPCODE 		: in std_logic_vector(6 downto 0);
				FUNC 		: in std_logic_vector(9 downto 0);
				--ID
				INSTR_ID		: out INSTR_TYPE;
				LOAD_INSTR 		: out std_logic;
				--EX
				SRA_INSTR 		: out std_logic;
				EX_STAGE_EN		: out std_logic;
				ALU_FUNC		: out std_logic_vector(2 downto 0);
				I_TYPE_EX		: out std_logic; 
				AUIPC_INSTR_EX	: out std_logic;
				LUI_INSTR_EX	: out std_logic;
				--MEM
				MEM_STAGE_EN 	: out std_logic;
				MEM_EN			: out std_logic;
				MEM_INSTR		: out std_logic;
				MEM_READ_WRITE_N: out std_logic;
				--WB
				WB_STAGE_EN 	: out std_logic;
				JAL_INSTR 		: out std_logic;
				RF_W_EN			: out std_logic);
	end component;
	
	
	signal STALL_FLUSH		: std_logic;
	signal OPCODE 			: std_logic_vector(6 downto 0);
	signal FUNC 			: std_logic_vector(9 downto 0);
	--ID
	signal INSTR_ID			: INSTR_TYPE;
	signal LOAD_INSTR 		: std_logic;
	--EX
	signal SRA_INSTR		: std_logic;
	signal EX_STAGE_EN		: std_logic;
	signal ALU_FUNC			: std_logic_vector(2 downto 0);
	signal I_TYPE_EX		: std_logic; 
	signal AUIPC_INSTR_EX	: std_logic;
	signal LUI_INSTR_EX		: std_logic;
	--MEM
	signal MEM_STAGE_EN 	: std_logic;
	signal MEM_INSTR		: std_logic;
	--WB
	signal WB_STAGE_EN 		: std_logic;
	signal JAL_INSTR 		: std_logic;
	signal RF_W_EN			: std_logic;
begin

	dp: DATAPATH port map(CLK => CLK, RST_n => RST_n, IRAM_DATA  => IRAM_DATA, IRAM_ADDRESS => IRAM_ADDRESS, DRAM_ADDRESS => DRAM_ADDRESS, DRAM_DATA_IN => DRAM_DATA_IN,
						DRAM_DATA_OUT => DRAM_DATA_OUT, STALL => STALL_FLUSH, OPCODE => OPCODE, FUNC => FUNC, INSTR_ID => INSTR_ID, RF_W_EN => RF_W_EN, 
						LOAD_INSTR => LOAD_INSTR, SRA_INSTR => SRA_INSTR, ALU_FUNC => ALU_FUNC, I_TYPE_EX => I_TYPE_EX, AUIPC_INSTR_EX => AUIPC_INSTR_EX, LUI_INSTR_EX => LUI_INSTR_EX,
						MEM_INSTR => MEM_INSTR, JAL_INSTR => JAL_INSTR);
	
	cu_inst: CU port map(CLK => CLK, RESET => RST_n, STALL_FLUSH => STALL_FLUSH, OPCODE => OPCODE, FUNC => FUNC, INSTR_ID => INSTR_ID, LOAD_INSTR => LOAD_INSTR, 
						SRA_INSTR => SRA_INSTR, EX_STAGE_EN => EX_STAGE_EN, ALU_FUNC => ALU_FUNC, I_TYPE_EX => I_TYPE_EX, AUIPC_INSTR_EX => AUIPC_INSTR_EX, LUI_INSTR_EX => LUI_INSTR_EX, 
						MEM_STAGE_EN => MEM_STAGE_EN, MEM_EN => DRAM_EN, MEM_INSTR => MEM_INSTR, MEM_READ_WRITE_N => MEM_READ_WRITE_N, WB_STAGE_EN => WB_STAGE_EN, JAL_INSTR => JAL_INSTR, RF_W_EN => RF_W_EN);

end architecture;