RED='\x1b[0;41m'
GREEN='\x1b[42;30m'
WARN='\x1b[1;33;43m'
NC='\033[0m' # No Color
BOLD='\033[1m'
NORMAL='\033[2m'
lastError=0

export IMAGE_FILE=''

# last error check
function lastErrorCheck () {
	lst=$?
	if [ "$lst" -ne "0" ]; then
		echo $lst
	else
		echo $1
	fi
}

# kill the subshells on case of error
function checkErrorAndKill () {
	lst=$?
	
	if [ "$lst" -ne "0" ]; then
		writelnError $@
		sleep 1
		
		# clean the attempt
		if [[ -z "$IMAGE_FILE" ]]; then
			echo 'Nothing to clean ..'
		else
			echo 'Cleaning ...'

			if [[ -z "$CDCD" ]]; then
				echo "PATH ok"
			else
				echo "Returning to root folder ..."
				cd -
			fi

			sudo umount rootfs/mntfat
			sudo umount rootfs/mntext
			sudo kpartx -dv $IMAGE_FILE
			sudo dmsetup remove /dev/mapper/${PART_LOOP}p1
			sudo dmsetup remove /dev/mapper/${PART_LOOP}p2
			sudo losetup -d /dev/${PART_LOOP}
			rm -rf $IMAGE_FILE
		fi

		exit 22 # exit all
	fi
}

function writelnError () {
	echo -e "${RED} $@ ${NC}"
}

function writelnWarn () {
	echo -e "${WARN} $@ ${NC}"
}

function writeln () {
	echo -e "${GREEN} $@ ${NC}"
}
