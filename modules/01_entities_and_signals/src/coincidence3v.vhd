-- coincidence3v.vhd
--
-- A three-channel coincidence unit
--
-- Physics context: two scintillator paddles sit above and below a tracking
-- chamber. A cosmic muon passing through the apparatus fires BOTH
-- photomultipliers within the same clock cycle; ambient gamma background
-- usually fires only one. Requiring the coincidence (AND) of the two
-- discriminated PMT signals is the oldest trigger in the book.
--
-- This file demonstrates the two halves of every VHDL design unit:
--   * the ENTITY      - the black-box view: name + ports (like a function
--                       signature, or a chip's pinout)
--   * the ARCHITECTURE - what's inside the box
--
library ieee;
use ieee.std_logic_1164.all;

entity coincidence3v is
  port (
    pmt_a   : in  std_logic;  -- discriminated pulse from the top paddle
    pmt_b   : in  std_logic;  -- discriminated pulse from the bottom paddle
    pmt_c   : in  std_logic; 
    veto    : in  std_logic;
    trigger : out std_logic   -- high when both fire together
  );
end entity coincidence3v;

architecture rtl of coincidence3v is
begin

  -- A CONCURRENT SIGNAL ASSIGNMENT. This is not a statement that "runs";
  -- it describes a physical AND gate whose inputs are permanently soldered
  -- to pmt_a and pmt_b. The gate is always there, always computing.
  trigger <= pmt_a and pmt_b and pmt_c and not veto;

end architecture rtl;
