#!/bin/bash


mpis=( $(module -t avail openmpi 2>&1))
for i in "${mpis[@]:1}"
do

  echo $i
  module load $i
  mpicc c_example.c
  mpirun -n 2 ./a.out

  echo "----ccc----"
  echo "----ccc----"
  echo "----ccc----"
  echo "----ccc----"

done
