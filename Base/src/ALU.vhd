library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port( 	A: in std_logic_vector(31 downto 0);
			B: in std_logic_vector(31 downto 0);
			ALU_func: in std_logic_vector(2 downto 0);
			ALU_result: out std_logic_vector(31 downto 0));
end entity;

architecture behavioral of ALU is 

begin

	alu_proc: process (A,B,ALU_func)
		variable shift_tmp: std_logic_vector(31 downto 0);
	begin
		case ALU_func is
			when "000" => -- ADD/ADDI/AUIPC/LUI
				ALU_result <= std_logic_vector(unsigned(A) + unsigned(B));
			when "001" => -- SRAI
				shift_tmp := A;
				for I in 0 to 31 loop
					exit when I = to_integer(unsigned(B));
                    shift_tmp := shift_tmp(31) & shift_tmp(31 downto 1);
                end loop;
				ALU_result <= shift_tmp;
			when "010" => -- ANDI
				ALU_result <= A AND B;
			when "011" => -- XOR
				ALU_result <= A XOR B;
			when "100" => -- SLT
				if A < B then
					ALU_result <= std_logic_vector(to_unsigned(1,32));
				else 
					ALU_result <= (others => '0');
				end if;
			when others => 
				ALU_result <= (others => '0');
		end case;
	end process;
	
end architecture;