variable dispScriptFile [file normalize [info script]]

proc getScriptDirectory {} {
    variable dispScriptFile
    set scriptFolder [file dirname $dispScriptFile]
    return $scriptFolder
}

set sdir [getScriptDirectory]
cd [getScriptDirectory]

# KORAK#1: Definisanje direktorijuma u kojima ce biti smesteni projekat i konfiguracioni fajl
set resultDir .\/result
file mkdir $resultDir
create_project MBIST $resultDir -part xc7z010clg400-1 -force
set_property board_part digilentinc.com:zybo-z7-10:part0:1.0 [current_project]
set_property target_language VHDL [current_project]


# KORAK#2: Ukljucivanje svih izvornih fajlova u projekat
add_files -norecurse .\/Design_Files\/Address_Generator.vhd
add_files -norecurse .\/Design_Files\/BIST_Controller.vhd
add_files -norecurse .\/Design_Files\/Control_Signal_Generator.vhd
add_files -norecurse .\/Design_Files\/Data_Generator.vhd
add_files -norecurse .\/Design_Files\/Datapath.vhd
add_files -norecurse .\/Design_Files\/Dual_Port_Memory.vhd
add_files -norecurse .\/Design_Files\/Instruction_Counter.vhd
add_files -norecurse .\/Design_Files\/Instruction_Decoder.vhd
add_files -norecurse .\/Design_Files\/Microinstruction_Memory.vhd
add_files -norecurse .\/Design_Files\/Register_File.vhd
add_files -norecurse .\/Design_Files\/Response_Analyzer.vhd
add_files -norecurse .\/Design_Files\/Top.vhd
add_files -fileset constrs_1 .\/Constraints\/constr.xdc
add_files -fileset sim_1 .\/Simulation_Files\/BIST_Controller_tb.vhd
add_files -fileset sim_1 .\/Simulation_Files\/BIST_tb.vhd
add_files -fileset sim_1 .\/Simulation_Files\/BIST_all_tb.vhd
update_compile_order -fileset sources_1


# KORAK#3: Pokretanje procesa sinteze
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects [get_runs synth_1]
launch_runs synth_1
wait_on_run synth_1
puts "*****************************************************"
puts "* Sinteza zavrsena! *"
puts "*****************************************************"

# KORAK#4: Pokretanje procesa implementacije
launch_runs impl_1