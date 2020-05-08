#!/bin/bash
USER=nimbix
echo "Running as $USER"
echo "export PATH=/opt/vitis_ai/conda/bin:$PATH" >> /home/$USER/.bashrc
echo "export VERSION=1.1" >> /home/$USER/.bashrc
echo ". /opt/vitis_ai/conda/etc/profile.d/conda.sh" >> /home/$USER/.bashrc
echo "export DATE=2020_05_08" >> /home/$USER/.bashrc
echo "export VAI_ROOT=/opt/vitis_ai" >> /home/$USER/.bashrc
echo "export PYTHONPATH=/opt/vitis_ai/compiler" >> /home/$USER/.bashrc
echo "export LD_LIBRARY_PATH=/opt/xilinx/xrt/lib:/usr/lib:/usr/lib/x86_64-linux-gnu:/opt/vitis_ai/conda/envs/vitis-ai-tensorflow/lib" >> /home/$USER/.bashrc

echo "/etc/banner.sh" >> /home/$USER/.bashrc
mkdir -p /home/$USER/Desktop
cp -p /etc/README.txt /home/$USER/Desktop
/usr/local/bin/nimbix_desktop
mkdir -p /home/$USER/Desktop
cp -p /etc/README.txt /home/$USER/Desktop
exit 0
