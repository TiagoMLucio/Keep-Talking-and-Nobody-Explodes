library ieee;
use ieee.std_logic_1164.all;

entity modulo_memoria is
    port (
        clock     : in std_logic;
        reset     : in std_logic;
        iniciar   : in std_logic;
        botoes    : in std_logic_vector (3 downto 0);
        pronto    : out std_logic;
        err       : out std_logic;
        estagio   : out std_logic_vector (2 downto 0);
        display   : out std_logic_vector (6 downto 0);
        num1      : out std_logic_vector (6 downto 0);
        num2      : out std_logic_vector (6 downto 0);
        num3      : out std_logic_vector (6 downto 0);
        num4      : out std_logic_vector (6 downto 0);
        db_estado : out std_logic_vector (6 downto 0)
    );
end entity;

architecture estrutural of modulo_memoria is

    signal zeraE, contaE, limpaJ, registraN, registraJ, escreve, fimE, jogada_feita, jogada_correta, sel_addr : std_logic;
    signal num1_t, num2_t, num3_t, num4_t, display_t, db_estado_t                                             : std_logic_vector (3 downto 0);

    component fluxo_dados
        port (
            clock          : in std_logic;
            zeraE          : in std_logic;
            contaE         : in std_logic;
            limpaJ         : in std_logic;
            registraN      : in std_logic;
            registraJ      : in std_logic;
            escreve        : in std_logic;
            sel_addr       : in std_logic;
            chaves         : in std_logic_vector (3 downto 0);
            estagio        : out std_logic_vector (2 downto 0);
            display        : out std_logic_vector (3 downto 0);
            num1           : out std_logic_vector (3 downto 0);
            num2           : out std_logic_vector (3 downto 0);
            num3           : out std_logic_vector (3 downto 0);
            num4           : out std_logic_vector (3 downto 0);
            fimE           : out std_logic;
            jogada_feita   : out std_logic;
            jogada_correta : out std_logic
        );
    end component;

    component unidade_controle is
        port (
            clock          : in std_logic;
            reset          : in std_logic;
            iniciar        : in std_logic;
            fimE           : in std_logic;
            jogada_feita   : in std_logic;
            jogada_correta : in std_logic;
            zeraE          : out std_logic;
            contaE         : out std_logic;
            limpaJ         : out std_logic;
            registraN      : out std_logic;
            registraJ      : out std_logic;
            escreve        : out std_logic;
            sel_addr       : out std_logic;
            err            : out std_logic;
            pronto         : out std_logic;
            db_estado      : out std_logic_vector(3 downto 0)
        );
    end component;

    component hexa7seg is
        port (
            hexa : in std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;

begin

    fd : fluxo_dados
    port map(
        clock          => clock,
        zeraE          => zeraE,
        contaE         => contaE,
        limpaJ         => limpaJ,
        registraN      => registraN,
        registraJ      => registraJ,
        escreve        => escreve,
        sel_addr       => sel_addr,
        chaves         => botoes,
        estagio        => estagio,
        display        => display_t,
        num1           => num1_t,
        num2           => num2_t,
        num3           => num3_t,
        num4           => num4_t,
        fimE           => fimE,
        jogada_feita   => jogada_feita,
        jogada_correta => jogada_correta
    );

    uc : unidade_controle
    port map(
        clock          => clock,
        reset          => reset,
        iniciar        => iniciar,
        fimE           => fimE,
        jogada_feita   => jogada_feita,
        jogada_correta => jogada_correta,
        zeraE          => zeraE,
        contaE         => contaE,
        limpaJ         => limpaJ,
        registraN      => registraN,
        registraJ      => registraJ,
        escreve        => escreve,
        sel_addr       => sel_addr,
        err            => err,
        pronto         => pronto,
        db_estado      => db_estado_t
    );

    HEX0 : hexa7seg
    port map(
        hexa => num4_t,
        sseg => num4
    );

    HEX1 : hexa7seg
    port map(
        hexa => num3_t,
        sseg => num3
    );

    HEX2 : hexa7seg
    port map(
        hexa => num2_t,
        sseg => num2
    );

    HEX3 : hexa7seg
    port map(
        hexa => num1_t,
        sseg => num1
    );

    HEX4 : hexa7seg
    port map(
        hexa => display_t,
        sseg => display
    );

    HEX5 : hexa7seg
    port map(
        hexa => db_estado_t,
        sseg => db_estado
    );

end architecture estrutural;
