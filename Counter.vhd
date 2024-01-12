library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity Counter is
    Port(
        clk,rst : in std_logic;
        Output: out std_logic_vector(1 downto 0)
    );
end Counter;

architecture Behavioral of Counter is
signal temp_out: std_logic_vector(1 downto 0);

begin
process(rst, clk)
begin
    if (rst = '1') then temp_out <= "00";
    elsif(clk'event and clk = '1') then temp_out <= temp_out + 1;
    end if;
    Output <= temp_out;
end process;

end Behavioral;
