This Nimbix docker provide DPUv3E on Alveo card with Vitis AI 1.1. Please follow below steps to start:

1. Clone Vitis AI repo to your personal data directory
  * open a terminal window
  * cd /data
  * git clone https://github.com/Xilinx/Vitis-AI.git
  * From now, /data/Vitis-AI will be your working directory, and any modification to the content of this directory will not loss even if you shutdown the Nimbix docker.

2. Try VART example
  Please refer to https://github.com/Xilinx/Vitis-AI/blob/master/VART/README.md for instruction. Please note you are already in CPU docker when you see this, so no need to start docker again.

3. Try Vitis AI Library example
  Please refer to https://github.com/Xilinx/Vitis-AI/blob/master/Vitis-AI-Library/README.md for instruction. Please note you are already in CPU docker when you see this, so no need to start docker again.

Please note in this Nimbix docker, the U50 card and overlays have been setup, so you don't need those steps described in /data/Vitis-AI/alveo-hbm/README.md
