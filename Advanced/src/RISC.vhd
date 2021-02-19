library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package RISC is

	type INSTR_TYPE is (R,I,S,B,U,J);
	
	--OPCODES
	constant LUI_OP : std_logic_vector(6 downto 0)   := "0110111";
	constant AUIPC_OP : std_logic_vector(6 downto 0) := "0010111";
	constant I_TYPE_OP : std_logic_vector(6 downto 0)  := "0010011";
	constant R_TYPE_OP : std_logic_vector(6 downto 0)   := "0110011";
	constant BEQ_OP : std_logic_vector(6 downto 0)   := "1100011";
	constant LW_OP : std_logic_vector(6 downto 0)    := "0000011";
	constant JAL_OP : std_logic_vector(6 downto 0)   := "1101111";
	constant SW_OP : std_logic_vector(6 downto 0)    := "0100011";
	
	--FUNC

	constant ADDI_FUNC : std_logic_vector(9 downto 0)  := "0000000000";
	constant ADD_FUNC : std_logic_vector(9 downto 0)   := "0000000000";
	constant SRAI_FUNC : std_logic_vector(9 downto 0)  := "0100000101";
	constant ANDI_FUNC : std_logic_vector(9 downto 0)  := "0000000111";
	constant XOR_FUNC : std_logic_vector(9 downto 0)   := "0000000100";
	constant SLT_FUNC : std_logic_vector(9 downto 0)   := "0000000010";
	
	--ABS_FUNC (R_TYPE, rs2 = 00000)
	constant ABS_FUNC : std_logic_vector(9 downto 0)  := "0000001000";
	
	

end package;