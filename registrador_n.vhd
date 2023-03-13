-----------------Laboratorio Digital-------------------------------------
-- Arquivo   : registrador_n.vhd
-- Projeto   : Experiencia 3 - Projeto de uma unidade de controle
-------------------------------------------------------------------------
-- Descricao : registrador com numero de bits N como generic
--             com clear assincrono e carga sincrona
--
--             baseado no codigo vreg16.vhd do livro
--             J. Wakerly, Digital design: principles and practices 4e
--
-- Exemplo de instanciacao:
--      REG1 : registrador_n
--             generic map ( N => 12 )
--             port map (
--                 clock  => clock, 
--                 clear  => zera_reg1, 
--                 enable => registra1, 
--                 D      => s_medida, 
--                 Q      => distancia
--             );
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     09/09/2019  1.0     Edson Midorikawa  criacao
--     08/06/2020  1.1     Edson Midorikawa  revisao e melhoria de codigo 
--     09/09/2020  1.2     Edson Midorikawa  revisao 
--     09/09/2021  1.3     Edson Midorikawa  revisao 
--     03/09/2022  1.4     Edson Midorikawa  revisao do codigo
--     20/01/2023  1.4.1   Edson Midorikawa  revisao do codigo
-------------------------------------------------------------------------
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registrador_n IS
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
END ENTITY registrador_n;

ARCHITECTURE comportamental OF registrador_n IS
    SIGNAL IQ : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN

    PROCESS (clock, clear, enable, IQ)
    BEGIN
        IF (clear = '1') THEN
            IQ <= (OTHERS => '0');
        ELSIF (clock'event AND clock = '1') THEN
            IF (enable = '1') THEN
                IQ <= D;
            ELSE
                IQ <= IQ;
            END IF;
        END IF;
        Q <= IQ;
    END PROCESS;

END ARCHITECTURE comportamental;