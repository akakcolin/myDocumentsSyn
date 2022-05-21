END=190
for i in $(seq 0 $END)
do 
    echo $i
    cp pos_$i.vasp  POSCAR
    atomsk POSCAR $i.cfg
    echo "$i.cfg pic/$i.png" >> scr_anim
done

