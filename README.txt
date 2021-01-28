This Nimbix docker provide DPU on Alveo U50/U280/U200/U250 card with Vitis AI 1.3. Please follow below steps to start:

1. Clone Vitis AI repo to your personal data directory
  * open a terminal window
  * cd /data
  * git clone https://github.com/Xilinx/Vitis-AI.git
  * From now, /data/Vitis-AI will be your working directory, and any modification to the content of this directory will not loss even if you shutdown the Nimbix docker.

2. For U50/U280 card, please refer to https://github.com/Xilinx/Vitis-AI/blob/master/demo/VART/README.md for VART usage instruction, and refer to https://github.com/Xilinx/Vitis-AI/blob/master/demo/Vitis-AI-Library/README.md for Vitis AI Library usage instruction. Please note for U50/U280 in this Nimbix docker, the Alveo card and overlays have been setup, so you don't need those steps described in /data/Vitis-AI/README.md

3. For U200/U250 card, please refer to https://github.com/Xilinx/Vitis-AI/tree/master/examples for usage instruction.

Please note you are already in CPU docker when you see this, so no need to start the docker again.
