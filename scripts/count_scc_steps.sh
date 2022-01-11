#!/bin/bash

grep -B 2 "Total Energy" dftb.out  | grep -v Total | grep -v "\-\-" | awk '{n+=1; print n, $1; getline}' > scc_steps.dat
