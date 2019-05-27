#!/encs/bin/tcsh

#$ -N MPM
#$ -cwd
#$ -m bea
#$ -pe smp 32
#$ -l h_vmem=500G

cd /private/k/kskoniec/a_hae
singularity shell -H /private/k/kskoniec/a_hae ubuntu.simg
source /private/k/kskoniec/a_hae/.bashrc
cd /private/k/kskoniec/a_hae/taichi/projects/mpm/scripts/mls-cpic
python3 tcFlow.py
