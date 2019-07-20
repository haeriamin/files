# Singularity 2.6.1:
singularity pull shub://haeriamin/singularity-ubuntu:1604
mv haeriamin-singularity-ubuntu-master-1604.simg ubuntu.simg
singularity shell -H /private/k/kskoniec/a_hae ubuntu.simg
singularity exec -H /private/k/kskoniec/a_hae ubuntu.simg /bin/bash
singularity exec ubuntu.simg /bin/bash python install.py

# install taichi & mpm:
wget https://github.com/haeriamin/files/blob/master/taichinstaller.py
python3 taichinstaller.py # customized
# add-it-to-bashrc: export PATH="/private/k/kskoniec/a_hae/.local/bin:$PATH"
modify-main.py: 'mpm': 'https://github.com/haeriamin/mpm',
ti build
ti install mpm

# post processing:
ffmpeg -framerate 50 -i untitled%d.jpg -c:v libx264 -profile:v high -crf 18 -pix_fmt yuv420p output.mp4
ffmpeg -framerate 50 -start_number 15 -i untitled%d.jpg -c:v libx264 -profile:v high -crf 18 -pix_fmt yuv420p output.mp4

# split zip file
zip -s 15000m mg_old mg_.35_.3_40.zip

# Houdini
press D to change the settings
add attribute wringle
add color
add visualize

# ssh:
rsync -v -e ssh ~/Desktop a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/install.py
rsync -v -e ssh ~/Desktop/install.py a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae
rsync -avzhe ssh /Volumes/Z/taichi a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/taichi
rsync -avzhe ssh a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/taichi/outputs/mpm/tcFlow/files.tar.gz /Volumes/X/
to zip on mac: tar cvfz mpmCode.tar.gz mpmCode
to unzip on server: tar -zxvf modules-4.2.3.tar.gz
to delete on server: rm -f modules-4.2.3.tar.gz // -r for dirs
to rename: mv pavel-demin-singularity-ubuntu-master-1804.simg ubuntu.simg
/private/k/kskoniec/a_hae/opt/python-3.6.2/bin/python3 install.py
vim ~/.bashrc
see the used space: du -msh a_hae // du -m a_hae
module avail
module load python/3.5.1/default
module load gcc/5.1/default
check os version: cat /etc/*release
copy: cp /home/n/nul-uge/tcsh.sh /private/k/kskoniec/a_hae
check cpu: lscpu | grep -E '^Thread|^Core|^Socket|^CPU\('
check ram: egrep --color 'Mem|Cache|Swap' /proc/meminfo
check ram: free -m
check status: qstat -f -u "*"

# vim
delete all: dG
paste: :set paste OR :set nopaste
save&exit: :wq
exit: :q

# run:
ssh a_hae@speed-submit.encs.concordia.ca
cd /private/k/kskoniec/a_hae
source /local/pkg/uge-8.6.3/root/default/common/settings.csh
for-interactive-job-session: qlogin -N MPM -pe smp 32 -l h_vmem=500G
cd /private/k/kskoniec/a_hae
for-batch-job-session: qsub ./tcsh.sh
singularity shell -H /private/k/kskoniec/a_hae ubuntu.simg
source ~/.bashrc
cd /private/k/kskoniec/a_hae/taichi/projects/mpm/scripts/mls-cpic
python3 tcFlow.py

# job management
qstat -f -u "*" : display cluster status for all users
qstat -j [job-ID] : display job information for [job-ID] (said job may be actually running, or waiting in the queue)
qdel [job-ID] : delete job [job-ID]
qhold [job-ID] : hold queued job, [job-ID], from running
qrls [job-ID] : release held job [job-ID]
qacct -j [job-ID] : get job stats. for completed job [job-ID]. maxvmem is one of the more useful stats

# modify:
rsync -v -e ssh /Volumes/X/MPM/Speed/tcsh.sh a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae
rsync -avzhe ssh /Volumes/Z/taichi/projects/mpm/data/ a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/taichi/projects/mpm/data
rsync -avzhe ssh /Volumes/Z/taichi/projects/mpm/scripts/mls-cpic/ a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/taichi/projects/mpm/scripts/mls-cpic
rsync -avzhe ssh /Volumes/Z/taichi/projects/mpm/src/ a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/taichi/projects/mpm/src
rsync -avzhe ssh /Volumes/Z/taichi/projects/mpm/scripts/mls-cpic/tcFlow.py a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/taichi/projects/mpm/scripts/mls-cpic
cd /private/k/kskoniec/a_hae/taichi/projects/mpm/src/ # a file in this folder should be changed using vim not rsync
cd /private/k/kskoniec/a_hae/taichi/python/taichi
ti build

# results:
cd /private/k/kskoniec/a_hae/taichi/outputs/mpm/
rsync -avzhe ssh a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/taichi/outputs/mpm/tcFlow /Volumes/X

singularity exec -H /private/k/kskoniec/a_hae ubuntu.simg python3 /private/k/kskoniec/a_hae/taichi/projects/mpm/scripts/mls-cpic/tcFlow.py
singularity run -H /private/k/kskoniec/a_hae ubuntu.simg source ~/.bashrc
singularity instance.start ubuntu.simg MPM
singularity instance.stop ubuntu.simg MPM
singularity exec -H /private/k/kskoniec/a_hae ubuntu.simg /bin/bash
singularity exec -H /private/k/kskoniec/a_hae ubuntu.simg ls -a
singularity exec -H /private/k/kskoniec/a_hae ubuntu.simg . /.bashrc

echo 'export PATH="~/.local/bin:$PATH"' >> ~/.bashrc

export TAICHI_NUM_THREADS=32
export PATH="/private/k/kskoniec/a_hae/.local/bin:$PATH"
export TAICHI_REPO_DIR=/private/k/kskoniec/a_hae/taichi
export PYTHONPATH=$TAICHI_REPO_DIR/python/:$PYTHONPATH
export PATH=$TAICHI_REPO_DIR/bin/:$PATH

#-------------------------------------------------------------------------------
# spec comparison
local:  Intel(R) Core(TM)  i7 6700 CPU @ 3.40GHz  4-core
server: Intel(R) Xeon(R) Gold 6130 CPU @ 2.10GHz 16-core
Peak-FLOPS = (CPU-speed-in-GHz) x (number-of-CPU-cores) x
             (CPU-instruction-per-cycle) x (number-of-CPUs-per-node)
GFLOPS = 217.6
       = 665.6
GFLOPS_Ratio = 665.6/217.6 = 3.1
RunTime_Ratio = 24/20 = 1.2
# Threading Building Blocks (TBB): time complexity and run time comparison
frame--mode---loc8--serv32--
1100  -b208B  24h   20h
1100  -c256B  30h   22h

#-------------------------------------------------------------------------------
# short-term TODOs:
* results at different levels (Thu)
# long-term TODOs: (?)
* Journal-paper
* Ask Teran&Jiang about hardening: dilation not friction angle in alpha
* Constitutive models
    a. Size (& shape) effect to study flow segragation -> coupled-unsteady-nonlocal
    b. Other models (pres-summary, review-paper)
* Accuracy enhancement (grid-update, polyPIC)
* Wheel-on-soil -> rigidbody-dynamics
* GPU support
