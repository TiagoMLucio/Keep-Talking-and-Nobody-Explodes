library ieee;
use ieee.std_logic_1164.all;

entity modulo_memoria is
    port (
        clock     : in std_logic;
        reset     : in std_logic;
        iniciar   : in std_logic;
        botoes    : in std_logic_vector (3 downto 0);
        tem_vogal : in std_logic;
        erros     : in std_logic_vector(1 downto 0);
        pronto    : out std_logic;
        errou     : out std_logic;
        leds      : out std_logic_vector (3 downto 0)
    );
end entity;

architecture estrutural of modulo_memoria is

    signal zeraE, zeraCR, zeraT, contaE, contaCR, contaT, leds_mem, meioT, limpaRC, registraRN, registraRC, jogada_correta, enderecoIgualRodada, fimE, fimL, fimT, jogada_feita : std_logic;
    signal db_contagem_t, db_jogada_t, db_rodada_t, db_memoria_t, db_estado_t                                                                                                   : std_logic_vector (3 downto 0);

    component fluxo_dados
        port (
            clock          : in std_logic;
            zeraE          : in std_logic;
            contaE         : in std_logic;
            limpaJ         : in std_logic;
            registraJ      : in std_logic;
            escreve        : in std_logic;
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
            clock               : in std_logic;
            reset               : in std_logic;
            iniciar             : in std_logic;
            meioT               : in std_logic;
            fimT                : in std_logic;
            fimL                : in std_logic;
            jogada_feita        : in std_logic;
            enderecoIgualRodada : in std_logic;
            jogada_correta      : in std_logic;
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

    fd : fluxo_dados
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
        tem_vogal           => tem_vogal,
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

    uc : unidade_controle
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
