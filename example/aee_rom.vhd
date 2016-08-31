----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:39:47 08/08/2016 
-- Design Name: 
-- Module Name:    aee_rom - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


library STD;
use STD.textio.all;

use work.pp_utilities.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aee_rom is
   generic (RamFileName : string := "hello.mem";
	         MemDepth : natural );
   Port (  AddrA : in  STD_LOGIC_VECTOR (log2(MemDepth)-1 downto 0); 
           DOutA : out  STD_LOGIC_VECTOR (31 downto 0);
           CLKA: in  STD_LOGIC);
end aee_rom;

architecture Behavioral of aee_rom is

type tRam is array (0 to MemDepth-1) of STD_LOGIC_VECTOR (31 downto 0);
-- Design time code...
 
impure function InitFromFile  return tRam is
FILE RamFile : text is in RamFileName;
variable RamFileLine : line;
variable word : STD_LOGIC_VECTOR(31 downto 0);
variable r : tRam;

begin
  for I in tRam'range loop
    if not endfile(RamFile) then
      readline (RamFile, RamFileLine);
      hread (RamFileLine, word);
	   r(I) :=  word;
	 else
 	   r(I) := x"00000013";  -- NOP
    end if;		
  end loop;
  return r; 
end function;

signal rom : tRam:= InitFromFile;

begin

   process(clkA) begin
      if rising_edge(CLKA) then		  
		    douta <= rom(to_integer(unsigned(AddrA)));		 
     end if; 		  
  end process;   


end Behavioral;

