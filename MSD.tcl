#!/usr/local/bin/vmd

#load Gromacs trajectory
set mol [mol new test.gro type gro waitfor all]
mol addfile test.xtc type xtc waitfor all
set nf [molinfo $mol get numframes]

# time delta between frames (in ns)
set delt 1
# atom selection string
set residuename "resname DOPC"
set atmname "name PO4"  ;# for looping over residues
# output filename
set outfile "output-msd.dat"

########################################################################
# no user servicable parts below
########################################################################

set sel [atomselect $mol "$atmname and $residuename"]
set idxlist [$sel get index]
set tracenum [$sel num]
set traceid 0
$sel delete

for {set i 1} {$i < $nf} {incr i} {
    set msd($i) 0.0
	set nummsd($i) 0
}

# loop over residues
foreach idx $idxlist {
	incr traceid
    puts "processing residue: $traceid/$tracenum"
    set poslist {}
    set sel [atomselect $mol "same resid as (index $idx) and $residuename"]

    # fill poslist
    for {set i 1} {$i < $nf} {incr i} {
        $sel frame $i
        lappend poslist [measure center $sel]
    }
	
	for {set i 1} {$i < [expr $nf - 1]} {incr i} {
		set ref [lindex $poslist 0]
		set poslist [lrange $poslist 1 end]
		set j 1
		foreach pos $poslist {
			# for the total MSD: set msd($j) [expr $msd($j) + [veclength2 [vecsub $ref $pos]]]
			# for lateral MSD in x-y plane: 
			set msd($j) [expr $msd($j) + [veclength2 "[lindex [vecsub $ref $pos] 0] [lindex [vecsub $ref $pos] 1]"]]
			# for MSD in z direction: set msd($j) [expr $msd($j) + [veclength2 [lindex [vecsub $ref $pos] 2]]]
			incr nummsd($j)
			incr j  
		}
	} 
    $sel delete
}

set tval {0}
set msdval {0}

# normalize and build lists for output
for {set i 1} {$i < [expr $nf - 1]} {incr i} {
    lappend tval [expr $delt * $i]
    lappend msdval [format %.6f [expr $msd($i)/$nummsd($i)]]
}

# output
set fp [open $outfile w]
puts $fp "dt(ns) \t MSD(Angstrom^2)"
foreach t $tval m $msdval {
    puts $fp "$t \t $m"
}
close $fp

