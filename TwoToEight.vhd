library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TwoToEight is
    Port(
      digits: in integer;
      D_IN: in std_logic_vector(1 downto 0);
      D_OUT: out std_logic_vector(7 downto 0)  
    );
end TwoToEight;

architecture Behavioral of TwoToEight is
begin
    process(digits, D_IN)
        begin
        case(digits) is
            when 1 =>
                case(D_IN) is
                    when "00" => D_OUT <= "11111110";
                    when others => D_OUT <= "11111111";
                end case;
            when 2 =>
                case(D_IN) is
                    when "00" => D_OUT <= "11111110";
                    when "01" => D_OUT <= "11111101";
                    when others => D_OUT <= "11111111";
                end case;
            when 3 =>
                case(D_IN) is
                    when "00" => D_OUT <= "11111110";
                    when "01" => D_OUT <= "11111101";
                    when "10" => D_OUT <= "11111011";
                    when others => D_OUT <= "11111111";
                end case;
            when 4 =>
                case(D_IN) is
                    when "00" => D_OUT <= "11111110";
                    when "01" => D_OUT <= "11111101";
                    when "10" => D_OUT <= "11111011";
                    when "11" => D_OUT <= "11110111";
                    when others => D_OUT <= "11111111";
                end case;
            when 8 =>
                D_OUT <= "00000000";
            when others =>
                D_OUT <= "11111111";
        end case;
    end process;       
end Behavioral;
