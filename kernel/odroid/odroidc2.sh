#!/bin/bash

export path=""
export path_boot=""
export path_modules=""
export artifacts="./rpi/artifacts/odroid"
export defconfig="./rpi/configs/odroidc2_defconfig"
export dtb_prefix="broadcom/bcm"
export kernel_src="../linux"

pwd

./kernel/build-aarch-common.sh "odroid" "$CLEAN" no-install-modules
