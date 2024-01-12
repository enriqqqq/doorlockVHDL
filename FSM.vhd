library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM is
  Port ( 
    key_pushed: in std_logic;
    clk: in std_logic;
    rst: in std_logic;
    kypd_out: in std_logic_vector(3 downto 0);
    btnl: in std_logic;
    s_a: out std_logic;
    s_b: out std_logic;
    s_c: out std_logic;
    s_lini: out std_logic;
    s_uini: out std_logic;
    unlocked_s: out std_logic;
    chnge_pass: out std_logic;
    usr_input: out std_logic_vector(15 downto 0);
    attmpts: out integer
  );
end FSM;

architecture Behavioral of FSM is
    type State_type is (L_INI, L_A, L_B, L_C, L_CMPR, U_INI, U_A, U_B, U_C, U_D, U_CHNG);
    signal state: State_type := L_INI;
    signal password: std_logic_vector(15 downto 0):= "0000000000000000"; -- default password
    signal user_input: std_logic_vector(15 downto 0);
    signal attempts: integer := 0;
    signal count_delay: integer := 0;
    signal delay_flag: std_logic;
begin
process(clk, rst)
    begin
        if(rising_edge(clk)) then
            ---- Debug States ----
            case(state) is
                when L_INI =>
                    s_lini <= '1';
                when L_A =>
                    s_a <= '1';
                when L_B =>
                    s_b <= '1';
                when L_C =>
                    s_c <= '1';
                when U_INI =>
                    s_uini <= '1';
                when L_CMPR =>
                when U_A =>
                when U_B =>
                when U_C =>
                when U_D =>
                when U_CHNG =>
            end case;
            
            if state = U_INI then
                attempts <= 8;
                user_input <= "1000100010001000";
            end if;
            
            if state = U_A or state = U_B or state = U_C or state = U_D or state = U_CHNG then
                chnge_pass <= '1';
            else
                chnge_pass <= '0';
            end if;
            
            -- delay before changing password
            if state = U_CHNG then
                if count_delay = 100 then
                    count_delay <= 0;
                    
                    -- change password
                    password <= user_input;
                    state <= U_INI;
                    attempts <= 0;
                else
                    count_delay <= count_delay + 1;
                end if;
            end if;
            
            -- delay before comparing
            if state = L_CMPR then
                if count_delay = 100 then
                    count_delay <= 0;
                    
                    -- check password
                    if user_input = password then
                        state <= U_INI; -- unlocked
                        unlocked_s <= '1';
                    else
                        state <= L_INI; -- locked
                        s_lini <= '0';
                        s_a <= '0';
                        s_b <= '0';
                        s_c <= '0';
                        s_uini <= '0';
                        attempts <= 0;
                    end if; 
                else
                    count_delay <= count_delay + 1;
                end if;
            end if;
            
            -- listen to inputs
            if rst = '1' then
                -- BTNU resets user input and locks the door
                user_input <= "0000000000000000";
                state <= L_INI;
                unlocked_s <= '0';
                s_lini <= '0';
                s_a <= '0';
                s_b <= '0';
                s_c <= '0';
                s_uini <='0';
                attempts <= 0;
                delay_flag <= '0';
                count_delay <= 0;
            elsif delay_flag = '1' then
                -- delay so keypad press is exactly 1 cycle
                count_delay <= count_delay + 1;
                if count_delay = 100 then
                    delay_flag <= '0';
                    count_delay <= 0;
                end if;
            elsif key_pushed = '1' then
                ---- Main state ----
                case(state) is
                    ---- locked state ----
                    when L_INI =>
                        user_input(15 downto 12) <= kypd_out;
                        state <= L_A;
                        attempts <= attempts + 1;
                        delay_flag <= '1';
                    when L_A =>
                        user_input(11 downto 8) <= kypd_out;
                        state <= L_B;
                        attempts <= attempts + 1;
                        delay_flag <= '1';
                    when L_B =>
                        user_input(7 downto 4) <= kypd_out;
                        state <= L_C;
                        attempts <= attempts + 1;
                        delay_flag <= '1';
                    when L_C =>
                        user_input(3 downto 0) <= kypd_out;
                        state <= L_CMPR;
                        attempts <= attempts + 1;
                    when L_CMPR =>
                        state <= L_CMPR;
                        
                    ---- unlocked state ----                
                    when U_INI =>
                        state <= U_INI;
                    when U_A =>
                        user_input(15 downto 12) <= kypd_out;
                        state <= U_B;
                        attempts <= attempts + 1;
                        delay_flag <= '1';
                    when U_B =>
                        user_input(11 downto 8) <= kypd_out;
                        state <= U_C;
                        attempts <= attempts + 1;
                        delay_flag <= '1';
                    when U_C =>
                        user_input(7 downto 4) <= kypd_out;
                        state <= U_D;
                        attempts <= attempts + 1;
                        delay_flag <= '1';
                    when U_D =>
                        user_input(3 downto 0) <= kypd_out;
                        state <= U_CHNG;
                        attempts <= attempts + 1;
                    when U_CHNG =>
                        state <= U_CHNG;
                    
                end case;   
                elsif btnl = '1' then            
                    case(state) is
                        ---- locked state ----
                        when L_INI =>
                            state <= L_INI;
                            attempts <= 0;
                        when L_A =>
                            state <= L_INI;
                            s_a <= '0';
                            attempts <= attempts - 1;
                            delay_flag <= '1';
                        when L_B =>
                            state <= L_A;
                            s_b <= '0';
                            attempts <= attempts - 1;
                            delay_flag <= '1';
                        when L_C =>
                            state <= L_B;
                            s_c <= '0';
                            attempts <= attempts - 1;
                            delay_flag <= '1';
                        when L_CMPR =>
                            state <= L_CMPR;
                        
                        ---- unlocked state ----
                        when U_INI =>
                            state <= U_A;
                            delay_flag <= '1';
                            attempts <= 0;
                        when U_A =>
                            state <= U_INI;
                            attempts <= 0;
                            delay_flag <= '1';
                        when U_B =>
                            state <= U_A;
                            attempts <= attempts - 1;
                            delay_flag <= '1';
                        when U_C =>
                            state <= U_B;
                            attempts <= attempts - 1;
                            delay_flag <= '1';
                        when U_D =>
                            state <= U_C;
                            attempts <= attempts - 1;
                            delay_flag <= '1';
                        when U_CHNG =>
                            state <= U_CHNG;
                    end case;
            end if;
            
            attmpts <= attempts;
            usr_input <= user_input;
        end if;
    end process;
end Behavioral;
