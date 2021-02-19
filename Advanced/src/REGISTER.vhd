library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG is 
	generic (n : integer := 8);
	port(	CLK: in std_logic;
			RST_n : in std_logic;
			IN_DATA: in std_logic_vector(n-1 downto 0);
			OUT_DATA: out std_logic_vector(n-1 downto 0));
end entity;

architecture behavioral of REG is
begin
	reg: process (CLK)
    begin
		if RST_n = '0' then
			OUT_DATA <= (others => '0');
		elsif CLK'event and CLK = '1' then  -- rising clock edge
			OUT_DATA <= IN_DATA;
        end if;
    end process;
end architecture;