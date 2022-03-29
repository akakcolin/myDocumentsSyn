set terminal epslatex standalone size 18cm,12cm color colortext linewidth 2
set style fill   solid 1.00 border lt -1
#set grid nopolar
set grid
set title "Max Force vs NSW "
set style data points
#set key right
set xlabel 'NSW'
set ylabel 'Max Force'
ev2kj=1



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


do for [t=1:50] {
out = sprintf('oms_sp_f_%i.tex',t)
set output out
outfile1 = sprintf('sp-nei/%i/log',t)
outfile2 = sprintf('sp/%i/log',t)
t1 = sprintf('%i-normal', t)
t2 = sprintf('%i-wave', t)
plot outfile1 using ($4*ev2kj) w lp ls 3 pt 4 t t1, outfile2 using ($4*ev2kj) w lp ls 3 pt 5 t t2
}
