set pt_scripts [open "my_pt.tcl"]
set lineNumber 0
set flag 0
set output_file my_innECO.tcl
echo "setEcoMode -batchMode false" > $output_file
echo "setEcoMode -updateTiming false -honorDontTouch false -honorDontUse false -honorFixedNetWire false -honorFixedStatus false -refinePlace false" >> $output_file
echo "setEcoMode -batchMode true" >> $output_file
echo "setEcoMode -honorDontTouch false -honorDontUse false -honorFixedNetWire false -honorFixedStatus false" >> $output_file

while {[gets $pt_scripts line] >= 0} {
    incr lineNumber
    set num [llength $line]
    if {[regexp {current_instance} $line]} {
        set flag 1
        if {$flag} {
            echo ""
            set hir ""
            if {$num != 1} {
                set hir [lindex $line 1]
            }
        }
    } else {
        if {$flag} {
            set inst_name ${hir}/[lindex $line 1]
            set cell [lindex $line 2]
            set eco_mode [lindex $line 0]
            switch -glob $eco_mode {
                size_cell {
                    echo "ecoChangeCell -inst $inst_name -cell $cell" >> $output_file
                }
                insert_buffer {
                    echo $line
                }
                add_buffer_on* {
                    echo $line
                }
                default {
                    echo "ERROR,Please check line $lineNumber, $line"
                }
            }
        }
    }
}
