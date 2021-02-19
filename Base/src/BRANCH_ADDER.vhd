library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BRANCH_ADDER is
	port(	PC : in std_logic_vector(31 downto 0);
			IMMEDIATE : in std_logic_vector(31 downto 0);
			NEW_PC : out std_logic_vector(31 downto 0));
end entity;

architecture BEHAVIORAL of BRANCH_ADDER is
begin
	NEW_PC <= std_logic_vector(unsigned(PC) + unsigned(IMMEDIATE));
end architecture;