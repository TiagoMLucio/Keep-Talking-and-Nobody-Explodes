library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fluxo_dados is
    port (
        clock        : in std_logic;
        countT       : in std_logic;
        resetT       : in std_logic;
        clearS       : in std_logic;
        registerS    : in std_logic;
        resetE       : in std_logic;
        db_err       : in std_logic;
        endT         : out std_logic;
        minutes      : out integer;
        seconds_ten  : out integer;
        seconds_unit : out integer;
        endE         : out std_logic;
        errors       : out std_logic_vector(1 downto 0);
        serial1      : out std_logic_vector(3 downto 0);
        serial2      : out std_logic_vector(3 downto 0)
    );
end entity fluxo_dados;

architecture structural of fluxo_dados is

    signal serials                                                    : std_logic_vector(7 downto 0);
    signal serial1_s, serial2_s                                       : std_logic_vector(3 downto 0);
    signal db_out_ready1, db_out_ready2, db_out_valid1, db_out_valid2 : std_logic;

    component contador_m is
        generic (
            constant M : integer := 100
        );
        port (
            clock   : in std_logic;
            zera_as : in std_logic;
            zera_s  : in std_logic;
            conta   : in std_logic;
            Q       : out std_logic_vector(natural(ceil(log2(real(M)))) - 1 downto 0);
            fim     : out std_logic;
            meio    : out std_logic
        );
    end component;

    component registrador_n is
        generic (
            constant N : integer := 8
        );
        port (
            clock  : in std_logic;
            clear  : in std_logic;
            enable : in std_logic;
            D      : in std_logic_vector (N - 1 downto 0);
            Q      : out std_logic_vector (N - 1 downto 0)
        );
    end component;

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

    prng_serials : contador_m
    generic map(
        M => 255
    )
    port map(
        clock   => clock,
        zera_as => '0',
        zera_s  => '0',
        conta   => '1',
        Q       => serials,
        fim     => open,
        meio    => open
    );

    serial1_s <= serials(0) & serials(2) & serials(4) & serials(6);
    serial2_s <= serials(1) & serials(3) & serials(5) & serials(7);

    reg_serial1 : registrador_n
    generic map(
        4
    )
    port map(
        clock  => clock,
        clear  => clearS,
        enable => registerS,
        D      => serial1_s,
        Q      => serial1
    );

    reg_serial2 : registrador_n
    generic map(
        4
    )
    port map(
        clock  => clock,
        clear  => clearS,
        enable => registerS,
        D      => serial2_s,
        Q      => serial2
    );

    CountErrors : contador_m
    generic map(
        M => 4
    )
    port map(
        clock   => clock,
        zera_as => '0',
        zera_s  => resetE,
        conta   => db_err,
        Q       => errors,
        fim     => endE,
        meio    => open
    );

end architecture structural;
