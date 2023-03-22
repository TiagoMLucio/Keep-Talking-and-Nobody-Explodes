--------------------------------------------------------------------
-- Arquivo   : fluxo_dados.vhd
-- Projeto   : Experiencia 5
--------------------------------------------------------------------
-- Descricao :
--    Circuito do fluxo de dados da Atividade 4
----
--    1) contem saidas de depuracao db_contagem e db_memoria
--    2) escolha da arquitetura do componente ram_16x4
--       para simulacao com ModelSim => ram_modelsim
--    3) escolha da arquitetura do componente ram_16x4
--       para sintese com Intel Quartus => ram_mif
--
--------------------------------------------------------------------
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fluxo_dados is
    port (
        clock               : in std_logic;
        zeraE               : in std_logic;
        zeraCR              : in std_logic;
        zeraT               : in std_logic;
        contaE              : in std_logic;
        contaCR             : in std_logic;
        contaT              : in std_logic;
        limpaRC             : in std_logic;
        registraRC          : in std_logic;
        leds_mem            : in std_logic;
        tem_vogal           : in std_logic;
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
end entity fluxo_dados;

architecture estrutural of fluxo_dados is

    signal endereco, rodada                                          : std_logic_vector (1 downto 0);
    signal s_endereco, s_dado, s_novo_dado, s_jogada, s_rodada       : std_logic_vector (3 downto 0);
    signal colors                                                    : std_logic_vector (7 downto 0);
    signal s_not_zeraE, s_not_zeraCR, s_not_escreve, s_chaveacionada : std_logic;
    signal sel_colors                                                : array(natural range <>) of std_logic_vector(1 downto 0);
    signal s_colors                                                  : array(natural range <>) of std_logic_vector(3 downto 0);
    signal colors                                                    : array(natural range <>) of std_logic_vector(3 downto 0);

    component comparador_85
        port (
            i_A3   : in std_logic;
            i_B3   : in std_logic;
            i_A2   : in std_logic;
            i_B2   : in std_logic;
            i_A1   : in std_logic;
            i_B1   : in std_logic;
            i_A0   : in std_logic;
            i_B0   : in std_logic;
            i_AGTB : in std_logic;
            i_ALTB : in std_logic;
            i_AEQB : in std_logic;
            o_AGTB : out std_logic;
            o_ALTB : out std_logic;
            o_AEQB : out std_logic
        );
    end component;

    component ram_16x4 is
        port (
            clk          : in std_logic;
            endereco     : in std_logic_vector(3 downto 0);
            dado_entrada : in std_logic_vector(3 downto 0);
            we           : in std_logic;
            ce           : in std_logic;
            dado_saida   : out std_logic_vector(3 downto 0)
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

    component edge_detector is
        port (
            clock : in std_logic;
            reset : in std_logic;
            sinal : in std_logic;
            pulso : out std_logic
        );
    end component;

    component contador_m is
        generic (
            constant M : integer := 100 -- modulo do contador
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

    component decoder_2 is
        port (
            a : in std_logic_vector(1 downto 0);
            b : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    -- sinais de controle ativos em alto
    -- sinais dos componentes ativos em baixo
    s_not_zeraE  <= not zeraE;
    s_not_zeraCR <= not zeraCR;

    s_chaveacionada <= chaves(0) or chaves(1) or chaves(2) or chaves(3);

    -- "0001" -> Vermelho
    -- "0010" -> Azul
    -- "0100" -> Verde
    -- "1000" -> Amarelo
    s_novo_dado <= "0001" when (erros = "00" and s_dado = "1000" and tem_vogal = '0') or
        (erros = "00" and s_dado = "0010" and tem_vogal = '1') or
        (erros = "01" and s_dado = "0001" and tem_vogal = '0') or
        (erros = "01" and s_dado = "1000" and tem_vogal = '1') or
        (erros = "10" and s_dado = "1000" and tem_vogal = '0') or
        (erros = "10" and s_dado = "0010" and tem_vogal = '1') else

        "0010" when (erros = "00" and s_dado = "0001") or
        (erros = "01" and tem_vogal = '0' and s_dado = "0010") or
        (erros = "01" and tem_vogal = '1' and s_dado = "0100") or
        (erros = "10" and tem_vogal = '0' and s_dado = "0100") or
        (erros = "10" and tem_vogal = '1' and s_dado = "1000") else

        "0100" when (erros = "10" and tem_vogal = '1' and s_dado = "0001") or
        (erros = "01" and tem_vogal = '1' and s_dado = "0010") or
        (erros = "10" and tem_vogal = '0' and s_dado = "0010") or
        (erros = "00" and tem_vogal = '0' and s_dado = "0100") or
        (erros = "00" and tem_vogal = '1' and s_dado = "1000") or
        (erros = "01" and tem_vogal = '0' and s_dado = "1000") else

        "1000" when (erros = "01" and tem_vogal = '1' and s_dado = "0001") or
        (erros = "10" and tem_vogal = '0' and s_dado = "0001") or
        (erros = "00" and tem_vogal = '0' and s_dado = "0010") or
        (erros = "00" and tem_vogal = '1' and s_dado = "0100") or
        (erros = "10" and tem_vogal = '1' and s_dado = "0100") or
        (erros = "01" and tem_vogal = '0' and s_dado = "0100");

    ContEnd : contador_m
    generic map(
        M => 4
    )
    port map(
        clock   => clock,
        zera_as => '0',
        zera_s  => zeraE,
        conta   => contaE,
        Q       => endereco,
        fim     => fimE,
        meio    => open
    );

    ContRod : contador_m
    generic map(
        M => 4
    )
    port map(
        clock   => clock,
        zera_as => '0',
        zera_s  => zeraCR,
        conta   => contaCR,
        Q       => rodada,
        fim     => fimL,
        meio    => open
    );

    CompJog : comparador_85
    port map(
        i_A3   => s_novo_dado(3),
        i_B3   => s_jogada(3),
        i_A2   => s_novo_dado(2),
        i_B2   => s_jogada(2),
        i_A1   => s_novo_dado(1),
        i_B1   => s_jogada(1),
        i_A0   => s_novo_dado(0),
        i_B0   => s_jogada(0),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => open, -- saidas nao usadas
        o_ALTB => open,
        o_AEQB => jogada_correta
    );

    CompEnd : comparador_85
    port map(
        i_A3   => s_rodada(3),
        i_B3   => s_endereco(3),
        i_A2   => s_rodada(2),
        i_B2   => s_endereco(2),
        i_A1   => s_rodada(1),
        i_B1   => s_endereco(1),
        i_A0   => s_rodada(0),
        i_B0   => s_endereco(0),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => open, -- saidas nao usadas
        o_ALTB => open,
        o_AEQB => enderecoIgualRodada
    );

    RegChv : registrador_n
    generic map(
        4
    )
    port map(
        clock  => clock,
        clear  => limpaRC,
        enable => registraRC,
        D      => chaves,
        Q      => s_jogada
    );

    detector_de_borda : edge_detector
    port map(
        clock => clock,
        reset => zeraCR,
        sinal => s_chaveacionada,
        pulso => jogada_feita
    );

    Timer : contador_m
    generic map(
        M => 1000
    )
    port map(
        clock   => clock,
        zera_as => '0',
        zera_s  => zeraT,
        conta   => contaT,
        Q       => open,
        fim     => fimT,
        meio    => meioT
    );

    prng_colors : contador_m
    generic map(
        M => 255
    )
    port map(
        clock   => clock,
        zera_as => '0',
        zera_s  => '0',
        conta   => '1',
        Q       => colors,
        fim     => open,
        meio    => open
    );

    sel_color_1 <= colors(0) & colors(4);
    sel_color_2 <= colors(7) & colors(3);
    sel_color_3 <= colors(2) & colors(6);
    sel_color_4 <= colors(1) & colors(5);

    Dec1 : decoder_2
    port map(
        a => sel_color_1,
        b => color_1
    );

    Dec2 : decoder_2
    port map(
        a => sel_color_2,
        b => color_2
    );

    Dec3 : decoder_2
    port map(
        a => sel_color_3,
        b => color_3
    );

    Dec4 : decoder_2
    port map(
        a => sel_color_4,
        b => color_4
    );

    colors_gen : for i in 0 to 3 generate
        sel_color_1 <= colors(0) & colors(4);

    end generate; -- colors_gen

    RegColor1 : registrador_n
    generic map(
        4
    )
    port map(
        clock  => clock,
        clear  => limpaRN,
        enable => registerRN,
        D = >,
        Q =>
    );

    with leds_mem select
        leds <= s_dado when '1',
        chaves when others;

    s_endereco <= "00" & endereco;
    s_rodada   <= "00" & rodada;

    db_rodada   <= s_rodada;
    db_contagem <= s_endereco;
    db_jogada   <= s_jogada;
    db_memoria  <= s_dado;

end architecture estrutural;
