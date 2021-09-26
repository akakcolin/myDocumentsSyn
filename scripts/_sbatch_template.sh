#!/bin/bash

#SBATCH -J _jobname 
#SBATCH -o _jobnamelogfile
#SBATCH -e _jobnameerrfile
#SBATCH -N 1
#SBATCH -n 36

#SBATCH -p xxx


source /opt/oneapp/setvars.sh --force
export OMP_NUM_THREADS=1
ulimit -s unlimited
#_file
_input
