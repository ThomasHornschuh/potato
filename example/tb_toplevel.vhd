-- The Potato Processor - SoC design for the Arty FPGA board
-- (c) Kristian Klomsten Skordal 2016 <kristian.skordal@wafflemail.net>
-- Report bugs and issues on <https://github.com/skordal/potato/issues>

library ieee;
use ieee.std_logic_1164.all;

entity tb_toplevel is
end entity tb_toplevel;

architecture testbench of tb_toplevel is

	signal clk : std_logic := '0';
	constant clk_period : time :=31.25 ns;

	signal I_RESET : std_logic := '0';

	signal gpio_pins : std_logic_vector(7 downto 0);

	signal uart0_txd_pin,led1 : std_logic;
	signal uart0_rxd : std_logic := '1';

--	signal uart1_txd : std_logic;
--	signal uart1_rxd : std_logic := '1';

begin

	uut: entity work.toplevel
		port map(
			clk => clk,
			i_reset => I_RESET,
			gpio_pins => gpio_pins,
			uart0_txd_pin => uart0_txd_pin,
			uart0_rxd => uart0_rxd,
			led1 => led1
	--		uart1_txd => uart1_txd,
	--		uart1_rxd => uart1_rxd
		);

	clock: process
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process clock;

	stimulus: process
	begin
		I_RESET <= '1';
		wait for clk_period * 4;
		I_RESET <= '0';

		wait;
	end process stimulus;

end architecture testbench;
