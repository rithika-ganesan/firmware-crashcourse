library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- we did not have this before. it contains signed and unsigned arrays of STD_LOGIC

entity majority_trigger is
	generic (
		THRESHOLD : natural := 3; -- natural is a pre-defined subtype of integers: [0, largest integer]
		WDTH : natural := 3
	);
	port (
		paddles : in std_logic_vector(WDTH-1 downto 0); -- is it always 3 downto 0? what about like 5 downto i
		prescale_sel : in std_logic_vector(1 downto 0);
		trigger : out std_logic;
       		min_mult : out unsigned(2 downto 0);	
		multiplicity : out unsigned(2 downto 0) -- hit count (0-4) needs 3 bits.	
	);
end entity majority_trigger;

-- what is rtl? why do we call it that? can we use anything else? 

architecture rtl of majority_trigger is 
	signal hit_count : unsigned(2 downto 0) := (others => '0');
begin 
	count_hits : process(all) -- what is all?
		variable count : unsigned(2 downto 0); 
	begin 
		count := (others => '0'); -- set every bit of count to '0', regardless of the number of bits 

		for i in paddles'range loop
			if paddles(i) = '1' then
				count := count + 1;
			end if;
		end loop;

		hit_count <= count;
	end process count_hits;

	multiplicity <= hit_count; 
-- why do we need a signal? why can't multiplicity be directly linked to the end of the process?

	--trigger <= '1' when hit_count >= THRESHOLD else '0';
	with prescale_sel select
		min_mult <= to_unsigned(1, 3) when "00",
			    to_unsigned(2, 3) when "01",
			    to_unsigned(3, 3) when "10",
			    to_unsigned(4, 3) when others;

	trigger <= '1' when hit_count >= min_mult else '0';

end architecture rtl; 
