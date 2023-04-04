library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fluxo_dados_mem is
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
        estagio        : out std_logic_vector (3 downto 0);
        display        : out std_logic_vector (3 downto 0);
        num1           : out std_logic_vector (3 downto 0);
        num2           : out std_logic_vector (3 downto 0);
        num3           : out std_logic_vector (3 downto 0);
        num4           : out std_logic_vector (3 downto 0);
        fimE           : out std_logic;
        jogada_feita   : out std_logic;
        jogada_correta : out std_logic
    );
end entity fluxo_dados_mem;

architecture estrutural of fluxo_dados_mem is

    signal s_chaveacionada, sel_jogada, s_not_escreve                                                               : std_logic;
    signal sel_display, sel_num1, sel_num2, sel_num3, sel_num4, sel_dado, s_display, s_num1, s_num2, s_num3, s_num4 : std_logic_vector(1 downto 0);
    signal s_endereco, s_estagio, estagio_passado, sel_prns                                                         : std_logic_vector(2 downto 0);
    signal pos_jogada, num_jogado, s_jogada, mem_num, mem_pos, valor, s_dado                                        : std_logic_vector(3 downto 0);
    signal t_display, num_1, num_2, num_3, num_4                                                                    : std_logic_vector(3 downto 0);
    signal prns                                                                                                     : std_logic_vector(6 downto 0);
    signal nums_t, nums                                                                                             : std_logic_vector(7 downto 0);

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

    component ram_8x4 is
        port (
            clk          : in std_logic;
            endereco     : in std_logic_vector(2 downto 0);
            dado_entrada : in std_logic_vector(3 downto 0);
            we           : in std_logic;
            ce           : in std_logic;
            dado_saida   : out std_logic_vector(3 downto 0)
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

    s_not_escreve <= not escreve;

    Prng : contador_m
    generic map(
        M => 96
    )
    port map(
        clock   => clock,
        zera_as => '0',
        zera_s  => '0',
        conta   => '1',
        Q       => prns,
        fim     => open,
        meio    => open
    );

    sel_display <= prns(1 downto 0);

    sel_prns <= prns(6 downto 4);

    with sel_prns select
        nums_t <= "11100100" when "000",
        "10110100" when "001",
        "11011000" when "010",
        "01111000" when "011",
        "10011100" when "100",
        "01101100" when "101",
        "00000000" when others;

    nums <= to_stdlogicvector(to_bitvector(nums_t) ror 2 * to_integer(unsigned(prns(3 downto 2))));

    sel_num1 <= nums(1 downto 0);
    sel_num2 <= nums(3 downto 2);
    sel_num3 <= nums(5 downto 4);
    sel_num4 <= nums(7 downto 6);

    RegDisplay : registrador_n
    generic map(
        2
    )
    port map(
        clock  => clock,
        clear  => limpaJ,
        enable => registraN,
        D      => sel_display,
        Q      => s_display
    );

    RegNum1 : registrador_n
    generic map(
        2
    )
    port map(
        clock  => clock,
        clear  => limpaJ,
        enable => registraN,
        D      => sel_num1,
        Q      => s_num1
    );

    RegNum2 : registrador_n
    generic map(
        2
    )
    port map(
        clock  => clock,
        clear  => limpaJ,
        enable => registraN,
        D      => sel_num2,
        Q      => s_num2
    );

    RegNum3 : registrador_n
    generic map(
        2
    )
    port map(
        clock  => clock,
        clear  => limpaJ,
        enable => registraN,
        D      => sel_num3,
        Q      => s_num3
    );

    RegNum4 : registrador_n
    generic map(
        2
    )
    port map(
        clock  => clock,
        clear  => limpaJ,
        enable => registraN,
        D      => sel_num4,
        Q      => s_num4
    );

    DecDisplay : decoder_2
    port map(
        a => s_display,
        b => t_display
    );

    DecNum1 : decoder_2
    port map(
        a => s_num1,
        b => num_1
    );

    DecNum2 : decoder_2
    port map(
        a => s_num2,
        b => num_2
    );

    DecNum3 : decoder_2
    port map(
        a => s_num3,
        b => num_3
    );

    DecNum4 : decoder_2
    port map(
        a => s_num4,
        b => num_4
    );

    s_chaveacionada <= chaves(0) or chaves(1) or chaves(2) or chaves(3);

    detector_de_borda : edge_detector
    port map(
        clock => clock,
        reset => '0',
        sinal => s_chaveacionada,
        pulso => jogada_feita
    );

    RegJog : registrador_n
    generic map(
        4
    )
    port map(
        clock  => clock,
        clear  => limpaJ,
        enable => registraJ,
        D      => chaves,
        Q      => pos_jogada
    );

    ContEst : contador_m
    generic map(
        M => 5
    )
    port map(
        clock   => clock,
        zera_as => '0',
        zera_s  => zeraE,
        conta   => contaE,
        Q       => s_estagio,
        fim     => fimE,
        meio    => open
    );

    with pos_jogada select
        num_jogado <= num_1 when "0001",
        num_2 when "0010",
        num_3 when "0100",
        num_4 when "1000",
        "0000" when others;

    with sel_jogada select
        s_jogada <= pos_jogada when '1',
        num_jogado when others;

    with sel_addr select
        s_endereco <= s_estagio when '1',
        estagio_passado when others;

    MemNum : entity work.ram_8x4 (ram_mif) -- usar esta linha para Intel Quartus
        -- MemNum : entity work.ram_8x4 (ram_modelsim) -- usar arquitetura para ModelSim
        port map(
            clk          => clock,
            endereco     => s_endereco,
            dado_entrada => num_jogado,
            we           => s_not_escreve, -- we ativo em baixo
            ce           => '0',
            dado_saida   => mem_num
        );

    MemPos : entity work.ram_8x4 (ram_mif) -- usar esta linha para Intel Quartus
        -- MemPos : entity work.ram_8x4 (ram_modelsim) -- usar arquitetura para ModelSim
        port map(
            clk          => clock,
            endereco     => s_endereco,
            dado_entrada => pos_jogada,
            we           => s_not_escreve, -- we ativo em baixo
            ce           => '0',
            dado_saida   => mem_pos
        );

    sel_jogada <= '1' when ((s_estagio = "000") or
        (s_estagio = "001" and not (s_display = "00")) or
        (s_estagio = "010" and s_display = "10") or
        (s_estagio = "011")) else
        '0';

    estagio_passado <= "000" when ((s_estagio = "001" and (s_display = "01" or s_display = "11")) or
        (s_estagio = "010" and s_display = "01") or
        (s_estagio = "011" and s_display = "00") or
        (s_estagio = "100" and s_display = "00")) else
        "001" when ((s_estagio = "010" and s_display = "00") or
        (s_estagio = "011" and (s_display = "10" or s_display = "11")) or
        (s_estagio = "100" and s_display = "01")) else
        "010" when ((s_estagio = "100" and s_display = "11")) else
        "011" when ((s_estagio = "100" and s_display = "10")) else
        "100";

    sel_dado <= "00" when ((s_estagio = "010" and (s_display = "00" or s_display = "01")) or
        (s_estagio = "100")) else
        "01" when ((s_estagio = "001" and (s_display = "01" or s_display = "11")) or
        (s_estagio = "011" and not (s_display = "01"))) else
        "10";

    valor <= "0001" when ((s_estagio = "001" and s_display = "10") or
        (s_estagio = "011" and s_display = "01")) else
        "0010" when (s_estagio = "000" and (s_display = "00" or s_display = "01")) else
        "0100" when ((s_estagio = "000" and s_display = "10") or
        (s_estagio = "010" and s_display = "10")) else
        "1000" when ((s_estagio = "000" and s_display = "11") or
        (s_estagio = "001" and s_display = "00")) else
        "0000";

    with sel_dado select
        s_dado <= mem_num when "00",
        mem_pos when "01",
        valor when "10",
        "0000" when others;

    CompJog : comparador_85
    port map(
        i_A3   => s_dado(3),
        i_B3   => s_jogada(3),
        i_A2   => s_dado(2),
        i_B2   => s_jogada(2),
        i_A1   => s_dado(1),
        i_B1   => s_jogada(1),
        i_A0   => s_dado(0),
        i_B0   => s_jogada(0),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => open, -- saidas nao usadas
        o_ALTB => open,
        o_AEQB => jogada_correta
    );

    with s_estagio select
        estagio <= "0000" when "000",
        "0001" when "001",
        "0011" when "010",
        "0111" when "011",
        "1111" when "100",
        "1111" when others;

    display <= std_logic_vector(to_unsigned(to_integer(unsigned(s_display)) + 1, 4));
    num1    <= std_logic_vector(to_unsigned(to_integer(unsigned(s_num1)) + 1, 4));
    num2    <= std_logic_vector(to_unsigned(to_integer(unsigned(s_num2)) + 1, 4));
    num3    <= std_logic_vector(to_unsigned(to_integer(unsigned(s_num3)) + 1, 4));
    num4    <= std_logic_vector(to_unsigned(to_integer(unsigned(s_num4)) + 1, 4));

end architecture estrutural;
