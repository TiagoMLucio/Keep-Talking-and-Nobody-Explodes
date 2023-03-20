----------------------------------------------------------------
-- Arquivo   : contador_163.vhd
-- Projeto   : Experiencia 2 - Um Fluxo de Dados Simples
----------------------------------------------------------------
-- Descricao : contador binario hexadecimal (modulo 16) 
--             similar ao CI 74163
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     29/12/2020  1.0     Edson Midorikawa  criacao
--     07/01/2022  1.1     Edson Midorikawa  revisao
--     07/01/2023  1.1.1   Edson Midorikawa  revisao
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador_163 is
    port (
        clock : in  std_logic;
        clr   : in  std_logic;
        ld    : in  std_logic;
        ent   : in  std_logic;
        enp   : in  std_logic;
        D     : in  std_logic_vector (3 downto 0);
        Q     : out std_logic_vector (3 downto 0);
        rco   : out std_logic 
   );
end entity;

architecture comportamental of contador_163 is
    signal IQ: integer range 0 to 15;
begin
  
    -- contagem
    process (clock)
    begin
    
        if clock'event and clock='1' then
            if clr='0' then   IQ <= 0; 
            elsif ld='0' then IQ <= to_integer(unsigned(D));
            elsif ent='1' and enp='1' then
                if IQ=15 then IQ <= 0; 
                else          IQ <= IQ + 1; 
                end if;
            else              IQ <= IQ;
            end if;
        end if;
    
    end process;

    -- saida rco
    rco <= '1' when IQ=15 and ent='1' else
           '0';

    -- saida Q
    Q <= std_logic_vector(to_unsigned(IQ, Q'length));

end architecture;
