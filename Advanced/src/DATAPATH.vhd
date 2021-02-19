library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RISC.all;

entity DATAPATH is
port(
	CLK 			: in std_logic;
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
	--EX
	ABS_INSTR 		: in std_logic;
	SRA_INSTR 		: in std_logic;
	LOAD_INSTR 		: in std_logic;
	ALU_FUNC		: in std_logic_vector(2 downto 0);
	I_TYPE_EX		: in std_logic; 
	AUIPC_INSTR_EX	: in std_logic;
	LUI_INSTR_EX	: in std_logic;
	--MEM
	MEM_INSTR		: in std_logic;
	--WB
	RF_W_EN			: in std_logic;
	JAL_INSTR 		: in std_logic);
end entity;

architecture MIXED of DATAPATH is
	
	component REG is 
		generic(n 		: integer := 8);
		port(	
			CLK		: in std_logic;
			RST_n 	: in std_logic;
			IN_DATA	: in std_logic_vector(n-1 downto 0);
			OUT_DATA: out std_logic_vector(n-1 downto 0));
	end component;
	
	component REG_en is 
		generic(n 		: integer := 8);
		port(	
			CLK		: in std_logic;
			EN		: in std_logic;
			RST_n 	: in std_logic;
			IN_DATA	: in std_logic_vector(n-1 downto 0);
			OUT_DATA: out std_logic_vector(n-1 downto 0));
	end component;	
	
	component FF is 
		port(CLK		: in std_logic;
			RST_n		: in std_logic;
			IN_DATA		: in std_logic;
			OUT_DATA	: out std_logic);
	end component;

	--IF
	component ADDER_PC is
		port(	
			PC		: in std_logic_vector(31 downto 0);
			NEW_PC 	: out std_logic_vector(31 downto 0));
	end component;
	
	signal PC_IF: std_logic_vector(31 downto 0);
	signal IN_PC: std_logic_vector(31 downto 0);
	signal PC_ADD_4_IF: std_logic_vector(31 downto 0);
	signal PC_MOD_IF: std_logic_vector(31 downto 0);
	signal PC_NEW_IF: std_logic_vector(31 downto 0);
	--IF/ID
	
	signal PC_IF_ID: std_logic_vector(31 downto 0);
	signal IR_IF_ID: std_logic_vector(31 downto 0);
	--ID
	
	component HAZARD_UNIT is
		port(	RS1 : in std_logic_vector(4 downto 0);
				RS2 : in std_logic_vector(4 downto 0);
				RD_ID_EX : in std_logic_vector(4 downto 0);
				LOAD_INSTR : in std_logic;
				INSTR_ID : in INSTR_TYPE;
				STALL : out std_logic);
	end component;
	
	component BRANCH_ADDER is
		port(	PC 			: in std_logic_vector(31 downto 0);
				IMMEDIATE 	: in std_logic_vector(31 downto 0);
				NEW_PC 		: out std_logic_vector(31 downto 0));
	end component;
	
	component BRANCH_COMP is
		port(	IN_1 	: in std_logic_vector(31 downto 0);
				IN_2 	: in std_logic_vector(31 downto 0);
				EQ_OUT 	: out std_logic);
	end component;
	
	component RF is 
		port(	CLK : in std_logic;
				RST_n : in std_logic;
				W_EN : in std_logic;
				R_ADDR_1 : in std_logic_vector(4 downto 0);
				R_ADDR_2 : in std_logic_vector(4 downto 0);
				W_ADDR : in std_logic_vector(4 downto 0);
				W_DATA : in std_logic_vector(31 downto 0);
				R_DATA_1 : out std_logic_vector(31 downto 0);
				R_DATA_2 : out std_logic_vector(31 downto 0));
	end component;
	
	component DECODING_UNIT is
	  port (	INSTRUCTION_TYPE : in instr_type;
				INSTRUCTION      : in std_logic_vector(31 downto 7);
				RS2              : out std_logic_vector(4 downto 0);
				RS1              : out std_logic_vector(4 downto 0);
				RD               : out std_logic_vector(4 downto 0);
				IMM              : out std_logic_vector(31 downto 0));
	end component;
		
	signal B_COND: std_logic;
	signal RF_OUT_1_ID: std_logic_vector(31 downto 0);
	signal RF_OUT_2_ID: std_logic_vector(31 downto 0);
	signal FUNC_ID: std_logic_vector(9 downto 0);
	signal RS2_ID: std_logic_vector(4 downto 0);
	signal RS1_ID: std_logic_vector(4 downto 0);
	signal RD_ID : std_logic_vector(4 downto 0);
	signal IMM_ID: std_logic_vector(31 downto 0);
	signal BYPASS_OUT_1: std_logic_vector(31 downto 0);
	signal BYPASS_OUT_2: std_logic_vector(31 downto 0);
	signal BRANCH_FW_1: std_logic_vector(31 downto 0);
	signal BRANCH_FW_2: std_logic_vector(31 downto 0);
	signal STALL_s : std_logic;
	signal FLUSH_ID: std_logic;
	signal INSTRUCTION: std_logic_vector(31 downto 7);
	signal RF_OUT_1_OUT_ID: std_logic_vector(31 downto 0);
	signal RD_OUT_ID : std_logic_vector(4 downto 0);
	signal IMM_OUT_ID: std_logic_vector(31 downto 0);
	signal STALL_n: std_logic;
	signal STALL_s_ff: std_logic;
	signal PC_4_IF_ID: std_logic_vector(31 downto 0);
	--ID/EX
	
	signal FLUSH_ID_EX : std_logic;
	signal RD_ID_EX : std_logic_vector(4 downto 0);
	signal RS1_ID_EX: std_logic_vector(4 downto 0);
	signal RS2_ID_EX: std_logic_vector(4 downto 0);
	signal RF_OUT_1_ID_EX: std_logic_vector(31 downto 0);
	signal RF_OUT_2_ID_EX: std_logic_vector(31 downto 0);
	signal IMM_ID_EX: std_logic_vector(31 downto 0);
	signal PC_ID_EX: std_logic_vector(31 downto 0);
	signal PC_4_ID_EX: std_logic_vector(31 downto 0);
	
	--EX
	
	component FORWARDING_UNIT is
    port (	RS1_ID: in std_logic_vector(4 downto 0);
			RS2_ID: in std_logic_vector(4 downto 0);
			RS1_EX: in std_logic_vector(4 downto 0);
			RS2_EX: in std_logic_vector(4 downto 0);
			RS2_MEM: in std_logic_vector(4 downto 0);
			RD_EX: in std_logic_vector(4 downto 0);
			RD_MEM: in std_logic_vector(4 downto 0);
			RD_WB: in std_logic_vector(4 downto 0);
			FW_ID_MEM_A: out std_logic;
			FW_ID_MEM_B: out std_logic;
			FW_ID_WB_A: out std_logic;
			FW_ID_WB_B: out std_logic;
			FW_EX_MEM_A: out std_logic;
			FW_EX_MEM_B: out std_logic;
			FW_EX_WB_A: out std_logic;
			FW_EX_WB_B: out std_logic;
			FW_MEM_WB: out std_logic);
	end component;

	component ALU is
		port( 	A: in std_logic_vector(31 downto 0);
				B: in std_logic_vector(31 downto 0);
				ALU_FUNC: in std_logic_vector(2 downto 0);
				ALU_RESULT: out std_logic_vector(31 downto 0));
	end component;
	
	signal ALU_IN1_EX: std_logic_vector(31 downto 0);
	signal ALU_IN2_EX: std_logic_vector(31 downto 0);
	signal STORE_DATA_EX: std_logic_vector(31 downto 0);
	signal ALU_RESULT_EX: std_logic_vector(31 downto 0);
	signal DATA_OUT_EX: std_logic_vector(31 downto 0);
	signal FW_ID_MEM_A: std_logic;
	signal FW_ID_MEM_B: std_logic;
	signal FW_ID_WB_A: std_logic;
	signal FW_ID_WB_B: std_logic;
	signal FW_EX_MEM_A: std_logic;
	signal FW_EX_MEM_B: std_logic;
	signal FW_EX_WB_A: std_logic;
	signal FW_EX_WB_B: std_logic;
	signal FW_MEM_WB: std_logic;
	signal OPA_IN: std_logic_vector(31 downto 0);
	signal OPB_IN: std_logic_vector(31 downto 0);
	
	--EX/MEM
	
	signal RD_EX_MEM : std_logic_vector(4 downto 0);
	signal RS2_EX_MEM : std_logic_vector(4 downto 0);
	signal DATA_OUT_EX_MEM: std_logic_vector(31 downto 0);
	signal STORE_DATA: std_logic_vector(31 downto 0);
	signal PC_4_EX_MEM : std_logic_vector(31 downto 0);
	
	--MEM
	
	signal DATA_OUT_MEM: std_logic_vector(31 downto 0);
	signal STORE_DATA_FW: std_logic_vector(31 downto 0);
	
	--MEM/WB
	
	signal RD_MEM_WB: std_logic_vector(4 downto 0);
	signal DATA_OUT_MEM_WB: std_logic_vector(31 downto 0);
	signal PC_4_MEM_WB : std_logic_vector(31 downto 0);
	
	--WB
	
	signal DATA_OUT_WB: std_logic_vector(31 downto 0);
		
begin
	
	--IF
	
	pc_reg : REG generic map (n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => IN_PC, OUT_DATA => PC_IF);
	
	pc_adder: ADDER_PC port map( PC => PC_IF, NEW_PC => PC_ADD_4_IF);
	
	pc_mux: process(STALL_s,PC_IF,PC_MOD_IF,B_COND,PC_ADD_4_IF,INSTR_ID)
	begin
		if STALL_s = '1' then
			IN_PC <= PC_IF;
		elsif INSTR_ID = J then
			IN_PC <= PC_MOD_IF;
		elsif INSTR_ID = B then
			if B_COND = '1' then
				IN_PC <= PC_MOD_IF;
			else
				IN_PC <= PC_ADD_4_IF;
			end if;
		else
			IN_PC <= PC_ADD_4_IF;
		end if;
	end process;
	
	IRAM_ADDRESS <= PC_IF;
	STALL_n <= not STALL_s;
	--IF/ID
	
	pc_if_id_reg: REG_en generic map (n => 32) port map (CLK => CLK, EN => STALL_n, RST_n => RST_n, IN_DATA => PC_IF, OUT_DATA => PC_IF_ID); 
	pc_4_if_id_reg: REG_en generic map (n => 32) port map (CLK => CLK, EN => STALL_n, RST_n => RST_n, IN_DATA => PC_ADD_4_IF, OUT_DATA => PC_4_IF_ID); 
	ir_if_id_reg: REG_en generic map (n => 32) port map (CLK => CLK, EN => STALL_n, RST_n => RST_n, IN_DATA => IRAM_DATA, OUT_DATA => IR_IF_ID);
	
	--ID
	
	hz_unit: HAZARD_UNIT port map(RS1 => RS1_ID, RS2 => RS2_ID, RD_ID_EX => RD_ID_EX, INSTR_ID => INSTR_ID, LOAD_INSTR => LOAD_INSTR, STALL => STALL_s);
	STALL <= STALL_s;
	
	RF_bypass: process(RS1_ID, RS2_ID, RD_MEM_WB, DATA_OUT_WB,RF_OUT_1_OUT_ID, RF_OUT_2_ID)
	begin
		if RD_MEM_WB = RS1_ID and RD_MEM_WB /= "00000" then
			BYPASS_OUT_1 <= DATA_OUT_WB;
		else
			BYPASS_OUT_1 <= RF_OUT_1_OUT_ID;
		end if;
		if RD_MEM_WB = RS2_ID and RD_MEM_WB /= "00000"  then
			BYPASS_OUT_2 <= DATA_OUT_WB;
		else
			BYPASS_OUT_2 <= RF_OUT_2_ID;
		end if;
	end process;
	
	fw_id_a: process(FW_ID_MEM_A,FW_ID_WB_A,RF_OUT_1_ID,DATA_OUT_WB,DATA_OUT_EX_MEM)
	begin
		if FW_ID_MEM_A = '1' then
			BRANCH_FW_1 <= DATA_OUT_EX_MEM;
		elsif FW_ID_WB_A = '1' then
			BRANCH_FW_1 <= DATA_OUT_WB;
		else
			BRANCH_FW_1 <= RF_OUT_1_ID;
		end if;
	end process;
	
	fw_id_b: process(FW_ID_MEM_B,FW_ID_WB_B,RF_OUT_2_ID,DATA_OUT_WB,DATA_OUT_EX_MEM)
	begin
		if FW_ID_MEM_B = '1' then
			BRANCH_FW_2 <= DATA_OUT_EX_MEM;
		elsif FW_ID_WB_B = '1' then
			BRANCH_FW_2 <= DATA_OUT_WB;
		else
			BRANCH_FW_2 <= RF_OUT_2_ID;
		end if;
	end process;
	
	branch_adder_inst: BRANCH_ADDER port map(PC => PC_IF_ID, IMMEDIATE => IMM_ID, NEW_PC => PC_MOD_IF);
	branch_comp_inst: BRANCH_COMP port map(IN_1 => BRANCH_FW_1, IN_2 => BRANCH_FW_2, EQ_OUT => B_COND);
	register_file_inst: RF port map(CLK => CLK, RST_n => RST_n, W_EN => RF_W_EN, R_ADDR_1 => RS1_ID, R_ADDR_2 => RS2_ID, W_ADDR => RD_MEM_WB, W_DATA =>DATA_OUT_WB, R_DATA_1 => RF_OUT_1_ID, R_DATA_2 => RF_OUT_2_ID);
	
	FLUSH_ID <= '1' when ((INSTR_ID = B and B_COND = '1') or INSTR_ID = J ) else '0';
	
	FUNC <=(IR_IF_ID(31 downto 25) & IR_IF_ID(14 downto 12)) when (FLUSH_ID_EX = '0' or STALL_s_ff = '1') else (others => '0');
	OPCODE <= IR_IF_ID(6 downto 0) when (FLUSH_ID_EX = '0' or STALL_s_ff = '1') else "0010011";
	INSTRUCTION <= IR_IF_ID(31 downto 7) when (FLUSH_ID_EX = '0' or STALL_s_ff= '1') else (others => '0');
	decoding: DECODING_UNIT port map(instruction_type => INSTR_ID, instruction => INSTRUCTION, RS2 => RS2_ID, RS1 => RS1_ID, RD => RD_ID, IMM => IMM_ID);

	
	
	RF_OUT_1_OUT_ID <= RF_OUT_1_ID when STALL_s = '0' else (others => '0');
	RD_OUT_ID <= RD_ID when STALL_s = '0' else (others => '0');
	IMM_OUT_ID <= IMM_ID when STALL_s = '0' else (others => '0');
	
	--ID/EX	
	
	stall_ff : FF port map (CLK => CLK, RST_n => RST_n, IN_DATA => STALL_s, OUT_DATA => STALL_s_ff);
	flush_id_ex_reg : FF port map (CLK => CLK, RST_n => RST_n, IN_DATA => FLUSH_ID, OUT_DATA => FLUSH_ID_EX);
	rd_id_ex_reg: REG generic map (n => 5) port map (CLK => CLK, RST_n => RST_n, IN_DATA => RD_OUT_ID, OUT_DATA => RD_ID_EX);
	rs1_id_ex_reg: REG generic map (n => 5) port map (CLK => CLK, RST_n => RST_n, IN_DATA => RS1_ID, OUT_DATA => RS1_ID_EX);
	rs2_id_ex_reg: REG generic map (n => 5) port map (CLK => CLK, RST_n => RST_n, IN_DATA => RS2_ID, OUT_DATA => RS2_ID_EX);
	rf_out_1_id_ex_reg: REG generic map (n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => BYPASS_OUT_1, OUT_DATA => RF_OUT_1_ID_EX);
	rf_out_2_id_ex_reg: REG generic map (n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => BYPASS_OUT_2, OUT_DATA => RF_OUT_2_ID_EX);
	imm_id_ex_reg: REG generic map (n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => IMM_OUT_ID, OUT_DATA => IMM_ID_EX);
	pc_id_ex_reg: REG generic map (n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => PC_IF_ID, OUT_DATA => PC_ID_EX);
	pc_4_id_ex_reg: REG generic map (n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => PC_4_IF_ID, OUT_DATA => PC_4_ID_EX);
	
	--EX
	
	forwarding_unit_component: FORWARDING_UNIT port map (RS1_ID => RS1_ID, RS2_ID => RS2_ID, RS1_EX => RS1_ID_EX, RS2_EX => RS2_ID_EX, RS2_MEM => RS2_EX_MEM, RD_EX => RD_ID_EX, RD_MEM => RD_EX_MEM,
														RD_WB => RD_MEM_WB, FW_ID_MEM_A => FW_ID_MEM_A, FW_ID_MEM_B => FW_ID_MEM_B, FW_ID_WB_A => FW_ID_WB_A, FW_ID_WB_B => FW_ID_WB_B,
														FW_EX_MEM_A => FW_EX_MEM_A, FW_EX_MEM_B => FW_EX_MEM_B, FW_EX_WB_A => FW_EX_WB_A, FW_EX_WB_B => FW_EX_WB_B, FW_MEM_WB => FW_MEM_WB);
	
	opa:process(FW_EX_MEM_A, FW_EX_WB_A, RF_OUT_1_ID_EX, DATA_OUT_EX_MEM, DATA_OUT_WB, AUIPC_INSTR_EX)
		begin
			if (FW_EX_MEM_A = '1') then
				ALU_IN1_EX <= DATA_OUT_EX_MEM;
			elsif (FW_EX_WB_A = '1') then
				ALU_IN1_EX <= DATA_OUT_WB;
			elsif (AUIPC_INSTR_EX = '1') then
				ALU_IN1_EX <= PC_ID_EX;
			else
				ALU_IN1_EX <= RF_OUT_1_ID_EX;
			end if;
		end process;
		
	opa_in_proc:process(ALU_IN1_EX, ABS_INSTR)
	begin
		if (ABS_INSTR = '1' and ALU_IN1_EX(31) = '1') then
			OPA_IN <= not ALU_IN1_EX;
		else
			OPA_IN <= ALU_IN1_EX;
		end if;
	end process;
			
	opb:process(FW_EX_MEM_B, FW_EX_WB_B, RF_OUT_2_ID_EX, DATA_OUT_EX_MEM, DATA_OUT_WB, IMM_ID_EX)
		begin
			if (SRA_INSTR = '1') then 
				ALU_IN2_EX(31 downto 5) <= (others => '0');
				ALU_IN2_EX(4 downto 0) <= RS2_ID_EX;
			elsif (I_TYPE_EX = '1') then
				ALU_IN2_EX <= IMM_ID_EX;
			elsif (FW_EX_MEM_B = '1') then
				ALU_IN2_EX <= DATA_OUT_EX_MEM;
			elsif (FW_EX_WB_B = '1') then
				ALU_IN2_EX <= DATA_OUT_WB;
			else
				ALU_IN2_EX <= RF_OUT_2_ID_EX;
			end if;
		end process;
		
	opb_in_proc:process(ALU_IN2_EX, ABS_INSTR, ALU_IN1_EX(31))
	begin
		if (ABS_INSTR = '1' and ALU_IN1_EX(31) = '1') then
			OPB_IN <= x"00000001";
		else
			OPB_IN <= ALU_IN2_EX;
		end if;
	end process;
	
	store_data_proc:process(FW_EX_MEM_B, FW_EX_WB_B, RF_OUT_2_ID_EX, DATA_OUT_EX_MEM, DATA_OUT_WB, IMM_ID_EX)
		begin
			if (FW_EX_MEM_B = '1') then
				STORE_DATA_EX <= DATA_OUT_EX_MEM;
			elsif (FW_EX_WB_B = '1') then
				STORE_DATA_EX <= DATA_OUT_WB;
			else
				STORE_DATA_EX <= RF_OUT_2_ID_EX;
			end if;
		end process;
	
	alu_component: ALU port map (A => OPA_IN, B => OPB_IN, ALU_FUNC => ALU_FUNC, ALU_RESULT => ALU_RESULT_EX);
	
	DATA_OUT_EX <= ALU_RESULT_EX when LUI_INSTR_EX = '0' else IMM_ID_EX;
	
	--EX/MEM
	
	rd_ex_mem_reg: REG generic map (n => 5) port map (CLK => CLK, RST_n => RST_n, IN_DATA => RD_ID_EX, OUT_DATA => RD_EX_MEM);
	rs2_ex_mem_reg: REG generic map (n => 5) port map (CLK => CLK, RST_n => RST_n, IN_DATA => RS2_ID_EX, OUT_DATA => RS2_EX_MEM);
	data_out_ex_reg: REG generic map (n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => DATA_OUT_EX, OUT_DATA => DATA_OUT_EX_MEM);
	store_data_reg: REG generic map (n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => STORE_DATA_EX, OUT_DATA => STORE_DATA);
	pc_4_ex_mem_reg: REG generic map (n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => PC_4_ID_EX, OUT_DATA => PC_4_EX_MEM);
	
	--MEM
	
	STORE_DATA_FW <= STORE_DATA when FW_MEM_WB = '0' else DATA_OUT_WB;
	DRAM_ADDRESS <= DATA_OUT_EX_MEM;
	DRAM_DATA_IN <= STORE_DATA_FW;
	DATA_OUT_MEM <= DRAM_DATA_OUT when MEM_INSTR = '1' else DATA_OUT_EX_MEM;
	
	--MEM/WB
	rd_mem_wb_reg: REG generic map (n => 5) port map (CLK => CLK, RST_n => RST_n, IN_DATA => RD_EX_MEM, OUT_DATA => RD_MEM_WB);
	data_out_mem_wb_reg: REG generic map(n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => DATA_OUT_MEM, OUT_DATA => DATA_OUT_MEM_WB);
	pc_4_mem_wb_reg: REG generic map (n => 32) port map (CLK => CLK, RST_n => RST_n, IN_DATA => PC_4_EX_MEM, OUT_DATA => PC_4_MEM_WB);
	--WB
	DATA_OUT_WB <= PC_4_MEM_WB when JAL_INSTR = '1' else DATA_OUT_MEM_WB;
	
end architecture;