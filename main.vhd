library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( 
        clk: in std_logic;
        JA : inout  STD_LOGIC_VECTOR (7 downto 0);
        unlocked_s: out std_logic;
        seven_seg: out std_logic_vector(7 downto 0);
        led: out std_logic_vector(7 downto 0);
        BTNL: in std_logic;
        BTNU: in std_logic;
        chnge_pass_s: out std_logic;
        key_pushedled: out std_logic;
        s_lini, s_a, s_b, s_c, s_uini: out std_logic
    );
end main;

architecture Behavioral of main is
    component KypdDecoder is
    Port (
	    clk : in  STD_LOGIC;
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
	    Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0);
        Pressed: out std_logic
    );
    end component;
    
    component Clock is
    generic (
        COUNT_VALUE : integer := 78124  -- Default count value
    );
    Port ( 
        clk_in: in std_logic;
        clk_out: out std_logic
    );
    end component;
    
    component SevenSegment is
    Port ( 
        S_IN: in std_logic_vector(3 downto 0);
        S_OUT: out std_logic_vector(7 downto 0)
    );
    end component;
    
    component TwoToEight is
    Port(
        digits: in integer;
        D_IN: in std_logic_vector(1 downto 0);
        D_OUT: out std_logic_vector(7 downto 0)  
    );
    end component;
    
    component DataSelector4bits is
    Port ( 
        S_IN: in std_logic_vector(15 downto 0);
        P_OUT: out std_logic_vector(3 downto 0);
        clk: in std_logic_vector(1 downto 0)
    );
    
    end component;
    component Counter is
    Port(
        clk,rst : in std_logic;
        Output: out std_logic_vector(1 downto 0)
    );
    end component;
    
    component FSM is
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
    end component;
        
    signal key_pushed: std_logic;
    signal user_input: std_logic_vector(15 downto 0);
    signal kypd_out: std_logic_vector(3 downto 0);
    signal attempts: integer;
    signal clk_slow: std_logic;
    signal count_signal: std_logic_vector(1 downto 0);
    signal sev_seg_signal: std_logic_vector(3 downto 0);
    signal sev_seg_clk: std_logic;
begin
    -- port maps
    kypd: KypdDecoder port map(clk=>clk, Row=>JA(7 downto 4), Col=>JA(3 downto 0), DecodeOut=>kypd_out, Pressed=>key_pushed);
    slw_clk: Clock generic map (COUNT_VALUE => 150000) port map(clk_in => clk, clk_out=> clk_slow); -- 335.57 Hz
    data_selector: DataSelector4bits port map (S_IN => user_input, P_OUT => sev_seg_signal, clk => count_signal);
    sevseg_dec: SevenSegment port map (S_IN => sev_seg_signal, S_OUT => seven_seg);
    sevseg_clk: Clock port map (clk_in => clk, clk_out => sev_seg_clk); -- 640 Hz (80 Hz each)
    cnter: Counter port map (clk =>sev_seg_clk, rst=>BTNU, Output=> count_signal);
    dec2to8: TwoToEight port map (digits => attempts, D_IN => count_signal, D_OUT => led);
    stateM: FSM port map (
        key_pushed => key_pushed,
        clk => clk_slow,
        rst => BTNU,
        kypd_out => kypd_out,
        btnl => BTNL,
        s_a => s_a,
        s_b => s_b,
        s_c => S_c,
        s_lini => s_lini,
        s_uini => s_uini,
        unlocked_s => unlocked_s,
        chnge_pass => chnge_pass_s,
        usr_input => user_input,
        attmpts => attempts
    );
    
    key_pushedled <= key_pushed;
    
end Behavioral;
