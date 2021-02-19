library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RISC.all;


entity DECODING_UNIT is
    port (	INSTRUCTION_TYPE : in instr_type;
			INSTRUCTION      : in std_logic_vector(31 downto 7);
			RS2              : out std_logic_vector(4 downto 0);
			RS1              : out std_logic_vector(4 downto 0);
			RD               : out std_logic_vector(4 downto 0);
			IMM              : out std_logic_vector(31 downto 0));
end DECODING_UNIT;

architecture BEH of DECODING_UNIT is
begin 
	process(instruction, instruction_type) is
	begin
		case instruction_type is
			when R =>		rs1 				<=	instruction(19 downto 15);
							rs2 				<=	instruction(24 downto 20);
							rd 					<=	instruction(11 downto 7);
							imm					<=	(others => instruction(31));
			when I =>		rs1 				<=	instruction(19 downto 15);
							rs2 				<=	(others => '0');
							rd 					<=	instruction(11 downto 7);
							imm 				<=  (others => instruction(31));
							imm(11 downto 0) 	<=	instruction(31 downto 20);
			when S =>		rs1 				<=	instruction(19 downto 15);
							rs2 				<=	instruction(24 downto 20);
							rd 					<=	(others => '0');
							imm 				<=  (others => instruction(31));
							imm(11 downto 5) 	<=	instruction(31 downto 25);
							imm(4 downto 0) 	<=	instruction(11 downto 7);
			when B =>		rs1 				<=	instruction(19 downto 15);
							rs2 				<=	instruction(24 downto 20);
							rd 					<=	(others => '0');
							imm 				<=  (others => instruction(31));
							imm(0)			 	<=	'0';
							imm(11)				<= 	instruction(7);
							imm(10 downto 5) 	<=	instruction(30 downto 25);
							imm(4 downto 1) 	<= 	instruction(11 downto 8);
			when U =>		rs1 				<=	(others => '0');
							rs2 				<=	(others => '0');
							rd 					<=	instruction(11 downto 7);
							imm 				<=  (others => '0');
							imm(31 downto 12) 	<=	instruction(31 downto 12);
			when J =>		rs1 				<=	(others => '0');
							rs2 				<=	(others => '0');
							rd 					<=	instruction(11 downto 7);
							imm 				<=  (others => instruction(31));
							imm(20)			 	<=	instruction(31);
							imm(19 downto 12)	<= 	instruction(19 downto 12);
							imm(11)			 	<=	instruction(20);
							imm(10 downto 1) 	<= 	instruction(30 downto 21);
							imm(0)				<= 	'0';
			when others =>	rs1 				<=  (others => '0');
							rs2 				<=  (others => '0');
							rd 					<=  (others => '0');
							imm					<=  (others => '0');
		end case;
	end process;
	
end beh;
