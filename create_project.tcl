create_project -force -part  thermostat
add_files -fileset sources_1 defines.v
add_files -fileset sources_1 ../thermostat.vhdl
add_files -fileset constrs_1 thermostat.xdc
exit
