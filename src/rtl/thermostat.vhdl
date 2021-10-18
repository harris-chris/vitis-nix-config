entity thermostat is
  port ( ACTUAL : in bit_vector(6 downto 0);
         TARGET : in bit_vector(6 downto 0);
         SWITCH  : in bit;
         DISPLAY: out bit_vector(6 downto 0)
       );
end thermostat;

architecture BEHAV of thermostat is
begin
    process (SWITCH, ACTUAL, TARGET) 
    begin
        if (SWITCH = '1') then
            DISPLAY <= ACTUAL;
        else
            DISPLAY <= TARGET;
        end if; 
    end process;
end BEHAV;
