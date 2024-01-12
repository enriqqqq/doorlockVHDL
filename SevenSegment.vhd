library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSegment is
  Port ( 
    S_IN: in std_logic_vector(3 downto 0);
    S_OUT: out std_logic_vector(7 downto 0)
  );
end SevenSegment;

architecture Behavioral of SevenSegment is

begin
    process(S_IN)
    begin
        case(S_IN) is
                                  -- hgfedcba
            when "0000" => S_OUT <= "11000000"; -- 0
            when "0001" => S_OUT <= "11111001"; -- 1
            when "0010" => S_OUT <= "10100100"; -- 2
            when "0011" => S_OUT <= "10110000"; -- 3
            when "0100" => S_OUT <= "10011001"; -- 4
            when "0101" => S_OUT <= "10010010"; -- 5
            when "0110" => S_OUT <= "10000010"; -- 6
            when "0111" => S_OUT <= "11111000"; -- 7
            when "1000" => S_OUT <= "10000000"; -- 8
            when "1001" => S_OUT <= "10010000"; -- 9
            when "1010" => S_OUT <= "10001000"; -- A
            when "1011" => S_OUT <= "10000011"; -- B
            when "1100" => S_OUT <= "11000110"; -- C
            when "1101" => S_OUT <= "10100001"; -- D
            when "1110" => S_OUT <= "10000110"; -- E
            when "1111" => S_OUT <= "10001110"; -- F
            when others => S_OUT <= "11111111";
        end case;
    end process;
end Behavioral;
