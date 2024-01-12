library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataSelector4bits is
  Port ( 
    S_IN: in std_logic_vector(15 downto 0);
    P_OUT: out std_logic_vector(3 downto 0);
    clk: in std_logic_vector(1 downto 0)
  );
end DataSelector4bits;

architecture Behavioral of DataSelector4bits is

begin
    process(clk)
    begin
        if clk = "00" then
            P_OUT <= S_IN(15 downto 12);
        elsif clk = "01" then
            P_OUT <= S_IN(11 downto 8);
        elsif clk = "10" then
            P_OUT <= S_IN(7 downto 4);
        elsif clk = "11" then
            P_OUT <= S_IN(3 downto 0);
        end if;
    end process;

end Behavioral;
