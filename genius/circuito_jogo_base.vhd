LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY circuito_jogo_base IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        iniciar : IN STD_LOGIC;
        botoes : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        leds : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        pronto : OUT STD_LOGIC;
        ganhou : OUT STD_LOGIC;
        perdeu : OUT STD_LOGIC;
        db_clock : OUT STD_LOGIC;
        db_igual : OUT STD_LOGIC;
        db_timeout : OUT STD_LOGIC;
        db_contagem : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_memoria : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_jogada : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_rodada : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_estado : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE estrutural OF circuito_jogo_base IS

    SIGNAL zeraE, zeraCR, zeraT, contaE, contaCR, contaT, leds_mem, escreve, errou, meioT, limpaRC, registraRC, jogada_correta, enderecoIgualRodada, fimE, fimL, fimT, jogada_feita : STD_LOGIC;
    SIGNAL db_contagem_t, db_jogada_t, db_rodada_t, db_memoria_t, db_estado_t : STD_LOGIC_VECTOR (3 DOWNTO 0);

    COMPONENT fluxo_dados
        PORT (
            clock : IN STD_LOGIC;
            zeraE : IN STD_LOGIC;
            zeraCR : IN STD_LOGIC;
            zeraT : IN STD_LOGIC;
            contaE : IN STD_LOGIC;
            contaCR : IN STD_LOGIC;
            contaT : IN STD_LOGIC;
            escreve : IN STD_LOGIC;
            limpaRC : IN STD_LOGIC;
            registraRC : IN STD_LOGIC;
            leds_mem : IN STD_LOGIC;
            chaves : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            jogada_correta : OUT STD_LOGIC;
            enderecoIgualRodada : OUT STD_LOGIC;
            meioT : OUT STD_LOGIC;
            fimT : OUT STD_LOGIC;
            fimE : OUT STD_LOGIC;
            fimL : OUT STD_LOGIC;
            jogada_feita : OUT STD_LOGIC;
            leds : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            db_contagem : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            db_rodada : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            db_jogada : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT unidade_controle IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            iniciar : IN STD_LOGIC;
            meioT : IN STD_LOGIC;
            fimT : IN STD_LOGIC;
            fimL : IN STD_LOGIC;
            jogada_feita : IN STD_LOGIC;
            enderecoIgualRodada : IN STD_LOGIC;
            jogada_correta : IN STD_LOGIC;
            leds_mem : OUT STD_LOGIC;
            contaE : OUT STD_LOGIC;
            contaT : OUT STD_LOGIC;
            contaCR : OUT STD_LOGIC;
            registraRC : OUT STD_LOGIC;
            zeraE : OUT STD_LOGIC;
            zeraT : OUT STD_LOGIC;
            zeraCR : OUT STD_LOGIC;
            limpaRC : OUT STD_LOGIC;
            pronto : OUT STD_LOGIC;
            errou : OUT STD_LOGIC;
            db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT hexa7seg IS
        PORT (
            hexa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    fd : fluxo_dados
    PORT MAP(
        clock => clock,
        zeraE => zeraE,
        zeraCR => zeraCR,
        zeraT => zeraT,
        contaE => contaE,
        contaCR => contaCR,
        contaT => contaT,
        escreve => escreve,
        limpaRC => limpaRC,
        registraRC => registraRC,
        leds_mem => leds_mem,
        chaves => botoes,
        jogada_correta => jogada_correta,
        enderecoIgualRodada => enderecoIgualRodada,
        meioT => meioT,
        fimE => fimE,
        fimL => fimL,
        fimT => fimT,
        jogada_feita => jogada_feita,
        leds => leds,
        db_memoria => db_memoria_t,
        db_contagem => db_contagem_t,
        db_rodada => db_rodada_t,
        db_jogada => db_jogada_t
    );

    uc : unidade_controle
    PORT MAP(
        clock => clock,
        reset => reset,
        iniciar => iniciar,
        meioT => meioT,
        fimL => fimL,
        fimT => fimT,
        jogada_feita => jogada_feita,
        enderecoIgualRodada => enderecoIgualRodada,
        jogada_correta => jogada_correta,
        leds_mem => leds_mem,
        contaE => contaE,
        contaT => contaT,
        contaCR => contaCR,
        registraRC => registraRC,
        zeraE => zeraE,
        zeraT => zeraT,
        zeraCR => zeraCR,
        limpaRC => limpaRC,
        pronto => pronto,
        errou => errou,
        db_estado => db_estado_t
    );

    HEX0 : hexa7seg
    PORT MAP(
        hexa => db_contagem_t,
        sseg => db_contagem
    );

    HEX1 : hexa7seg
    PORT MAP(
        hexa => db_memoria_t,
        sseg => db_memoria
    );

    HEX2 : hexa7seg
    PORT MAP(
        hexa => db_jogada_t,
        sseg => db_jogada
    );

    HEX3 : hexa7seg
    PORT MAP(
        hexa => db_rodada_t,
        sseg => db_rodada
    );

    HEX5 : hexa7seg
    PORT MAP(
        hexa => db_estado_t,
        sseg => db_estado
    );

    db_igual <= jogada_correta;
    db_clock <= clock;

END ARCHITECTURE estrutural;