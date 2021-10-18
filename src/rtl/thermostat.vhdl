entity THERMOSTAT is
  port ( ACTUAL : in bit_vector(6 down to 0);
         TARGET : in bit_vector(6 down to 0);
         SWICH  : in bit;
         DISPLAY: out bit_vector(6 down to 0)
       );
end THERMOSTAT;

architecture BEHAV of THERMOSTAT is

begin
  if SWITCH  = '1' then
    DISPLAY <= ACTUAL;
  else
    DISPLAY <= TARGET;
  end if;
end process;

end BEHAV;
