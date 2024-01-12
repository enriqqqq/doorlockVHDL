library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Clock is
  generic (
    COUNT_VALUE : integer := 78124  -- Default count value 640 Hz
  );
  Port ( 
    clk_in: in std_logic;
    clk_out: out std_logic
  );
end Clock;

architecture Behavioral of Clock is
  signal count: integer := 0;
  signal b: std_logic := '0';

begin
  process(clk_in)
  begin
    if rising_edge(clk_in) then
      count <= count + 1;
      if count = COUNT_VALUE then
        b <= not b;
        count <= 0;
      end if;
    end if;
    clk_out <= b;
  end process;
end Behavioral;
