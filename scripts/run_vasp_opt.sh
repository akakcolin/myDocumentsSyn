#!/bin/bash

#SBATCH -J optall
#SBATCH -o log 
#SBATCH -e err
#SBATCH -N 1
#SBATCH -n 36 


source /data/oneapp/setvars.sh --force
source /data/intel/oneapi/setvars.sh --force
export I_MPI_CC=icc
export I_MPI_CXX=icpc
export I_MPI_FC=ifort
export I_MPI_F90=ifort
export OMP_NUM_THREADS=1
ulimit -s unlimited

##############################################################
#c Modify this part !!!
    VASPPATH="/data/oneapp/vasp/544/bin"
    vasp="vasp_std"
    vasplocation="$VASPPATH/$vasp"

    #c command to execute VASP calculation 
    runvasp="mpirun -np 16 $vasplocation"
    rsgradcommand="/data/bin/rsgrad rlx -v --no-magmom"
    rsgradlog="rsgradlog"

##############################################################

function one_vasp_opt () {
    echo "using INCAR " $1
    cp ../INCAR_opt_$1 INCAR
    $runvasp
    $rsgradcommand OUTCAR >> $rsgradlog
    cp CONTCAR POSCAR_opt_$1
    cp CONTCAR POSCAR
    cat OUTCAR >>outcars-opt
    rm running_$1
}

function one_vasp_opte () {
    echo "using INCAR " $1
    cp ../INCAR_opte_$1 INCAR
    $runvasp
    $rsgradcommand OUTCAR >> $rsgradlog
    cp CONTCAR POSCAR_opte_$1
    cp CONTCAR POSCAR
    cat OUTCAR >>outcars-opte
    rm running_state_$1
}


if [  -f running_1 ]; 
then
    echo " #Step  TOTEN_z/eV LgdE   Fmax #SCF Time/m   Vol/A3 1" >> $rsgradlog
    one_vasp_opt 1
fi

if [  -f running_2 ]; 
then
    echo " #Step  TOTEN_z/eV LgdE   Fmax #SCF Time/m   Vol/A3 2" >> $rsgradlog
    one_vasp_opt 2
fi

if [  -f running_3 ]; 
then
    echo " #Step  TOTEN_z/eV LgdE   Fmax #SCF Time/m   Vol/A3 3" >> $rsgradlog
    one_vasp_opt 3
fi

for i in 1 2 3 4 5 6 7 8 9 10
do

if [  -f running_state_$i ]; 
then
    echo " #Step  TOTEN_z/eV LgdE   Fmax #SCF Time/m   Vol/A3 $i" >> $rsgradlog
    one_vasp_opte $i
fi

done
