library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity tb_majority_trigger is
end entity tb_majority_trigger;

architecture sim of tb_majority_trigger is
	signal paddles : std_logic_vector(7 downto 0) := (others => '0'); 
	signal trigger : std_logic;
	signal multiplicity : unsigned(3 downto 0); 

	constant TB_THRESHOLD : natural := 5;
	constant TB_WIDTH : natural := 8;	
begin	
	dut : entity work.majority_trigger
		generic map (
			THRESHOLD => TB_THRESHOLD,
			WDTH => TB_WIDTH
		) 
		port map (
			paddles => paddles,
			trigger => trigger, 
			multiplicity => multiplicity
		);

	stimulus : process
		variable expected_count : natural;
	begin 
		for pattern in 0 to 256 loop
			paddles <= std_logic_vector(to_unsigned(pattern, 8)); 
			wait for 10 ns; 

			expected_count := 0; 
			for i in paddles'range loop
				if paddles(i) = '1' then
					expected_count := expected_count + 1;
				end if;
			end loop;

			assert to_integer(multiplicity) = expected_count
				report "Fail: pattern" 
				severity failure;

			if expected_count >= TB_THRESHOLD then
				assert trigger = '1'
					report "fail"
					severity failure;
			else 
				assert trigger = '0'
					report "FAIL"
					severity failure;
			end if;
		end loop;

		report "ALL TESTS PASSED";
		wait; 
	end process stimulus;

end architecture sim;
