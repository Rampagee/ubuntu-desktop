#!/bin/bash
USER=nimbix
echo "Running as $USER"
echo ". /opt/vitis_ai/conda/etc/profile.d/conda.sh" >> /home/$USER/.bashrc
echo "export PATH=/opt/vitis_ai/conda/bin:$PATH" >> /home/$USER/.bashrc
echo "export VERSION=1.2" >> /home/$USER/.bashrc
echo "export DATE=2020_07_30" >> /home/$USER/.bashrc
echo "export VAI_ROOT=$VAI_ROOT" >> /home/$USER/.bashrc
echo "export PYTHONPATH=$PYTHONPATH" >> /home/$USER/.bashrc
echo "/etc/banner.sh" >> /home/$USER/.bashrc
echo "export XILINX_XRT=/opt/xilinx/xrt">> /home/$USER/.bashrc
echo "export INTERNAL_BUILD=1">> /home/$USER/.bashrc
echo "export LIBRARY_PATH=/usr/local/lib">> /home/$USER/.bashrc
echo "export LD_LIBRARY_PATH=/opt/xilinx/xrt/lib:/usr/local/lib:/usr/lib:/usr/lib/x86_64-linux-gnu:/opt/vitis_ai/conda/envs/vitis-ai-tensorflow/lib">> /home/$USER/.bashrc

mkdir -p /home/$USER/Desktop
cp -p /etc/README.txt /home/$USER/Desktop
/usr/local/bin/nimbix_desktop
mkdir -p /home/$USER/Desktop
cp -p /etc/README.txt /home/$USER/Desktop

sudo source /etc/overlay_settle.sh

exit 0
