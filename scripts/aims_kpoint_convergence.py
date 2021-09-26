#!/usr/bin/env python
import numpy as np

from ase.io import read
from ase.constraints import UnitCellFilter
from ase.optimize import BFGSLineSearch as BFGS
from ase.calculators.socketio import SocketIOCalculator
from ase.calculators.aims import Aims

from optparse import OptionParser
import os
import sys

usage = """%prog [options] xxx.cif/POSCAR"""
parser = OptionParser(usage)
(options, args) = parser.parse_args()
atoms= read(args[0], format='vasp')


# read input geometry that should be relaxed
#atoms = read("geometry.in", 0, "aims")

# user settings (adjust!)
# choose a name for an aims working directory
workdir = "aims"
port = 12345
log_name = "relax.log"
trajectory_name = "relax.traj"

usr_settings = {
    "aims_command": "mpirun -np 24 /opt/oneapp/aims/latest/bin/aims.190903.scalapack.mpi.x",
    "species_dir": "/opt/oneapp/aims/latest/species_defaults/light",
    "output_level": "MD_light",
    "outfilename": "aims.out",
}

# dft settings (adjust!)
dft_settings = {
    "xc": "pbe",
    "relativistic": "atomic_zora scalar",
    "vdw_correction_hirshfeld": True,
    "sc_accuracy_rho": 1e-6,
    "k_grid": [1, 1, 1],
    #"compute_forces": True,
    #"compute_analytical_stress": True,
    #"relax_geometry bfgs": 0.001,
    #"relax_unit_cell": "full",
    #"restart_relaxations": True,

#
}

#aux_settings = {"label": workdir}


k_points = [k for k in range(1, 8, 1)]
energies = []
for index, k in enumerate(k_points):
    dft_settings['k_grid']=[k, k, k]
    usr_settings['outfilename'] = "aims/aims_k_"+str(k)+".out"
    print(dft_settings['k_grid'])
    calc = Aims(**usr_settings, **dft_settings)
    atoms.set_calculator(calc)
    energy = atoms.get_potential_energy()
    print(energy)
    energies.append(energy)

plt.plot(k_points, energies, '-o')
plt.xlabel('Number of k-points (k x k x k)')
plt.ylabel('Total Energy (eV)')
plt.title('FHI-aims KPOINTS test')
plt.savefig('images/k_convergence.png')
plt.close()
