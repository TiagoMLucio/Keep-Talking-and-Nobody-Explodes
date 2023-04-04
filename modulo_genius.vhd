library ieee;
use ieee.std_logic_1164.all;

entity modulo_genius is
    port (
        clock       : in std_logic;
        reset       : in std_logic;
        iniciar     : in std_logic;
        botoes      : in std_logic_vector (3 downto 0);
        tem_letra   : in std_logic;
        erros       : in std_logic_vector(1 downto 0);
        exploded    : in std_logic;
        pronto      : out std_logic;
        errou       : out std_logic;
        leds        : out std_logic_vector (3 downto 0);
        db_clock    : out std_logic;
        db_igual    : out std_logic;
        db_contagem : out std_logic_vector (6 downto 0);
        db_memoria  : out std_logic_vector (6 downto 0);
        db_jogada   : out std_logic_vector (6 downto 0);
        db_rodada   : out std_logic_vector (6 downto 0);
        db_estado   : out std_logic_vector (6 downto 0)
    );
end entity;
architecture estrutural of modulo_genius is

    signal zeraE, zeraCR, zeraT, contaE, contaCR, contaT, leds_mem, meioT, limpaRC, registraRN, registraRC, jogada_correta, enderecoIgualRodada, fimE, fimL, fimT, jogada_feita : std_logic;
    signal db_contagem_t, db_jogada_t, db_rodada_t, db_memoria_t, db_estado_t                                                                                                   : std_logic_vector (3 downto 0);

    component fluxo_dados_gen
        port (
            clock               : in std_logic;
            zeraE               : in std_logic;
            zeraCR              : in std_logic;
            zeraT               : in std_logic;
            contaE              : in std_logic;
            contaCR             : in std_logic;
            contaT              : in std_logic;
            registraRN          : in std_logic;
            limpaRC             : in std_logic;
            registraRC          : in std_logic;
            leds_mem            : in std_logic;
            tem_letra           : in std_logic;
            erros               : in std_logic_vector(1 downto 0);
            chaves              : in std_logic_vector (3 downto 0);
            jogada_correta      : out std_logic;
            enderecoIgualRodada : out std_logic;
            meioT               : out std_logic;
            fimT                : out std_logic;
            fimE                : out std_logic;
            fimL                : out std_logic;
            jogada_feita        : out std_logic;
            leds                : out std_logic_vector (3 downto 0);
            db_memoria          : out std_logic_vector (3 downto 0);
            db_contagem         : out std_logic_vector (3 downto 0);
            db_rodada           : out std_logic_vector (3 downto 0);
            db_jogada           : out std_logic_vector (3 downto 0)
        );
    end component;

    component unidade_controle_gen is
        port (
            clock               : in std_logic;
            reset               : in std_logic;
            iniciar             : in std_logic;
            meioT               : in std_logic;
            fimT                : in std_logic;
            fimL                : in std_logic;
            jogada_feita        : in std_logic;
            enderecoIgualRodada : in std_logic;
            jogada_correta      : in std_logic;
            exploded            : in std_logic;
            leds_mem            : out std_logic;
            contaE              : out std_logic;
            contaT              : out std_logic;
            contaCR             : out std_logic;
            registraRN          : out std_logic;
            registraRC          : out std_logic;
            zeraE               : out std_logic;
            zeraT               : out std_logic;
            zeraCR              : out std_logic;
            limpaRC             : out std_logic;
            pronto              : out std_logic;
            errou               : out std_logic;
            db_estado           : out std_logic_vector(3 downto 0)
        );
    end component;

    component hexa7seg is
        port (
            hexa : in std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;

begin

    fd : fluxo_dados_gen
    port map(
        clock               => clock,
        zeraE               => zeraE,
        zeraCR              => zeraCR,
        zeraT               => zeraT,
        contaE              => contaE,
        contaCR             => contaCR,
        contaT              => contaT,
        registraRN          => registraRN,
        limpaRC             => limpaRC,
        registraRC          => registraRC,
        leds_mem            => leds_mem,
        tem_letra           => tem_letra,
        erros               => erros,
        chaves              => botoes,
        jogada_correta      => jogada_correta,
        enderecoIgualRodada => enderecoIgualRodada,
        meioT               => meioT,
        fimE                => fimE,
        fimL                => fimL,
        fimT                => fimT,
        jogada_feita        => jogada_feita,
        leds                => leds,
        db_memoria          => db_memoria_t,
        db_contagem         => db_contagem_t,
        db_rodada           => db_rodada_t,
        db_jogada           => db_jogada_t
    );

    uc : unidade_controle_gen
    port map(
        clock               => clock,
        reset               => reset,
        iniciar             => iniciar,
        meioT               => meioT,
        fimL                => fimL,
        fimT                => fimT,
        jogada_feita        => jogada_feita,
        enderecoIgualRodada => enderecoIgualRodada,
        jogada_correta      => jogada_correta,
        exploded            => exploded,
        leds_mem            => leds_mem,
        contaE              => contaE,
        contaT              => contaT,
        contaCR             => contaCR,
        registraRN          => registraRN,
        registraRC          => registraRC,
        zeraE               => zeraE,
        zeraT               => zeraT,
        zeraCR              => zeraCR,
        limpaRC             => limpaRC,
        pronto              => pronto,
        errou               => errou,
        db_estado           => db_estado_t
    );

    HEX0 : hexa7seg
    port map(
        hexa => db_contagem_t,
        sseg => db_contagem
    );

    HEX1 : hexa7seg
    port map(
        hexa => db_memoria_t,
        sseg => db_memoria
    );

    HEX2 : hexa7seg
    port map(
        hexa => db_jogada_t,
        sseg => db_jogada
    );

    HEX3 : hexa7seg
    port map(
        hexa => db_rodada_t,
        sseg => db_rodada
    );

    HEX5 : hexa7seg
    port map(
        hexa => db_estado_t,
        sseg => db_estado
    );

    db_igual <= jogada_correta;
    db_clock <= clock;

end architecture estrutural;
