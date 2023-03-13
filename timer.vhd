library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    generic (clockFrequencyHz : integer);
    port (
        clk          : in std_logic;
        en           : in std_logic;
        rst          : in std_logic;
        seconds_unit : out integer;
        seconds_ten  : out integer;
        minutes      : out integer;
        endT         : out std_logic
    );
end entity;

architecture rtl of timer is

    -- Signal for counting clock periods
    signal ticks, sec, min : integer;

begin
    process (clk) is
    begin
        if rising_edge(clk) then

            -- If the negative reset signal is active
            if rst = '1' then
                ticks <= 0;
                sec   <= 0;
                min   <= 5;
            else
                if en = '1' then
                    -- True once every second
                    if ticks = clockFrequencyHz - 1 then
                        ticks <= 0;

                        -- True once every minute
                        if sec = 0 then

                            if min = 0 then
                                sec <= sec;
                                min <= min;
                            else
                                sec <= 59;
                                min <= min - 1;
                            end if;

                        else
                            sec <= sec - 1;
                        end if;

                    else
                        ticks <= ticks + 1;
                    end if;

                end if;
            end if;
        end if;

    end process;

    endT <= '1' when min = 0 and sec = 0 else
        '0';

    seconds_unit <= sec rem 10;
    seconds_ten  <= sec / 10;
    minutes      <= min;

end architecture;
