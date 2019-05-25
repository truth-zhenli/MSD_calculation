# MSD_calculation
This VMD/Tcl script provides an alternative to "gmx msd" (a GROMACS command), for calculating mean square displacement (MSD) using GROMACS trajectory.
Actually, the "gmx msd" command is much more efficient, and it provides more options.


# How to use

## Requirements
- First, VMD (https://www.ks.uiuc.edu/Research/vmd/) should be installed.
- Second, a GROMACS molecular structure file (.gro file) and a GROMACS trajectory file (.xtc file) should be prepared.

## Note
The .xtc file should be pre-treated using GROMACS command "gmx trjconv" (http://manual.gromacs.org/documentation/2018/onlinehelp/gmx-trjconv.html), to ensure that:
- All frames are at the equilibrated simulation state.
- All molecules remain whole and nojump (it is a continuous trajectory and molecules may diffuse out of the box).

## Quick start
1. Put the .xtc file, the .gro file, and the .tcl script in the same directory.
2. Open VMD TkConsole or command terminal, and navigate to the above directory.
3. Execute the MSD.tcl script with command "source MSD.tcl".
4. Just wait, and you will get data (in an output-msd.dat file) for MSD plotting.

