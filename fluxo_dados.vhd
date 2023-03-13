library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fluxo_dados is
    port (
        clock        : in std_logic;
        countT       : in std_logic;
        resetT       : in std_logic;
        endT         : out std_logic
        minutes      : out integer;
        seconds_ten  : out integer;
        seconds_unit : out integer

    );
end entity fluxo_dados;

architecture structural of fluxo_dados is

    signal seconds_unit, seconds_ten, minutes : integer;

    -- component contador_m is
    --     generic (
    --         constant M : integer := 100
    --     );
    --     port (
    --         clock   : in std_logic;
    --         zera_as : in std_logic;
    --         zera_s  : in std_logic;
    --         conta   : in std_logic;
    --         Q       : out std_logic_vector(natural(ceil(log2(real(M)))) - 1 downto 0);
    --         fim     : out std_logic;
    --         meio    : out std_logic
    --     );
    -- end component;

    -- component registrador_n is
    --     generic (
    --         constant N : integer := 8
    --     );
    --     port (
    --         clock  : in std_logic;
    --         clear  : in std_logic;
    --         enable : in std_logic;
    --         D      : in std_logic_vector (N - 1 downto 0);
    --         Q      : out std_logic_vector (N - 1 downto 0)
    --     );
    -- end component;

    component timer is
        generic (clockFrequencyHz : integer);
        port (
            clk          : in std_logic;
            en           : in std_logic;
            rst          : in std_logic;
            minutes      : out integer;
            seconds_ten  : out integer;
            seconds_unit : out integer;
            endT         : out std_logic
        );
    end component;

begin

    timer_5min : timer
    generic map(
        clockFrequencyHz => 1000
    )
    port map(
        clk          => clock,
        en           => countT,
        rst          => resetT,
        minutes      => minutes,
        seconds_ten  => seconds_ten,
        seconds_unit => seconds_unit,
        endT         => endT
    );

end architecture structural;
