-- This code was originally from: https://github.com/ninadwaingankar/Random-number-generator-using-VHDL-on-FPGA/blob/main/random4.vhd
-- Some changes were made to adjust thhe component to the current project.
-- Pseudo-random-number-generator for 4 bits
----------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY prng_m IS
	GENERIC (width : INTEGER := 4);
	PORT (
		push : IN STD_LOGIC; --push button to generate random no
		clk : IN STD_LOGIC; --12Mhz clock 
		random_num : OUT STD_LOGIC_VECTOR (width - 1 DOWNTO 0) --output binary led
	);
END prng_m;

ARCHITECTURE Behavioral OF random4 IS
	SIGNAL divider : STD_LOGIC_VECTOR(23 DOWNTO 0); --clock divider signal
BEGIN
	PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN
			divider <= divider + '1';
		END IF;
	END PROCESS;

	PROCESS (divider(23), push)
		VARIABLE rand_temp : STD_LOGIC_VECTOR(width - 1 DOWNTO 0) := (width - 1 => '1', OTHERS => '0');
		VARIABLE temp : STD_LOGIC := '0';
	BEGIN
		IF (push = '1') THEN
			IF (rising_edge(divider(21))) THEN
				--for random no generation
				temp := rand_temp(width - 1) XOR rand_temp(width - 2);
				rand_temp(width - 1 DOWNTO 1) := rand_temp(width - 2 DOWNTO 0);
				rand_temp(0) := temp;
			END IF;
		END IF;

		--developed by Ninad Waingankar	
		random_num <= rand_temp;
	END PROCESS;
END Behavioral;