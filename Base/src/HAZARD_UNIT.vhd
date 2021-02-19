library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RISC.all;

entity HAZARD_UNIT is
	port(	RS1 : in std_logic_vector(4 downto 0);
			RS2 : in std_logic_vector(4 downto 0);
			RD_ID_EX : in std_logic_vector(4 downto 0);
			LOAD_INSTR : in std_logic;
			INSTR_ID : in INSTR_TYPE;
			STALL : out std_logic);
end entity;

architecture BEHAVIORAL of HAZARD_UNIT is

	signal STALL_BRANCH : std_logic;
	signal STALL_LOAD : std_logic;

begin

	load: process(LOAD_INSTR, RD_ID_EX, RS1, RS2)
	begin
		if (LOAD_INSTR = '1') and ((RD_ID_EX = RS1) or (RD_ID_EX = RS2)) and (RD_ID_EX /= "00000") then
			STALL_LOAD <= '1';
		else
			STALL_LOAD <= '0';
		end if;
	end process;
	
	branch: process(RS1, RS2, RD_ID_EX, INSTR_ID)
	begin
		if (INSTR_ID = B) and ((RD_ID_EX = RS1) or (RD_ID_EX = RS2)) and (RD_ID_EX /= "00000") then
			STALL_BRANCH <= '1';
		else 
			STALL_BRANCH <= '0';
		end if;
	end process;
	
	STALL <= STALL_LOAD or STALL_BRANCH;
	
end architecture;