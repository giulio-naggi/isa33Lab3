library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FF is 
	port(CLK		: in std_logic;
		RST_n		: in std_logic;
		IN_DATA		: in std_logic;
		OUT_DATA	: out std_logic);
end entity;

architecture behavioral of FF is
begin
	reg: process (CLK,RST_n)
    begin  -- process IR_P
		if RST_n = '0' then
			OUT_DATA <= '0';
		elsif CLK'event and CLK = '1' then  -- rising clock edge
			OUT_DATA <= IN_DATA;
		end if;
    end process;
end architecture;