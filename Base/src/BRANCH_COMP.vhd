library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BRANCH_COMP is
	port(	IN_1 : in std_logic_vector(31 downto 0);
			IN_2 : in std_logic_vector(31 downto 0);
			EQ_OUT : out std_logic);
end entity;

architecture BEHAVIORAL of BRANCH_COMP is
begin
	eq_p : process(IN_1,IN_2)
	begin
		if IN_1 = IN_2 then
			EQ_OUT <= '1';
		else 
			EQ_OUT <= '0';
		end if;
	end process;
end architecture;