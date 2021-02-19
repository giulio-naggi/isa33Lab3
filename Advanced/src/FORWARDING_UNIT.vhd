library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.RISC.all;


entity FORWARDING_UNIT is

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
	end FORWARDING_UNIT;

architecture behavioral of FORWARDING_UNIT is

begin

	FW_EX_MEM_PROC: process(RS1_EX, RS2_EX, RD_MEM)
	
		begin
		
			if (RD_MEM = RS1_EX) and (RS1_EX /= "00000") then
				FW_EX_MEM_A <= '1';
			else
				FW_EX_MEM_A <= '0';
			end if;
			
			if (RD_MEM = RS2_EX) and (RS2_EX /= "00000") then
				FW_EX_MEM_B <= '1';
			else
				FW_EX_MEM_B <= '0';
			end if;
			
		end process;

	FW_EX_WB_PROC: process(RS1_EX, RS2_EX, RD_WB)
	
		begin
		
			if (RD_WB = RS1_EX) and (RS1_EX /= "00000") then
				FW_EX_WB_A <= '1';
			else
				FW_EX_WB_A <= '0';
			end if;
			
			if (RD_WB = RS2_EX) and (RS2_EX /= "00000") then
				FW_EX_WB_B <= '1';
			else
				FW_EX_WB_B <= '0';
			end if;
			
		end process;
		
	FW_MEM_WB_PROC: process(RS2_MEM, RD_WB)
	
		begin
		
			if (RD_WB = RS2_MEM) and (RS2_MEM /= "00000") then
				FW_MEM_WB <= '1';
			else
				FW_MEM_WB <= '0';
			end if;
		
		end process;
	
	FW_ID_MEM_PROC: process(RS1_ID, RS2_ID, RD_MEM)
	
		begin
		
			if (RD_MEM = RS1_ID) and (RS1_ID /= "00000") then
				FW_ID_MEM_A <= '1';
			else
				FW_ID_MEM_A <= '0';
			end if;
		
			if (RD_MEM = RS2_ID) and (RS2_ID /= "00000") then
				FW_ID_MEM_B <= '1';
			else
				FW_ID_MEM_B <= '0';
			end if;
		
		end process;
		
	FW_ID_WB_PROC: process(RS1_ID, RS2_ID, RD_WB)
	
		begin
		
			if (RD_WB = RS1_ID) and (RS1_ID /= "00000") then
				FW_ID_WB_A <= '1';
			else
				FW_ID_WB_A <= '0';
			end if;
			
			if (RD_WB = RS2_ID) and (RS2_ID /= "00000") then
				FW_ID_WB_B <= '1';
			else
				FW_ID_WB_B <= '0';
			end if;
		
		end process;
		
	
end architecture;