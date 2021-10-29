entity thermostat_simulation is
end thermostat_simulation;

architecture TEST of thermostat_simulation is
component thermostat is
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
end component;

signal CURRENT_TEMP, DESIRED_TEMP, DISPLAY: bit_vector(6 downto 0);
signal SWITCH, COOL, HEAT, A_C_ON, FURNACE_ON: bit;

begin
  TS: thermostat port map (
    ACTUAL => CURRENT_TEMP,
    TARGET => DESIRED_TEMP,
    SWITCH => SWITCH,
    COOL => COOL,
    HEAT => HEAT,
    DISPLAY => DISPLAY,
    A_C_ON => A_C_ON,
    FURNACE_ON => FURNACE_ON
  );
  process 
  begin
    CURRENT_TEMP <= "0001000";
    DESIRED_TEMP <= "0001111";
    SWITCH <= '0';
    COOL <= '0';
    HEAT <= '0';
    wait for 13ns;
    SWITCH <= '1';
    wait for 10ns;
    COOL <= '1';
    HEAT <= '0';
    --wait for 10ns;
    --COOL <= '0';
    --HEAT <= '1';
    --wait for 10ns;
    --CURRENT_TEMP <= "1111111";
    --wait for 10ns;
    --DESIRED_TEMP <= "0000000";
    wait;
  end process;
end TEST;

