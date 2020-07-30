sudo wget https://www.xilinx.com/bin/public/openDownload?filename=alveo_xclbin-1.2.1.tar.gz -O alveo_xclbin-1.2.1.tar.gz
sudo tar xfz alveo_xclbin-1.2.1.tar.gz
sudo rm alveo_xclbin-1.2.1.tar.gz


detected=0
/opt/xilinx/xrt/bin/xbutil scan | grep xilinx_u50_
if [ $? -eq 0 ]; then
	  echo "U50 card detected."
	    sudo cp ./alveo_xclbin-1.2.1/U50/6E300M/* /usr/lib
	      detected=1
fi

/opt/xilinx/xrt/bin/xbutil scan | grep xilinx_u50lv_
if [ $? -eq 0 ]; then
	  echo "U50LV card detected."
	    sudo cp ./alveo_xclbin-1.2.1//U50lv/10E275M/* /usr/lib
	      detected=1
fi

/opt/xilinx/xrt/bin/xbutil scan | grep xilinx_u280_
if [ $? -eq 0 ]; then
	  echo "U280 card detected."
	    sudo cp alveo_xclbin-1.2.1/U280/14E300M/* /usr/lib
	      detected=1
fi

if [ $detected -eq 0 ]; then
	  echo "ERROR! No compatible Alveo card (U50, U50LV, U280) detected!"
fi

