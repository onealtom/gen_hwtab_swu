#!/bin/bash
cat >> ./sw-description <<EOF

software =
{
	version = "1.0.1";
	RAU = {
		hardware-compatibility: [ "REV1" ];

		files: (
			{
				filename = "RAU_19eg_ul_gain_calibration_table.xls";
				device = "/dev/mtdblock4";
				filesystem = "jffs2";
				path = "/";
				properties = {create-destination = "true";}
			},{
				filename = "RAU_19eg_dl_gain_calibration_table.xls";
				device = "/dev/mtdblock4";
				filesystem = "jffs2";
				path = "/";
				properties = {create-destination = "true";}
			},
		);

		scripts: (
			{
				filename = "update.sh";
				type = "shellscript";
			}
		);

	};
}

EOF

cat >> ./update.sh <<EOF

#!/bin/sh

if [ $1 == "preinst" ]; then
	echo "preinst..."
	umount -f /hwtab
	flash_erase /dev/mtd4 0 0
fi

if [ $1 == "postinst" ]; then
	echo "postinst..."
	mount -t jffs2 /dev/mtdblock4 /hwtab
fi


EOF

CONTAINER_VER="1_0"
PRODUCT_NAME="rau"
PRODUCT_MOD="hwtab"
FILES="sw-description update.sh *.xls"

BASH_TIME=`LANG=en_US date '+%m%d%p' | sed -e 's/\(.*\)/\L\1/'`
ORGIN_DIR=$PWD

# srcipt dir
SWUSRC_DIR="$(dirname $0)"

# if [ ! -f "system.bit" ]; then
#   rm -rf system.bit
# fi

# rm -rf *.swu

# cp $1 system.bit

for i in $FILES;do
        echo $i;done | cpio -ov -H crc >  ${PRODUCT_NAME}_${PRODUCT_MOD}_${SN}_${BASH_TIME}.swu
