set_global_assignment -entity "clock_pll" -library "lib_clock_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clock_pll" -library "lib_clock_pll" -name IP_TOOL_VERSION "13.1"
set_global_assignment -entity "clock_pll" -library "lib_clock_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clock_pll" -name SPD_FILE [file join $::quartus(sip_path) "clock_pll.spd"]

set_global_assignment -library "lib_clock_pll" -name MISC_FILE [file join $::quartus(sip_path) "clock_pll_sim/clock_pll.vo"]
