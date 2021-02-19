library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DRAM is
port(
	CLK : in std_logic;
	ADDRESS : in std_logic_vector(31 downto 0);
	DATA_IN : in std_logic_vector(31 downto 0);
	RST : in std_logic;
	ENABLE : in std_logic;
	READ_WRITE_n : in std_logic;
	DATA_OUT : out std_logic_vector(31 downto 0));
end entity;

architecture BEHAVIORAL of DRAM is
	
	type mem is array(1023 downto 0) of std_logic_vector(7 downto 0);
	signal DRAM_MEM : mem;
	
begin
	write_p: process(CLK, RST)
		variable clean_addr : std_logic_vector(31 downto 0);
		variable address_var : integer;
	begin
		if RST = '0' then
			DRAM_MEM <= (others => (others => '0'));
			DRAM_MEM(16#0#) <= x"0A"; --X"0000000A" 
			
			DRAM_MEM(16#4#) <= x"D1"; --X"FFFFFFD1"
			DRAM_MEM(16#5#) <= x"FF";
			DRAM_MEM(16#6#) <= x"FF";
			DRAM_MEM(16#7#) <= x"FF";
			
			DRAM_MEM(16#8#) <= x"16"; --X"00000016"
			
			DRAM_MEM(16#C#) <= x"FD"; --X"FFFFFFFD"
			DRAM_MEM(16#D#) <= x"FF";
			DRAM_MEM(16#E#) <= x"FF";
			DRAM_MEM(16#F#) <= x"FF";
			
			DRAM_MEM(16#10#) <= x"0F"; --X"0000000F"
			
			DRAM_MEM(16#14#) <= x"1B"; --X"0000001B"
			
			DRAM_MEM(16#18#) <= x"FC"; --X"FFFFFFFC"
			DRAM_MEM(16#19#) <= x"FF";
			DRAM_MEM(16#1A#) <= x"FF";
			DRAM_MEM(16#1B#) <= x"FF";
			
		elsif CLK'event and CLK = '1' then
			if ENABLE = '1' then
				if READ_WRITE_n = '0' then
					clean_addr := ADDRESS(31 downto 2) & "00";
					address_var := to_integer(unsigned(clean_addr))- 16#2000#;
					DRAM_MEM(address_var+3) <= DATA_IN(31 downto 24);
					DRAM_MEM(address_var+2) <= DATA_IN(23 downto 16);
					DRAM_MEM(address_var+1) <= DATA_IN(15 downto 8);
					DRAM_MEM(address_var) <= DATA_IN(7 downto 0);
				end if;
			end if;
		end if;
	end process;
	
	read_p: process(ADDRESS, READ_WRITE_n,DRAM_MEM,ENABLE)
		variable clean_addr : std_logic_vector(31 downto 0);
		variable address_var : integer;
	begin
		if ENABLE = '1' and READ_WRITE_n = '1' then
			
			clean_addr := ADDRESS(31 downto 2) & "00";
			address_var := to_integer(unsigned(clean_addr)) - 16#2000#;
			DATA_OUT <= DRAM_MEM(address_var+3) & DRAM_MEM(address_var+2) & DRAM_MEM(address_var+1) & DRAM_MEM(address_var);
		end if;
	end process;

end architecture;