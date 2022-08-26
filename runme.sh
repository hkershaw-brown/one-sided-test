#!/bin/bash


mpis=( $(module -t avail openmpi 2>&1))
for i in "${mpis[@]:1}"
do

  echo $i
  module load $i
  mpif90 f_example.f90
  mpirun -n 2 ./a.out

  echo "-----------"
  echo "-----------"
  echo "-----------"
  echo "-----------"

done
