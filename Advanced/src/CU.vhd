library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RISC.all;

entity CU is
port(	CLK 		: in std_logic;
		RESET 		: in std_logic;
		STALL_FLUSH	: in std_logic;
		OPCODE 		: in std_logic_vector(6 downto 0);
		FUNC 		: in std_logic_vector(9 downto 0);
		--ID
		INSTR_ID		: out INSTR_TYPE;
		--EX
		ABS_INSTR 		: out std_logic;
		SRA_INSTR 		: out std_logic;
		LOAD_INSTR 		: out std_logic;
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
end entity;

architecture HARDWIRED of CU is

	component REG is 
		generic(n 		: integer := 8);
		port(	
			CLK		: in std_logic;
			RST_n 	: in std_logic;
			EN 		: in std_logic;
			IN_DATA	: in std_logic_vector(n-1 downto 0);
			OUT_DATA: out std_logic_vector(n-1 downto 0));
	end component;
	
	signal cw : std_logic_vector(16 downto 0);
	signal id_ex : std_logic_vector(16 downto 0);
	signal ex_mem : std_logic_vector(6 downto 0);
	signal mem_wb : std_logic_vector(2 downto 0);
begin
	
	word_gen: process(OPCODE, FUNC, RESET)
	begin
		if RESET = '0' then 
			cw <= (others => '0');
			INSTR_ID <= I;
		else 
			case OPCODE is
				when LUI_OP => 		cw <= "00010000011000101";
									INSTR_ID <= U;
				when AUIPC_OP => 	cw <= "00010001101000101";
									INSTR_ID <= U;
				when I_TYPE_OP => 	INSTR_ID <= I;
									case FUNC is
										when ADDI_FUNC => cw <= "00010001001000101";
										when SRAI_FUNC => cw <= "01010011001000101";
														  INSTR_ID <= R;
										when ANDI_FUNC => cw <= "00010101001000101";
										when others => cw <= "00010001001000101";
									end case;
									
				when R_TYPE_OP => 	INSTR_ID <= R;
									case FUNC is
										when ADD_FUNC => cw <= "00010000001000101";
										when XOR_FUNC => cw <= "00010110001000101";
										when SLT_FUNC => cw <= "00011000001000101";
										when ABS_FUNC => cw <= "10010000001000101";
										when others => cw <= "00010001001000101";
									end case;			
				when BEQ_OP => 		cw <= "00010000001000100";
									INSTR_ID <= B;
				when LW_OP => 		cw <= "00110001001111101";
									INSTR_ID <= I;
				when JAL_OP => 		cw <= "00010000001000111";
									INSTR_ID <= J;
				when SW_OP => 		cw <= "00010001001110100";
									INSTR_ID <= S;
				when others => 		cw <= "00010001001000101"; -- NOP implemented as ADDI x0,x0,0 
									INSTR_ID <= I;
			end case;
		end if;	
	end process;

	pipe_manage: process(CLK, RESET)
	begin
		if RESET = '0' then 
			id_ex <= (others => '0');
			ex_mem <= (others => '0');
			mem_wb <= (others => '0');
		elsif CLK'event and CLK = '1' then 
			if STALL_FLUSH = '0' then  -- Control word goes on only if nor stall neither flush are needed 
				id_ex <= cw;
			else
				id_ex <= "00010001001000101";
			end if;
			ex_mem <= id_ex(6 downto 0);
			mem_wb <= ex_mem(2 downto 0);
		end if;
	end process;
	
	--ID
	--EX
	ABS_INSTR		<= id_ex(16);
	SRA_INSTR 		<= id_ex(15);
	LOAD_INSTR 		<= id_ex(14);
	EX_STAGE_EN		<= id_ex(13);
	ALU_FUNC		<= id_ex(12 downto 10);
	I_TYPE_EX		<= id_ex(9);
	AUIPC_INSTR_EX	<= id_ex(8);
	LUI_INSTR_EX	<= id_ex(7);
	--MEM
	MEM_STAGE_EN 	<= ex_mem(6);
	MEM_EN			<= ex_mem(5);
	MEM_INSTR		<= ex_mem(4);
	MEM_READ_WRITE_N<= ex_mem(3);
	--WB
	WB_STAGE_EN 	<= mem_wb(2);
	JAL_INSTR 		<= mem_wb(1);
	RF_W_EN			<= mem_wb(0);

end architecture;