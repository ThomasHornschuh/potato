-- The Potato Processor - A simple processor for FPGAs
-- (c) Kristian Klomsten Skordal 2014 <kristian.skordal@wafflemail.net>
-- Report bugs and issues on <https://github.com/skordal/potato/issues>

library ieee;
use ieee.std_logic_1164.all;

--! @addtogroup CORE
--! @{

--! @brief   Module decoding immediate values from instruction words.
--! @details The RISC-V specification @cite riscv specifies several different instruction formats which contain
--!          immediate values as operands. This module identifies which format belongs to the instruction being
--!          decoded and produces an output word with the correct immediate value.
entity pp_imm_decoder is
	port(
		instruction : in  std_logic_vector(31 downto 2); --! Instruction word
		immediate   : out std_logic_vector(31 downto 0)  --! Decoded immediate value
	);
end entity pp_imm_decoder;

--! @brief Behavioural architecture of the immediate value decoder.
architecture behaviour of pp_imm_decoder is
begin
	--! @brief Decodes and reassembles the immediate value contained in a instruction.
	decode: process(instruction)
	begin
		case instruction(6 downto 2) is
			when b"01101" | b"00101" => -- U type
				immediate <= instruction(31 downto 12) & (11 downto 0 => '0');
			when b"11011" => -- UJ type
				immediate <= (31 downto 20 => instruction(31)) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0';
			when b"11001" | b"00000" | b"00100"  | b"11100"=> -- I type
				immediate <= (31 downto 11 => instruction(31)) & instruction(30 downto 20);
			when b"11000" => -- SB type
				immediate <= (31 downto 12 => instruction(31)) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
			when b"01000" => -- S type
				immediate <= (31 downto 11 => instruction(31)) & instruction(30 downto 25) & instruction(11 downto 7);
			when others =>
				immediate <= (others => '0');
		end case;
	end process decode;
end architecture behaviour;

--! @}
