library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF is 
	port(	CLK : in std_logic;
			RST_n : in std_logic;
			W_EN : in std_logic;
			R_ADDR_1 : in std_logic_vector(4 downto 0);
			R_ADDR_2 : in std_logic_vector(4 downto 0);
			W_ADDR : in std_logic_vector(4 downto 0);
			W_DATA : in std_logic_vector(31 downto 0);
			R_DATA_1 : out std_logic_vector(31 downto 0);
			R_DATA_2 : out std_logic_vector(31 downto 0));
end entity;

architecture BEHAVIORAL of RF is 

	type reg_type is array(31 downto 0) of std_logic_vector(31 downto 0);
	signal reg_file :reg_type;
	
begin
	
	R_DATA_1 <= reg_file(to_integer(unsigned(R_ADDR_1)));
	R_DATA_2 <= reg_file(to_integer(unsigned(R_ADDR_2)));
	
	write_p : process(CLK, RST_n)
	begin
		if RST_n = '0' then
			for i in 0 to 31 loop
				reg_file(i) <= (others => '0');
			end loop;
		elsif CLK'event and CLK = '1' then 
			reg_file(0) <= (others => '0');
			if W_EN = '1' and W_ADDR /= "00000" then 
				reg_file(to_integer(unsigned(W_ADDR))) <= W_DATA;
			end if;
		end if;
	end process;

end architecture;
