#!/usr/local/bin/gnuplot --persist
###########################################################################################################################
###########################################################################################################################
####                                                                                                                   ####
####   Gnuplot Script To plot Thermal_properties Output File From phonopy                                              ####
####   use to compare different dft method's free energy                                                               ####
####                                                                                                                   ####
###########################################################################################################################

if  (ARGC != 3){print "\n       Arguments Error... ";
print "===================================================================================================================="
print "  Usage: phonpy-proplot --gnuplot thermal_propertiey.yaml > A_thermal_properties.gp"
print "  Usage: paste A_thermal_propertiy.gp B_thermal_properties.gp C_thermal_properties.gp > A_thermal_properties "
print "  Usage: gnuplot -c pthermal_propertity.gp name 8 filename                                                            " 
print "====================================================================================================================\n"
exit
}

############################################################################################################
############################################################################################################
file2plot=ARG3
print "\n================================================="
print "File name                        : ", file2plot
print "Structure label                  : ", ARG1
print "Symmetry Operation number is     : ", ARG2
print "-------------------------------------------------\n"
############################################################################################################

set terminal epslatex standalone size 18cm,12cm color colortext
set output sprintf("thermal_d3_lj_dft_%s.tex",ARG1)

set style fill   solid 1.00 border lt -1
set grid nopolar
#set grid noxtics nomxtics ytics nomytics noztics nomztics nortics nomrtics \
# nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid layerdefault   lt 0 linecolor 0 linewidth 0.500,  lt 0 linecolor 0 linewidth 0.500
set style increment default

set style func linespoints

set key outside
set xrange [ * : * ] noreverse writeback
set x2range [ * : * ] noreverse writeback
set yrange [ * : * ] noreverse writeback
set y2range [ * : * ] noreverse writeback
set zrange [ * : * ] noreverse writeback
set cbrange [ * : * ] noreverse writeback
set rrange [ * : * ] noreverse writeback


set xlabel 'Temperature(K)'
set ylabel 'Error vs PBE-MBD (kJ/mol)'
#set label 1 at 50, 1 sprintf(ARG1)

set label 1 sprintf(ARG1) at 50, 17 font ",12 bold" textcolor rgb "black" 


set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2 pointtype 6 pointsize 1.5
set style line 2 linecolor rgb '#dd181f' linetype 1 linewidth 2 pointtype 6 pointsize 1.5
set style line 3 linecolor rgb '#a2142f' linetype 1 linewidth 2 pointtype 6 pointsize 1.5
set style line 4 linecolor rgb '#77ac30' linetype 1 linewidth 2 pointtype 6 pointsize 1.5


plot sprintf("%s", file2plot) using 1:($7 - $2)/ARG2  w lp ls 3 pt 4  t "F_{vib} (DFTB-D3)" ,\
     sprintf("%s", file2plot) using 1:($12 - $2)/ARG2 w lp ls 3 pt 5  t "F_{vib} (DFTB-LJ)",\
     sprintf("%s", file2plot) using 1:($2 - $2)/ARG2  w lp lt -1 lw 2  notitle,\
     sprintf("%s", file2plot) using 1:($3 - $8)*$1*0.001/ARG2 w lp ls 4 pt 8 t "-TS_{vib} (DFTB-D3)",\
     sprintf("%s", file2plot) using 1:($3-$13)*$1*0.001/ARG2  w lp ls 4 pt 9 t "-TS_{vib} (DFTB-LJ)",\
     sprintf("%s", file2plot) using 1:($10-$5)/ARG2 w lp ls 1 pt 6 t "H_{vib} (DFTB-D3)",\
     sprintf("%s", file2plot) using 1:($15-$5)/ARG2 w lp ls 1 pt 7 t "H_{vib} (DFTB-LJ)"

print "          ...Done\n" 
print "\nWriting Output file ---> ",sprintf("thermal_d3_lj_dft_%s.tex",ARG1),"\n"
