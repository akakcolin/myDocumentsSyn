set terminal epslatex standalone size 18cm,12cm color colortext linewidth 2
set style fill   solid 1.00 border lt -1
#set grid nopolar
set grid
ev2kj=96.4853905398362
set title "Total energy vs NSW"
set style data points
#set key right
set xlabel 'NSW'
set ylabel 'Total energy (KJ/mol)'

set style line 11 lt 1 lc rgb '#0072bd' # blue

set style line 12 lt 1 lc rgb '#d95319' # orange
set style line 13 lt 1 lc rgb '#edb120' # yellow
set style line 14 lt 1 lc rgb '#7e2f8e' # purple
set style line 15 lt 1 lc rgb '#77ac30' # green
set style line 16 lt 1 lc rgb '#4dbeee' # light-blue
set style line 17 lt 1 lc rgb '#a2142f' # red

set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 1 pointtype 6 pointsize 1.
set style line 2 linecolor rgb '#dd181f' linetype 1 linewidth 1 pointtype 6 pointsize 1.
set style line 3 linecolor rgb '#a2142f' linetype 1 linewidth 1 pointtype 6 pointsize 1.
set style line 4 linecolor rgb '#77ac30' linetype 1 linewidth 1 pointtype 6 pointsize 1.
set style line 5 linecolor rgb '#d95319' linetype 1 linewidth 1 pointtype 6 pointsize 1.
set xrange [1:300]
files=system("ls -1B  plott   | sort")
do for [ file in files ] {
    o1 = sprintf('plott/%s/ga.log', file)
    o4 = sprintf('plott/%s/ga2.log', file)
    o5 = sprintf('plott/%s/ga3.log', file)
    o2 = sprintf('plott/%s/co2', file)
    o6 = sprintf('plott/%s/geo', file)
    o3 = sprintf('plott/%s/dyn.log', file)
    set output "temp.tex"
    plot o3 using ($4*ev2kj);
    min_y = GPVAL_DATA_Y_MIN;
    unset output

    out = sprintf('%s.tex',file)
    set output out
    t1 = sprintf('%s-ga', file)
    t4 = sprintf('%s-ga2', file)
    t5 = sprintf('%s-ga3', file)
    t2 = sprintf('%s-cellopt2', file)
    t3 = sprintf('%s-asebfgs', file)
    t6 = sprintf('%s-bfgs', file)
    plot o1 using ($2*ev2kj-min_y) w l  t t1,\
    o4 using ($2*ev2kj-min_y) w l t t4,\
    o5 using ($2*ev2kj-min_y) w l  t t5,\
    o2 using ($7*ev2kj-min_y) w l  t t2, \
    o6 using ($7*ev2kj-min_y) w l  t t6, \
    o3 using( $4*ev2kj-min_y) w l  t t3

}
