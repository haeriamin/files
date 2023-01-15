### Crypto --------------------------------------------------------------------
## Plan 
<CURRENT>
- Simulate with 100 shares
  - Get simulation data (after training data)

- Get coin data correctly with volume and marketcap
- Research different GNNs
- Learn trading via CoinBase
  - Get driver's license

<NEXT>
- Deploy
  - Manual (every day): Predict, Buy/Sell/Hold, Retrain (continual learning to avoid model drift)
  - Automatic: Flask, Docker/Kubernetes, Local/cloud cluster
    - https://towardsdatascience.com/how-to-apply-continual-learning-to-your-machine-learning-models-4754adcd7f7f

<OPTIONAL>
- Implement XGB to detect data drift (train vs real-world)
- Find cloud gpu and cluster or Buy PC
- Use DTW (instead of XCorr)


## Conda 
Install miniconda for python 3.8
conda info
conda update conda
conda create --name crypto_conda_env
conda activate crypto_conda_env
conda env list
conda list
conda deactivate
conda install ***
OR
conda install pip
/Users/aminhaeri/opt/miniconda3/envs/crypto_conda_env/bin/pip install -r req_1.txt
/Users/aminhaeri/opt/miniconda3/envs/crypto_conda_env/bin/pip install fastdtw
tensorboard --logdir="./logs"


### UChicago ---------------------------------------------------------------
# Plan
  - Check director field stats (how a node direction changes in time)
  - Predict angles directly 
    - Check node and edge features (should be angles not their change)
  - Increase batch size
  - Check connectivity radius
  - Find relationship between modes
  - 
  - Detect half integer point defects and learn their movements

# SSH
ssh -Y haeri@midway2.rcc.uchicago.edu

cd /project2/depablo/ming/active_nematics_for_Amin/Subspace_Graph_Liquid_Crystal/

scp -r haeri@midway2.rcc.uchicago.edu:/project2/depablo/ming/active_nematics_for_Amin/Subspace_Graph_Liquid_Crystal/learning_to_simulate/models/LiquidCrystal_PCA/ /Volumes/X/DeepLiquidCrystals/learning_to_simulate/models/LiquidCrystal_PCA/

tensorboard --logdir="./learning_to_simulate/models/LiquidCrystal_PCA" 

## ML Code
# To copy
scp -r /Volumes/X/Subspace_Graph_Liquid_Crystal/ haeri@midway2.rcc.uchicago.edu:
# Docker
docker build ./ -f Dockerfile -t tf1gpu
docker save tf1gpu | gzip > tf1gpu.tar.gz
scp -r /Volumes/X/Subspace_Graph_Liquid_Crystal/docker/tf1gpu.tar.gz haeri@midway2.rcc.uchicago.edu:
scp -r /Volumes/X/Subspace_Graph_Liquid_Crystal/docker/Dockerfile haeri@midway2.rcc.uchicago.edu:
scp -r /Volumes/X/Subspace_Graph_Liquid_Crystal/docker/Singularity.def haeri@midway2.rcc.uchicago.edu:

scp -r haeri@midway2.rcc.uchicago.edu:/project2/depablo/ming/active_nematics_for_Amin/Subspace_Graph_Liquid_Crystal/learning_to_simulate/datasets/LiquidCrystal_PCA/ /Volumes/X/DeepLiquidCrystals/learning_to_simulate/datasets/LiquidCrystal_PCA


scp -r /Volumes/X/DeepLiquidCrystals/learning_to_simulate/datasets/LiquidCrystal_PCA haeri@midway2.rcc.uchicago.edu:/project2/depablo/ming/active_nematics_for_Amin/Subspace_Graph_Liquid_Crystal/learning_to_simulate/datasets/

singularity build tf1gpu.simg docker-archive://tf1gpu.tar.gz
--OR (Locally) --
pip3 install spython
spython recipe Dockerfile &> Singularity.def
singularity build tf1gpu.simg Singularity.def <NOT POSSIBLE on SSH>
singularity build tf1gpu.simg Dockerfile <NOT POSSIBLE on SSH>
# On SSH
cd /project2/depablo/ming/active_nematics_for_Amin/Subspace_Graph_Liquid_Crystal/
du -sh ***  # check file size
midway2: module load cuda/10.1
midway3: module load cuda/10.2
mv ./nematics_3d/ /project2/depablo/ming/active_nematics_for_Amin/nematics_3d/
module load singularity
# To check modules
  module avail ***
  module list
# To zip on mac/ubuntu:
  tar cvfz NAME.tar.gz NAME
# To unzip:
  tar -zxvf NAME.tar.gz
# To see the used space:
  du -msh .
  du -m .

# commands
ssh -Y haeri@midway2.rcc.uchicago.edu
cd /project2/depablo/ming/active_nematics_for_Amin/Subspace_Graph_Liquid_Crystal/
cat 1_data_b.err
cat 1_data_b.out
cat 3_train.err

module load singularity
module load cuda/10.0

sbatch ./run_data_1.sh
sbatch ./run_data_2.sh
sbatch ./run_train.sh
squeue --user=haeri
scancel 21875067
rcchelp usage --byjob
rcchelp qos

# Generate PCA loading vector
singularity exec -H /project2/depablo/ming/active_nematics_for_Amin/Subspace_Graph_Liquid_Crystal ./tf1gpu.simg python -m subspace_data.1_pca_matrix
# Generate TFRecords
singularity exec -H /project2/depablo/ming/active_nematics_for_Amin/Subspace_Graph_Liquid_Crystal ./tf1gpu.simg python -m subspace_data.2_run_tfrecord_pca
# Train
singularity exec -H /project2/depablo/ming/active_nematics_for_Amin/Subspace_Graph_Liquid_Crystal ./tf1gpu.simg python -m learning_to_simulate.train \
--mode=train \
--eval_split=train \
--batch_size=2 \
--data_path=./learning_to_simulate/datasets/LiquidCrystal_PCA \
--model_path=./learning_to_simulate/models/LiquidCrystal_PCA
# Generate sims
python3 -m learning_to_simulate.train \
--mode=eval_rollout \
--eval_split=train \
--data_path=./learning_to_simulate/datasets/LiquidCrystal_PCA_8 \
--model_path=./learning_to_simulate/models/LiquidCrystal_PCA_8 \
--output_path=./learning_to_simulate/rollouts/LiquidCrystal_PCA_8

python3 -m learning_to_simulate.train \
--mode=eval_rollout \
--eval_split=test \
--data_path=./learning_to_simulate/datasets/LiquidCrystal_PCA \
--model_path=./learning_to_simulate/models/LiquidCrystal_PCA \
--output_path=./learning_to_simulate/rollouts/LiquidCrystal_PCA

# Plot 2D
python -m learning_to_simulate.render_rollout_2d \
  --data_path=./learning_to_simulate/datasets/LiquidCrystal_PCA_8 \
  --rollout_path=./learning_to_simulate/rollouts/LiquidCrystal_PCA_8/rollout_train_4.pkl \
  --load=True

python -m learning_to_simulate.render_rollout_2d \
  --data_path=./learning_to_simulate/datasets/LiquidCrystal_PCA \
  --rollout_path=./learning_to_simulate/rollouts/LiquidCrystal_PCA/rollout_test_0.pkl \
  --load=True
  
# Plot 3D
python -m learning_to_simulate.render_rollout_3d \
  --fullspace=True \
  --data_path=./learning_to_simulate/datasets/LiquidCrystal_PCA_8 \
  --rollout_path=./learning_to_simulate/rollouts/LiquidCrystal_PCA_8/rollout_test_0.pkl
# Tensorboard
tensorboard --logdir="./learning_to_simulate/models/LiquidCrystal_PCA_8"
# Video
ffmpeg -framerate 100 -i ./learning_to_simulate/rollouts/LiquidCrystal_PCA_8/rollout_train_4/f%d.png -c:v libx264 -profile:v high -crf 18 -pix_fmt yuv420p output.mp4

# Info
Activity level: z in code, alpha in paper
Input/Outut: only director field is used as input and output (Fig 5; no order parameter S or velocity field v)
Loss function: 1 - |<n, n_hat>| (dot product)
Time evolution network on 3D data?
# Local
install partio from github
python partio_generator
Houdini
# 2x slower (dt=1e-4, t_max=10sec, freq=100Hz)
ffmpeg -framerate 50 -i untitled%d.jpg -c:v libx264 -profile:v high -crf 18 -pix_fmt yuv420p output.mp4

## MPI C Code
# To copy
scp -r /Volumes/X/Postdoc/Code/LC_Code_0 haeri@midway2.rcc.uchicago.edu:
# For running
module load openmpi/2.0.1
module load intel/16.0
make -f Makefile.txt
mpirun lblc
# For postprocessing
module load mkl/2017
make -f Makefile
# Only on my computer:
cd Volumes/X/Postdoc/Code/LC-Code
export PATH=$PATH:$HOME/opt/usr/local/bin
export PATH=$PATH:$HOME/opt/usr/local/bin/mpicc
export TMPDIR=~/tmp


## PySpark --------------------------------------------------------------------
# Setup
Set a python venv
pip install pyspark 
# Run
spark-submit file_name.py 


## PhD Thesis Concordia -------------------------------------------------------
# First Priority
* Model wheel-soil in MPM
* Generate training datasets via MPM-NGF
* Use graph-based dl to model granular flows and PCA to reduce problem dimension for real-time applications
* Add transient feature to MPM-NGF code (Capturing transient granular rheology with extended fabric tensor relations)
* Implement MPM-NGF as a plugin in Houdini (postdoc, better to be GPU-based)
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


# My Website -------------------------------------------------------------------
* Gatsby + Netlify + GoogleDomain + GitHub
# To develop
$ npm run develop
$ npm run clean
# To deploy
$ EDIT
$ COMMIT

# EPS to PDF ------------------------------------------------------------------
$ for i in *ps; do ps2pdf -DEPSCrop $i; done;

# Run C++ ---------------------------------------------------------------------
g++ -pipe -std=c++11 ./
./a.out
using namespace std;
auto it = max_element(begin(v), end(v));
sort(v.begin(), v.end());

# Graph Neural Network --------------------------------------------------------
# Setup (RTX 3080 and Cuda11)
https://www.digitalocean.com/community/tutorials/how-to-install-anaconda-on-ubuntu-18-04-quickstart
https://www.pugetsystems.com/labs/hpc/How-To-Install-TensorFlow-1-15-for-NVIDIA-RTX30-GPUs-without-docker-or-CUDA-install-2005/
pip install dm-tree==0.1.5 dm-sonnet==1.36 graph-nets==1.1.0 sklearn==0.0 matplotlib==3.3.4 pandas==1.1.5
sudo apt install ffmpeg
conda activate tf1-nv

# # Setup (not working with RTX 3080 and Cuda10.0)
# Install Nvidia driver
# https://www.tensorflow.org/install/source#gpu
# https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#ubuntu-lts
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions


# # Singularity (not working with RTX 3080)
# https://sylabs.io/guides/3.0/user-guide/installation.html#install-on-linux
# $ singularity exec -H /home/gpucomp/DeepGranularFlows --nv ../mytf.simg /bin/bash ./run_excavation.sh
# $ singularity exec -H /home/gpucomp/DeepGranularFlows --nv ../mytf.simg /bin/bash ./run_sand.sh

# # Docker (not working with RTX 3080)
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04

# Get image: $ docker pull ahaeri/docker-custom-tensorflow
# Run: $ docker run -t -d ahaeri/docker-custom-tensorflow bash
# Run interactively: $ docker run -it ahaeri/docker-custom-tensorflow bash

# Show images: $ docker images
# Show all containers: $ docker ps -a
# Show running containers: $ docker ps
# Stop container: $ docker stop 27456e4c7dd2
# Delete containers: $ docker rm $(docker ps -a -q -f status=exited)

# $ docker run --gpus all -it -w /docker-custom-tensorflow -v $PWD:/mnt -e HOST_PERMS="$(id -u):$(id -g)" ahaeri/docker-custom-tensorflow bash
# $ docker run -it -w ~/ -v $PWD:/mnt -e HOST_PERMS="$(id -u):$(id -g)" ahaeri/docker-custom-tensorflow bash

# $ docker exec -w $PWD:/DeepGranularFlows 27456e4c7dd2 /bin/bash ./DeepGranularFlows/run_excavation.sh
# $ docker exec -it -w $PWD:/home/gpucomp/DeepGranularFlows -e HOST_PERMS="$(id -u):$(id -g)" 27456e4c7dd2 /bin/bash ./DeepGranularFlows/run_excavation.sh


# On Concordia Speed
ssh a_hae@speed-submit.encs.concordia.ca
cd /private/k/kskoniec/a_hae
source /local/pkg/uge-8.6.3/root/default/common/settings.csh
qsub -q g.q ./tcsh_gpu.sh
qsub -q g.q ./tcsh_gpu_test.sh
qsub ./tcsh_cpu.sh
qstat -f -u "*"
qstat -j
ssh speed-05 nvidia-smi
du -msh a_hae
qdel 
rsync -avzhe ssh a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/deep_granular_flows/learning_to_simulate/models/Excavation /Volumes/X
rsync -avzhe ssh a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/deep_granular_flows/learning_to_simulate/models/Sand /Volumes/X
rsync -avzhe ssh a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/deep_granular_flows/learning_to_simulate/models/Sand /home/gpucomp
rsync -avzhe ssh a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/deep_granular_flows/learning_to_simulate/rollouts/Excavation /Volumes/X
rsync -avzhe ssh a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/deep_granular_flows/learning_to_simulate/rollouts/Sand /Volumes/X

# Install dependencies:
# pip install -r requirements.txt
mkdir -p ./learning_to_simulate/datasets
mkdir -p ./learning_to_simulate/models
mkdir -p ./learning_to_simulate/rollouts

# Download dataset (e.g. Sand):
bash ./learning_to_simulate/download_dataset.sh Sand ./learning_to_simulate/datasets

# Tensorboard
tensorboard --logdir="./learning_to_simulate/models/Excavation_PCA"
tensorboard --logdir="./learning_to_simulate/models/Sand_20m_trained"

# Train a model:
python3 -m learning_to_simulate.train \
  --mode=train \
  --eval_split=train \
  --batch_size=2 \
  --data_path=./learning_to_simulate/datasets/Excavation_PCA \
  --model_path=./learning_to_simulate/models/Excavation_PCA

python3 -m learning_to_simulate.train \
  --mode=train \
  --eval_split=train \
  --batch_size=2 \
  --data_path=./learning_to_simulate/datasets/Wheel_PCA \
  --model_path=./learning_to_simulate/models/Wheel_PCA

python3 -m learning_to_simulate.train \
  --mode=train \
  --eval_split=train \
  --batch_size=2 \
  --data_path=./learning_to_simulate/datasets/Excavation_SP/240_D0.1m_S0.1ms-1_A45.0deg_M2.0 \
  --model_path=./learning_to_simulate/models/Excavation_SP \
  --con_radius=0.03

python3 -m learning_to_simulate.train \
  --mode=train \
  --eval_split=train \
  --data_path=./learning_to_simulate/datasets/Sand \
  --model_path=./learning_to_simulate/models/Sand \
  --con_radius=0.015

# Generate some trajectory rollouts on the test set:
python3 -m learning_to_simulate.train \
  --mode=eval_rollout \
  --eval_split=test \
  --data_path=./learning_to_simulate/datasets/Excavation_PCA \
  --model_path=./learning_to_simulate/models/Excavation_PCA \
  --output_path=./learning_to_simulate/rollouts/Excavation_PCA

python3 -m learning_to_simulate.train \
  --mode=eval_rollout \
  --eval_split=test \
  --data_path=./learning_to_simulate/datasets/Wheel_PCA \
  --model_path=./learning_to_simulate/models/Wheel_PCA \
  --output_path=./learning_to_simulate/rollouts/Wheel_PCA

python3 -m learning_to_simulate.train \
  --mode=eval_rollout \
  --eval_split=train \
  --data_path=./learning_to_simulate/datasets/Excavation_PCA/all/33_D0.02m_S0.1ms-1_A3.8deg_M1.0 \
  --model_path=./learning_to_simulate/models/Excavation_PCA \
  --output_path=./learning_to_simulate/rollouts/Excavation_PCA
python3 -m learning_to_simulate.train \
  --mode=eval_rollout \
  --eval_split=train \
  --data_path=./learning_to_simulate/datasets/Excavation_PCA/all/133_D0.05m_S0.1ms-1_A3.8deg_M1.0 \
  --model_path=./learning_to_simulate/models/Excavation_PCA \
  --output_path=./learning_to_simulate/rollouts/Excavation_PCA
python3 -m learning_to_simulate.train \
  --mode=eval_rollout \
  --eval_split=train \
  --data_path=./learning_to_simulate/datasets/Wheel_PCA/all/179_G9.81ms-2_S20perc_L164N_D30cm_A37deg \
  --model_path=./learning_to_simulate/models/Wheel_PCA \
  --output_path=./learning_to_simulate/rollouts/Wheel_PCA

python3 -m learning_to_simulate.train \
  --mode=eval_rollout \
  --eval_split=train \
  --data_path=./learning_to_simulate/datasets/Excavation_SP/240_D0.1m_S0.1ms-1_A45.0deg_M2.0 \
  --model_path=./learning_to_simulate/models/Excavation_SP \
  --output_path=./learning_to_simulate/rollouts/Excavation_SP \
  --con_radius=0.025

python3 -m learning_to_simulate.train \
  --mode=eval_rollout \
  --eval_split=test \
  --data_path=./learning_to_simulate/datasets/Sand \
  --model_path=./learning_to_simulate/models/Sand \
  --output_path=./learning_to_simulate/rollouts/Sand \
  --con_radius=0.015

# Plot a trajectory:
# 2D
python -m learning_to_simulate.render_rollout_2d_force \
  --plane=xy \
  --data_path=./learning_to_simulate/datasets/Excavation_PCA \
  --rollout_path=./learning_to_simulate/rollouts/Excavation_PCA

python -m learning_to_simulate.render_rollout_2d_force \
  --plane=xy \
  --data_path=./learning_to_simulate/datasets/Wheel_PCA \
  --rollout_path=./learning_to_simulate/rollouts/Wheel_PCA

python -m learning_to_simulate.render_rollout_original \
  --rollout_path=./learning_to_simulate/rollouts/Sand/rollout_train_0.pkl

# 3D
python -m learning_to_simulate.render_rollout_3d_force \
  --fullspace=True \
  --data_path=./learning_to_simulate/datasets/Excavation_PCA \
  --rollout_path=./learning_to_simulate/rollouts/Excavation_PCA/rollout_test_0.pkl

python -m learning_to_simulate.render_rollout_3d_force \
  --fullspace=True \
  --data_path=./learning_to_simulate/datasets/Wheel_PCA \
  --rollout_path=./learning_to_simulate/rollouts/Wheel_PCA/rollout_test_0.pkl


# Venv -------------------------------------------------------------------------
# Ubuntu:
  $ sudo apt install python3-venv
# Mac
1. Create venv in project dir: $ /usr/local/bin/python3.7 -m venv ./venv
2. Activate venv $ source ./venv/bin/activate
3. Update pip: $ pip install --upgrade pip
4. Install venv pip packages: $ pip install -r requirements.txt
# Windows:
1. Create venv in project dir: $ python3 -m venv c:/users/NAME/.../venv
2. Activate venv: $ c:/users/.../venv/Scripts/activate.bat

# Remotely control OS Grub boot ------------------------------------------------
(via Chrome Remote Desktop OR Team Viewer)
$ sudo grub-reboot 2 && sudo reboot [for CPU/GPU Concordia]
$ sudo grub-reboot NUMBER && sudo reboot
To see NUMBER (starts from 0):
$ awk -F\' '/menuentry / {print $2}' /boot/grub/grub.cfg 
OR
$ sudo add-apt-repository ppa:danielrichter2007/grub-customizer
$ sudo apt update
$ sudo apt install grub-customizer
$ grub-customizer

If required see this:
https://www.trishtech.com/2017/09/quickly-add-windows-10-to-grub-menu-after-installing-ubuntu/

Change resolution:
$ gtf 1536 960 60
Copy the entire output STRING (except for the starting "Modeline")
$ xrandr --newmode STRING
Find display NAME (e.g. VGA1, DVI-I-1) by running $ xrandr
$ xrandr --addmode DVI-I-1 "1536x960_60.00"

Copy and paste:
$ sudo chmod -R 777 DIR_ADDRESS

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
$ source ~/.bashrc
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
rsync -avzhe ssh a_hae@speed-submit.encs.concordia.ca:/private/k/kskoniec/a_hae/deep_granular_flows/learning_to_simulate/rollouts/Excavation /Volumes/X

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
