-- This code was originally from stackoverflow : https://stackoverflow.com/questions/43081067/pseudo-random-number-generator-using-lfsr-in-vhdl
-- Some changes were made to adjust thhe component to the current project.
-- Pseudo-random-number-generator for 3 bits
----------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY prng3 IS
   PORT (
      clock : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      en : IN STD_LOGIC;
      seed : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
      Q : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
      check : OUT STD_LOGIC

   );

END prng3;

ARCHITECTURE Behavioral OF prng IS

   --signal temp: STD_LOGIC;
   SIGNAL Qt : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";

BEGIN

   PROCESS (clock)
      VARIABLE tmp : STD_LOGIC := '0';
   BEGIN

      IF rising_edge(clock) THEN
         IF (reset = '1') THEN
            -- credit to QuantumRipple for pointing out that this should not
            -- be reset to all 0's, as you will enter an invalid state
            Qt <= seed;
         ELSIF en = '1' THEN
            tmp := XOR Qt(1) XOR Qt(0);
            Qt <= tmp & Qt(2 DOWNTO 1);
         END IF;

      END IF;
   END PROCESS;
   -- check <= temp;
   check <= Qt(2);
   Q <= Qt;

END Behavioral;