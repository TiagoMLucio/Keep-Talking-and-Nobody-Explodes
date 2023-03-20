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
    escreve             : in std_logic;
    limpaRC             : in std_logic;
    registraRC          : in std_logic;
    leds_mem            : in std_logic;
    chaves              : in std_logic_vector (3 downto 0);
    jogada_correta      : out std_logic;
    enderecoIgualRodada : out std_logic;
    meioT               : out std_logic;
    fimT                : out std_logic;
    fimE                : out std_logic;
    fimL                : out std_logic;
    jogada_feita        : out std_logic;
    leds                : out std_logic_vector (3 downto 0);
    db_contagem         : out std_logic_vector (3 downto 0);
    db_rodada           : out std_logic_vector (3 downto 0);
    db_jogada           : out std_logic_vector (3 downto 0)
  );
end entity fluxo_dados;

architecture estrutural of fluxo_dados is

  signal s_endereco, s_dado, s_jogada, s_rodada                    : std_logic_vector (3 downto 0);
  signal s_not_zeraE, s_not_zeraCR, s_not_escreve, s_chaveacionada : std_logic;

  component contador_163
    port (
      clock : in std_logic;
      clr   : in std_logic;
      ld    : in std_logic;
      ent   : in std_logic;
      enp   : in std_logic;
      D     : in std_logic_vector (3 downto 0);
      Q     : out std_logic_vector (3 downto 0);
      rco   : out std_logic
    );
  end component;

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

begin

  -- sinais de controle ativos em alto
  -- sinais dos componentes ativos em baixo
  s_not_zeraE   <= not zeraE;
  s_not_zeraCR  <= not zeraCR;
  s_not_escreve <= not escreve;

  s_chaveacionada <= chaves(0) or chaves(1) or chaves(2) or chaves(3);

  ContEnd : contador_163
  port map(
    clock => clock,
    clr   => s_not_zeraE, -- clr ativo em baixo
    ld    => '1',
    ent   => '1',
    enp   => contaE,
    D     => "0000",
    Q     => s_endereco,
    rco   => fimE
  );

  ContRod : contador_163
  port map(
    clock => clock,
    clr   => s_not_zeraCR, -- clr ativo em baixo
    ld    => '1',
    ent   => '1',
    enp   => contaCR,
    D     => "0000",
    Q     => s_rodada,
    rco   => fimL
  );

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

  -- memoria: entity work.ram_16x4 (ram_mif)  -- usar esta linha para Intel Quartus
  MemJog : entity work.ram_16x4 (ram_modelsim) -- usar arquitetura para ModelSim
    port map(
      clk          => clock,
      endereco     => s_endereco,
      dado_entrada => s_jogada,
      we           => s_not_escreve, -- we ativo em baixo
      ce           => '0',
      dado_saida   => s_dado
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
    reset => zeraE,
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

  with leds_mem select
    leds <= s_dado when '1' else
    chaves;

  db_rodada   <= s_rodada;
  db_contagem <= s_endereco;
  db_jogada   <= s_jogada;

end architecture estrutural;
