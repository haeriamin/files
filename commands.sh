# First Priority
* Model wheel-soil in MPM
* Generate training datasets via MPM-NGF
* Use graph-based dl to model granular flows and PCA to reduce problem dimension for real-time applications
* Add transient feature to MPM-NGF code (Capturing transient granular rheology with extended fabric tensor relations)
* Implement MPM-NGF as a plugin in Houdini (postdoc, better to be GPU-based)

# Publication
* J: Gravity paper
* J: Nonlocal paper
* J: Excavation paper
* C: Accurate real-time simulation method for traction control of space exploration rovers wheels

# Second Priority
* Model triaxial test in MPM like Sture
* Accuracy enhancement (grid-update, PolyPIC)
* Debug MPM code to support double precision for large stiffness=f(E,S)
* Code implicit-coupled-unsteady-nonlocal (uncoupled and explicit done)
* Get TC results at different levels
* Surface large deformation in reduced gravity (done)
* Ask Teran&Jiang about Hardening: dilation not friction angle in alpha
# Third Priority
* Kamrin scaling law vs Chris experiments
* Review all constitutive models
* Wheel-on-soil: rigidbody-dynamics (cancelled, done by Vortex)
* GPU support for MPM


# Graph Neural Network ---------------------------------------------------------
# Install dependencies:
pip install -r requirements.txt
mkdir -p ./learning_to_simulate/datasets
mkdir -p ./learning_to_simulate/models
mkdir -p ./learning_to_simulate/rollouts

# Download dataset (e.g. Sand):
bash ./learning_to_simulate/download_dataset.sh Sand ./learning_to_simulate/datasets

# Train a model:
python3 -m learning_to_simulate.train \
  --mode=train \
  --eval_split=train \
  --data_path=./learning_to_simulate/datasets/Excavation/D0.1m_S0.15ms-1_A10.0deg_M1.0 \
  --model_path=./learning_to_simulate/models/Excavation
  # --option

python3 -m learning_to_simulate.train \
  --mode=train \
  --eval_split=train \
  --data_path=./learning_to_simulate/datasets/Sand \
  --model_path=./learning_to_simulate/models/Sand

# Generate some trajectory rollouts on the test set:
python -m learning_to_simulate.train \
  --mode=eval_rollout \
  --data_path=./learning_to_simulate/datasets/ds_test/D0.1m_S0.1ms-1_A45.0deg_M2.0 \
  --model_path=./learning_to_simulate/models/ds_test \
  --output_path=./learning_to_simulate/rollouts/ds_test
  # --option

# Plot a trajectory:
python -m learning_to_simulate.render_rollout \
  --rollout_path=./learning_to_simulate/rollouts/ds_test/rollout_test_0.pkl


# Venv -------------------------------------------------------------------------
# Ubuntu:
  $ sudo apt install python3-venv
# Mac
1. Create venv in project dir: $ python3 -m venv ./venv
2. Activate venv $ source ./venv/bin/activate
3. Update pip: $ pip install --upgrade pip
4. Install venv pip packages: $ pip install -r requirements.txt
# Windows:
1. Create venv in project dir: $ python3 -m venv c:/users/NAME/.../venv
2. Activate venv: $ c:/users/.../venv/Scripts/activate.bat

# Remotely control OS Grub boot ------------------------------------------------
(via Chrome Remote Desktop OR Team Viewer)
$ sudo grub-reboot 2 && sudo reboot
$ sudo grub-reboot NUMBER && sudo reboot
To see NUMBER (starts from 0):
$ sudo add-apt-repository ppa:danielrichter2007/grub-customizer
$ sudo apt update
$ sudo apt install grub-customizer
$ grub-customizer
OR
$ awk -F\' '/menuentry / {print $2}' /boot/grub/grub.cfg 
If required see this:
https://www.trishtech.com/2017/09/quickly-add-windows-10-to-grub-menu-after-installing-ubuntu/

Change resolution:
$ gtf 1536 960 60
Copy the entire output STRING (except for the starting "Modeline")
$ xrandr --newmode STRING
Find display NAME (e.g. VGA1, DVI-I-1) by running $ xrandr
$ xrandr --addmode DVI-I-1 "1536x960_60.00"


# Login NAS --------------------------------------------------------------------
1. In terminal:
  /usr/bin/ssh a_hae@login.encs.concordia.ca -o "TCPKeepAlive=yes" -L5000:192.168.129.144:5000 -L23022:192.168.129.144:23022
  http://localhost:5000
2. Open Filezilla
  sftp://localhost - a_haeri - C... - 23022


# Run Matlab from VSCode -------------------------------------------------------
$ export PATH=$PATH:/Applications/Polyspace/R2020a.app/bin/
$ cd ...
$ matlab -nodesktop -nosplash -r "1"


# Install Taichi & MPM in Ubuntu -----------------------------------------------
$ sudo apt install gcc python3-pip
$ sudo apt-get install -y python3-dev git build-essential cmake make g++ libx11-dev python3-pyqt5 libtbb2 libtbb-dev
$ sudo -H pip3 install numpy scipy pybind11 Flask flask_cors gitpython yapf psutil pyqt5==5.14.0
$ wget https://raw.githubusercontent.com/yuanming-hu/taichi/legacy/install.py
$ sudo -H python3 install.py
$ source  ~/.bashrc
Create a file called taichi and replace the current taichi with it!
$ sudo rm -R taichi
# $ sudo chown -R "$USER":"$USER" ~/.local/lib
modify /python/taichi/main.py: 'mpm': 'https://github.com/haeriamin/mpm',
$ ti install mpm
Replace some files (include/taichi, data, scripts, src, etc) with yours
Make some changes in codes
$ ti build
# $ sudo chown $USER -R taichi
If required:
  $ sudo rm -R taichi
Build with Double Precision (64 bit) Float Point (debugging required e.g. POT):
  $ export TC_USE_DOUBLE=1
  $ ti build


# Houdini tips -----------------------------------------------------------------
press D to change the settings
add attribute wringle
add color
add visualize
Ruler: https://vimeo.com/204595987


# Singularity 2.6.1 ------------------------------------------------------------
singularity pull docker://ahaeri/docker-custom-tensorflow
singularity pull docker://tensorflow/tensorflow:1.15.4-gpu-py3
singularity pull shub://haeriamin/singularity-ubuntu:1804gn
singularity pull shub://haeriamin/singularity-ubuntu:1804mpm
mv haeriamin-singularity-ubuntu-master-1604.simg ubuntu.simg
singularity shell -H /private/k/kskoniec/a_hae ubuntu.simg
singularity exec -H /private/k/kskoniec/a_hae ubuntu.simg /bin/bash
singularity exec ubuntu.simg /bin/bash python install.py


# Singularity + MPM ------------------------------------------------------------
cd ~
wget https://github.com/haeriamin/files/blob/master/taichi.zip
pip install subprocess.run
cd ~
wget https://github.com/haeriamin/files/blob/master/taichinstaller.py
python3 taichinstaller.py
wget https://github.com/haeriamin/files/blob/master/main.py
yes | cp -rf ~/main.py ~/taichi/python/taichi
rm -fr main.py
cd ~/taichi/python/taichi
source ~/.bashrc
ti install mpm
source ~/.bashrc


# Install taichi & mpm on Speed ------------------------------------------------
wget https://github.com/haeriamin/files/blob/master/taichinstaller.py
python3 taichinstaller.py # customized
# add-it-to-bashrc: export PATH="/private/k/kskoniec/a_hae/.local/bin:$PATH"
modify-main.py: 'mpm': 'https://github.com/haeriamin/mpm',
ti build
ti install mpm


# Post processing --------------------------------------------------------------
Download from http://www.ffmpeg.org
ffmpeg -framerate 30 -i untitled%d.jpg -c:v libx264 -profile:v high -crf 18 -pix_fmt yuv420p output.mp4
ffmpeg -framerate 60 -i untitled%d.jpg -c:v libx264 -profile:v high -crf 18 -pix_fmt yuv420p output.mp4
ffmpeg -framerate 30 -start_number 61 -i untitled%d.jpg -c:v libx264 -profile:v high -crf 18 -pix_fmt yuv420p output.mp4

# split zip file
zip -s 15000m mg_old mg_.35_.3_40.zip

# ssh:
rsync -v -e ssh ~/Desktop a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/install.py
rsync -v -e ssh ~/Desktop/install.py a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae
rsync -avzhe ssh /Volumes/Z/taichi a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/taichi
rsync -avzhe ssh a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/taichi/outputs/mpm/tcFlow/files.tar.gz /Volumes/X/
To zip on mac/ubuntu:
  tar cvfz NAME.tar.gz NAME
To unzip:
  tar -zxvf NAME.tar.gz
To delete:
  rm -f NAME.tar.gz // -rf for DIRS
To rename:
  mv A.simg B.simg
To move:
  mv ./A ./B
To see the used space:
  du -msh a_hae
  du -m a_hae
vim ~/.bashrc
/private/k/kskoniec/a_hae/opt/python-3.6.2/bin/python3 install.py
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
To create: vim NAME.sh
To delete all: :%d THEN PRESS return
To paste: :set paste THEN cmmnd+v
To save&exit: :wq
To exit: :q

# run:
ssh a_hae@speed-submit.encs.concordia.ca
cd /private/k/kskoniec/a_hae
source /local/pkg/uge-8.6.3/root/default/common/settings.csh
For batch-job-session:
  qsub -q g.q ./tcsh_gpu.sh
  qsub -q g.q ./tcsh_gpu_test.sh
  qsub ./tcsh_cpu.sh
For interactive-job-session:
  qlogin -N MPM -pe smp 32 -l h_vmem=32G

singularity shell -H /private/k/kskoniec/a_hae SIMG
singularity exec -H --nv tensorflow-1.15.4-gpu-py3.simg /bin/bash ./deep_granular_flows/learning_to_simulate/run_excavation_speed.sh
source ~/.bashrc
cd /private/k/kskoniec/a_hae/taichi/projects/mpm/scripts/mls-cpic
python3 tcFlow.py
qstat -F g

# job management 
qstat -f -u "*" : display cluster status for all users
qstat -j [job-ID] : display job information for [job-ID] (said job may be actually running, or waiting in the queue)
qdel [job-ID] : delete job [job-ID]
qhold [job-ID] : hold queued job, [job-ID], from running
qrls [job-ID] : release held job [job-ID]
qacct -j [job-ID] : get job stats. for completed job [job-ID]. maxvmem is one of the more useful stats
ssh <username>@speed[-05|-17] nvidia-smi
ssh speed-05 nvidia-smi

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


# spec comparison --------------------------------------------------------------
local:  Intel(R) Core(TM)  i7 6700 CPU @ 3.40GHz  4-core
server: Intel(R) Xeon(R) Gold 6130 CPU @ 2.10GHz 16-core
Peak-FLOPS = (CPU-speed-in-GHz) x (number-of-CPU-cores) x
             (CPU-instruction-per-cycle) x (number-of-CPUs-per-node)
GFLOPS = 217.6
       = 665.6
GFLOPS_Ratio = 665.6/217.6 = 3.1
RunTime_Ratio = 24/20 = 1.2
# Threading Building Blocks (TBB): time complexity and run time comparison
sec--mode---loc8--serv32--
22  -b208B  24h   20h
22  -c256B  30h   22h

* xbox series x = 12000 GFLOPS


# Vortex Installation + Python API ---------------------------------------------
1. Install Vortex SDK:
  - Install MVS2015 with VC14, and Windows SDK 10 (if required)
  - Install nVidia driver:
      441.28-quadro-desktop-notebook-win8win7-64bit-international-whql
      OR
      441.28-quadro-desktop-notebook-win10-64bit-international-whql
  - Install Python2 (if required): Anaconda2-4.3.0.1-Windows-x86_64
  - Install Vortex
  - Add License
  - Add vortex to Windows path (e.g. ;C:\CM Labs\Vortex Studio 2019b\bin\;)
2. Install Vortex Earthwork extension
3. Copy 'editor-no-gfx.vxc' file in:
    C:\CM Labs\Vortex Studio 2019b\resources\config
4. In MVS, right-click on the application:
  - In General, set Interpreter to
      Python 64-bit 2.7
  - In Debug, set Search Paths to
      e.g. C:\CM Labs\Vortex Studio 2019b\bin
5. Install Partio (Python API)
  - Install CMake (.msi)
      https://cmake.org/download/
      https://cognitivewaves.wordpress.com/cmake-and-visual-studio/
  - Install freeGLUT 64-bit (and perhaps GLEW)
      https://blog.albertarmea.com/post/40667525183/installing-glut-on-windows
  - Install doxygen (.exe)
      http://www.doxygen.nl/download.html
  - Install SWIG
      https://www.dev2qa.com/how-to-install-swig-on-macos-linux-and-windows/
  * Make sure they are added to Windows Path (or add them)
  - Comment ZLIB lines in  /partio-master/CMakeLists.txt except "SET (ZLIB_LIBRARY "")"
  - Install Partio (or use pre-installed version)
      - Use correct version of MVS (e.g. MVS 14 2015) and set it to x64
      - Configure -> Set output directory (e.g. C:/partio-install27) -> Generate -> Open Project
      - Add "LINK_DIRECTORIES(C:/Users/umroot/Anaconda2/libs)" to /partio-master/src/py/CMakeLists.txt
      - In MVS project of Partio
          0. Set to Release
          1. partio: Right-click -> Set as StartUp project
                      Right-click -> Propertise ->
                                      Target Extension -> .lib
                                      Configuration Type -> Static library (.lib)
          2. Delete "None/None.lib;" from /partio-master/build/src/py/_partio.vcxproj (in Release part)
          3. _partio: Right-click -> Project Only -> Build Only _partio
          4. partio: Right-click -> Set as StartUp project
                      Right-click -> Propertise ->
                                      Target Extension -> .dll
                                      Configuration Type -> Dynamic library (.dll)
          5. INSTALL: Right-click -> Project Only -> Build Only INSTALL
      - Copy files from /partio_install27/lib/python2.7/site-packages/ to /Anaconda2/Lib/site-packages/

# Vortex C++ SDK ---------------------------------------------------------------
In MVS:
  - Set Solution Configurations to
    ReleaseDebInfo
  - RightClick->Properties
    TargetPlatformVersion: 10...
    Platform Toolset: v140
  - RightClick->Build
  - RightClick->Set as StartUp Project
  - Run

# Tax 2018 ---------------------------------------------------------------------
# Promissed:
Federal: 
  federal tax return: 0
  GST tax credit: 864 (= 284 + 580)

Quebec:  
  Quebec tax return: 100.26
  Quebec Solidarity tax credit: 1271

# Received:
Federal: 1361.5 (= 140 + 290 + 641.5 + 145 + 145)
Quebec:  100.26