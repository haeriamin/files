#!/encs/bin/tcsh

#$ -N MPM
#$ -cwd
#$ -m bea
#$ -pe smp 32
#$ -l h_vmem=500G

singularity shell -H /private/k/kskoniec/a_hae /private/k/kskoniec/a_hae/ubuntu.simg
source ~/.bashrc
cd /private/k/kskoniec/a_hae/taichi/projects/mpm/scripts/mls-cpic
python3 tcFlow.py
