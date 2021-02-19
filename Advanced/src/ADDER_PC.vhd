library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ADDER_PC is
  port (PC      : in std_logic_vector(31 downto 0);
		NEW_PC : out std_logic_vector(31 downto 0));
end ADDER_PC;

architecture BEH of ADDER_PC is
begin 

	NEW_PC <= std_logic_vector(unsigned(pc)+to_unsigned(4,32));
	
end BEH;
