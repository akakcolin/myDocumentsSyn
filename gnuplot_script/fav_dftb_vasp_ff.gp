set terminal epslatex standalone lw 2 color 11
set output 'fav_dftb_FF.tex'
set style fill   solid 1.00 border lt -1
set xlabel "Favip FF-st files's id" 
set ylabel '$\Delta$ Energy between cellopt2 and cg (KJ/mol)'
set grid nopolar
set grid noxtics nomxtics ytics nomytics noztics nomztics nortics nomrtics \
 nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid layerdefault   lt 0 linecolor 0 linewidth 0.500,  lt 0 linecolor 0 linewidth 0.500
set style increment default
set xrange [ * : * ] noreverse writeback
set x2range [ * : * ] noreverse writeback
set yrange [ * : * ] noreverse writeback
set y2range [ * : * ] noreverse writeback
set zrange [ * : * ] noreverse writeback
set cbrange [ * : * ] noreverse writeback
set rrange [ * : * ] noreverse writeback
plot 'f1.dat' title "DFTB optimization (cellopt2-cg)" with points pt 7, 'f2.dat'  title "VASP SP (cellopt2-cg)" with points pt 7
