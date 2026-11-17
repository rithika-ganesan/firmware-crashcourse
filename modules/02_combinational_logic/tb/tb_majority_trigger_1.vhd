library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity tb_majority_trigger is
end entity tb_majority_trigger;

architecture sim of tb_majority_trigger is
	signal paddles : std_logic_vector(3 downto 0) := (others => '0');
        signal prescale_sel : std_logic_vector(1 downto 0) := (others => '0');	
	signal trigger : std_logic;
	signal min_mult : unsigned(2 downto 0);
	signal multiplicity : unsigned(2 downto 0); 

	constant TB_THRESHOLD : natural := 3;
	constant TB_WIDTH : natural := 4;	
begin	
	dut : entity work.majority_trigger
		generic map (
			THRESHOLD => TB_THRESHOLD,
			WDTH => TB_WIDTH
		) 
		port map (
			paddles => paddles,
			trigger => trigger, 
			prescale_sel => prescale_sel,
			min_mult => min_mult,
			multiplicity => multiplicity
		);

	stimulus : process
		variable expected_count : natural;
	begin 
		for pattern in 0 to 15 loop
			paddles <= std_logic_vector(to_unsigned(pattern, 4)); 
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
	
			for j in 0 to 3 loop
				prescale_sel <= std_logic_vector(to_unsigned(j, 2)); 
				wait for 5 ns;
		
				assert to_integer(min_mult) = j + 1
					report "fail: j and min_mult not equal" 
					severity failure;
					
				if expected_count >= j + 1 then
					assert trigger = '1'
						report "fail"
						severity failure;
				else 
					assert trigger = '0'
						report "FAIL"
						severity failure;
				end if;
			end loop; 
		end loop;

		report "ALL TESTS PASSED";
		wait; 
	end process stimulus;

end architecture sim;
