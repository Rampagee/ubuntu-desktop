#!/bin/bash
USER=nimbix
echo "Running as $USER"
echo "export PATH=/opt/vitis_ai/conda/bin:$PATH" >> /home/$USER/.bashrc
echo "export VERSION=$VERSION" >> /home/$USER/.bashrc
echo ". /opt/vitis_ai/conda/etc/profile.d/conda.sh" >> /home/$USER/.bashrc
echo "export DATE=\"$DATE\"" >> /home/$USER/.bashrc
echo "export VAI_ROOT=$VAI_ROOT" >> /home/$USER/.bashrc
echo "export PYTHONPATH=$PYTHONPATH" >> /home/$USER/.bashrc
echo "export LD_LIBRARY_PATH=/opt/xilinx/xrt/lib:/usr/lib:/usr/lib/x86_64-linux-gnu:/opt/vitis_ai/conda/envs/vitis-ai-tensorflow/lib/" >> /home/$USER/.bashrc

echo "/etc/banner.sh" >> /home/$USER/.bashrc

exit 0
