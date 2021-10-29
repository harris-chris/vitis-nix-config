entity thermostat is
  port (  
          ACTUAL : in bit_vector(6 downto 0);
          TARGET : in bit_vector(6 downto 0);
          SWITCH  : in bit;
          COOL : in bit;
          HEAT : in bit;
          DISPLAY: out bit_vector(6 downto 0);
          A_C_ON: out bit;
          FURNACE_ON: out bit
       );
end thermostat;

architecture BEHAV of thermostat is
signal CLK, RESET : bit;
signal ACTUAL_REG, TARGET_REG, DISPLAY_REG : bit_vector(6 downto 0);
signal SWITCH_REG, COOL_REG, HEAT_REG, A_C_ON_REG, FURNACE_ON_REG : bit;
begin
  CLK <= not CLK after 5 ns;
  RESET <= '1', '0' after 1 ns;
  process (CLK, RESET)
  begin
    if RESET = '1' then
      -- outputs
      DISPLAY <= (others => '0');
    end if;

    if rising_edge(CLK) then
      -- inputs
      ACTUAL_REG <= ACTUAL;
      TARGET_REG <= TARGET;
      SWITCH_REG <= SWITCH;
      COOL_REG <= COOL;
      HEAT_REG <= HEAT;
      -- outputs
      DISPLAY <= DISPLAY_REG;
      A_C_ON <= A_C_ON_REG;
      FURNACE_ON <= FURNACE_ON_REG;
    end if;
  end process;

  process (SWITCH_REG, ACTUAL_REG, TARGET_REG) 
  begin
    if (SWITCH_REG = '1') then
        DISPLAY_REG <= ACTUAL_REG;
    else
        DISPLAY_REG <= TARGET_REG;
    end if; 
  end process;

  process (COOL_REG, HEAT_REG, ACTUAL_REG, TARGET_REG) 
  begin
    A_C_ON_REG <= '0';
    FURNACE_ON_REG <= '0';
    if ACTUAL_REG > TARGET_REG then
      if COOL_REG = '1' then
        A_C_ON_REG <= '1';
      end if;
    elsif ACTUAL_REG < TARGET_REG then
      if HEAT_REG = '1' then
        FURNACE_ON_REG <= '1';
      end if;
    end if;
  end process;
end BEHAV;
