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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY fluxo_dados IS
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
    db_memoria : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    db_contagem : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    db_rodada : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    db_jogada : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
  );
END ENTITY fluxo_dados;

ARCHITECTURE estrutural OF fluxo_dados IS

  SIGNAL s_endereco, s_dado, s_jogada, s_rodada : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL s_not_zeraE, s_not_zeraCR, s_not_escreve, s_chaveacionada : STD_LOGIC;

  COMPONENT comparador_85
    PORT (
      i_A3 : IN STD_LOGIC;
      i_B3 : IN STD_LOGIC;
      i_A2 : IN STD_LOGIC;
      i_B2 : IN STD_LOGIC;
      i_A1 : IN STD_LOGIC;
      i_B1 : IN STD_LOGIC;
      i_A0 : IN STD_LOGIC;
      i_B0 : IN STD_LOGIC;
      i_AGTB : IN STD_LOGIC;
      i_ALTB : IN STD_LOGIC;
      i_AEQB : IN STD_LOGIC;
      o_AGTB : OUT STD_LOGIC;
      o_ALTB : OUT STD_LOGIC;
      o_AEQB : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT ram_16x4 IS
    PORT (
      clk : IN STD_LOGIC;
      endereco : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      dado_entrada : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      we : IN STD_LOGIC;
      ce : IN STD_LOGIC;
      dado_saida : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT registrador_n IS
    GENERIC (
      CONSTANT N : INTEGER := 8
    );
    PORT (
      clock : IN STD_LOGIC;
      clear : IN STD_LOGIC;
      enable : IN STD_LOGIC;
      D : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
      Q : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT edge_detector IS
    PORT (
      clock : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      sinal : IN STD_LOGIC;
      pulso : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT contador_m IS
    GENERIC (
      CONSTANT M : INTEGER := 100 -- modulo do contador
    );
    PORT (
      clock : IN STD_LOGIC;
      zera_as : IN STD_LOGIC;
      zera_s : IN STD_LOGIC;
      conta : IN STD_LOGIC;
      Q : OUT STD_LOGIC_VECTOR(NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
      fim : OUT STD_LOGIC;
      meio : OUT STD_LOGIC
    );
  END COMPONENT;

BEGIN

  -- sinais de controle ativos em alto
  -- sinais dos componentes ativos em baixo
  s_not_zeraE <= NOT zeraE;
  s_not_zeraCR <= NOT zeraCR;
  s_not_escreve <= NOT escreve;

  s_chaveacionada <= chaves(0) OR chaves(1) OR chaves(2) OR chaves(3);

  ContEnd : contador_m
  GENERIC MAP(
  M => 4
  PORT MAP(
    clock => clock,
    zera_as => '0',
    zera_s => zeraE,
    conta => contaE,
    Q => s_endereco,
    fim => fimE,
    meio => OPEN
  );
  ContRod : contador_m
  GENERIC MAP(
    M => 4
  )
  PORT MAP(
    clock => clock,
    zera_as => '0',
    zera_s => zeraCR,
    conta => contaCR,
    Q => s_rodada,
    fim => fimL,
    meio => OPEN
  );

  CompJog : comparador_85
  PORT MAP(
    i_A3 => s_dado(3),
    i_B3 => s_jogada(3),
    i_A2 => s_dado(2),
    i_B2 => s_jogada(2),
    i_A1 => s_dado(1),
    i_B1 => s_jogada(1),
    i_A0 => s_dado(0),
    i_B0 => s_jogada(0),
    i_AGTB => '0',
    i_ALTB => '0',
    i_AEQB => '1',
    o_AGTB => OPEN, -- saidas nao usadas
    o_ALTB => OPEN,
    o_AEQB => jogada_correta
  );

  CompEnd : comparador_85
  PORT MAP(
    i_A3 => s_rodada(3),
    i_B3 => s_endereco(3),
    i_A2 => s_rodada(2),
    i_B2 => s_endereco(2),
    i_A1 => s_rodada(1),
    i_B1 => s_endereco(1),
    i_A0 => s_rodada(0),
    i_B0 => s_endereco(0),
    i_AGTB => '0',
    i_ALTB => '0',
    i_AEQB => '1',
    o_AGTB => OPEN, -- saidas nao usadas
    o_ALTB => OPEN,
    o_AEQB => enderecoIgualRodada
  );

  -- memoria: entity work.ram_16x4 (ram_mif)  -- usar esta linha para Intel Quartus
  MemJog : ENTITY work.ram_16x4 (ram_modelsim) -- usar arquitetura para ModelSim
    PORT MAP(
      clk => clock,
      endereco => s_endereco,
      dado_entrada => s_jogada,
      we => s_not_escreve, -- we ativo em baixo
      ce => '0',
      dado_saida => s_dado
    );

  RegChv : registrador_n
  GENERIC MAP(
    4
  )
  PORT MAP(
    clock => clock,
    clear => limpaRC,
    enable => registraRC,
    D => chaves,
    Q => s_jogada
  );

  detector_de_borda : edge_detector
  PORT MAP(
    clock => clock,
    reset => zeraE,
    sinal => s_chaveacionada,
    pulso => jogada_feita
  );

  Timer : contador_m
  GENERIC MAP(
    M => 1000
  )
  PORT MAP(
    clock => clock,
    zera_as => '0',
    zera_s => zeraT,
    conta => contaT,
    Q => OPEN,
    fim => fimT,
    meio => meioT
  );

  WITH leds_mem SELECT
    leds <= s_dado WHEN '1' ELSE
    chaves;

  db_rodada <= s_rodada;
  db_contagem <= s_endereco;
  db_jogada <= s_jogada;

END ARCHITECTURE estrutural;