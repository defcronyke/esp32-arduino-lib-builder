#!/bin/bash
source ./tools/config.sh
TARGET_PATH=$AR_SDK/bin
mkdir -p $TARGET_PATH || exit 1

if [ "$IDF_TARGET" = "esp32" ]; then
	$SED -i '/CONFIG_ESP32_DEFAULT_CPU_FREQ_80/c\# CONFIG_ESP32_DEFAULT_CPU_FREQ_80 is not set' ./sdkconfig
	$SED -i '/CONFIG_ESP32_DEFAULT_CPU_FREQ_160/c\CONFIG_ESP32_DEFAULT_CPU_FREQ_160=y' ./sdkconfig
	$SED -i '/CONFIG_ESP32_DEFAULT_CPU_FREQ_240/c\# CONFIG_ESP32_DEFAULT_CPU_FREQ_240 is not set' ./sdkconfig
	$SED -i '/CONFIG_ESP32_DEFAULT_CPU_FREQ_MHZ/c\CONFIG_ESP32_DEFAULT_CPU_FREQ_MHZ=160' ./sdkconfig

	echo "CONFIG_BOOTLOADER_SPI_WP_PIN=7" >> ./sdkconfig
	echo "CONFIG_SPIRAM_OCCUPY_HSPI_HOST=y" >> ./sdkconfig
	echo "# CONFIG_SPIRAM_OCCUPY_VSPI_HOST is not set" >> ./sdkconfig
	echo "# CONFIG_SPIRAM_OCCUPY_NO_HOST is not set" >> ./sdkconfig
elif [ "$IDF_TARGET" = "esp32s2" ]; then
	$SED -i '/CONFIG_ESP32S2_DEFAULT_CPU_FREQ_80/c\# CONFIG_ESP32S2_DEFAULT_CPU_FREQ_80 is not set' ./sdkconfig
	$SED -i '/CONFIG_ESP32S2_DEFAULT_CPU_FREQ_160/c\CONFIG_ESP32S2_DEFAULT_CPU_FREQ_160 is not set' ./sdkconfig
	$SED -i '/CONFIG_ESP32S2_DEFAULT_CPU_FREQ_240/c\# CONFIG_ESP32S2_DEFAULT_CPU_FREQ_240=y' ./sdkconfig
	$SED -i '/CONFIG_ESP32S2_DEFAULT_CPU_FREQ_MHZ/c\CONFIG_ESP32S2_DEFAULT_CPU_FREQ_MHZ=240' ./sdkconfig
fi

$SED -i '/CONFIG_SPIRAM_SPEED_40M/c\# CONFIG_SPIRAM_SPEED_40M is not set' ./sdkconfig
$SED -i '/CONFIG_SPIRAM_SPEED_80M/c\CONFIG_SPIRAM_SPEED_80M=y' ./sdkconfig
echo "CONFIG_SPIRAM_SPEED_80M=y" >> ./sdkconfig

$SED -i '/CONFIG_ESPTOOLPY_FLASHFREQ_80M/c\CONFIG_ESPTOOLPY_FLASHFREQ_80M=y' ./sdkconfig
$SED -i '/CONFIG_ESPTOOLPY_FLASHFREQ_40M/c\# CONFIG_ESPTOOLPY_FLASHFREQ_40M is not set' ./sdkconfig

$SED -i '/CONFIG_FLASHMODE_QIO/c\CONFIG_FLASHMODE_QIO=y' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_QOUT/c\# CONFIG_FLASHMODE_QOUT is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DIO/c\# CONFIG_FLASHMODE_DIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DOUT/c\# CONFIG_FLASHMODE_DOUT is not set' ./sdkconfig
echo "******** BUILDING BOOTLOADER QIO 80MHz *******"
idf.py bootloader || exit 1
cp build/bootloader/bootloader.bin $TARGET_PATH/bootloader_qio_80m.bin

$SED -i '/CONFIG_FLASHMODE_QIO/c\# CONFIG_FLASHMODE_QIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_QOUT/c\CONFIG_FLASHMODE_QOUT=y' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DIO/c\# CONFIG_FLASHMODE_DIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DOUT/c\# CONFIG_FLASHMODE_DOUT is not set' ./sdkconfig
echo "******** BUILDING BOOTLOADER QOUT 80MHz *******"
idf.py bootloader || exit 1
cp build/bootloader/bootloader.bin $TARGET_PATH/bootloader_qout_80m.bin

if [ "$IDF_TARGET" = "esp32" ]; then
	echo "CONFIG_SPIRAM_SPIWP_SD3_PIN=7" >> ./sdkconfig
fi

$SED -i '/CONFIG_FLASHMODE_QIO/c\# CONFIG_FLASHMODE_QIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_QOUT/c\# CONFIG_FLASHMODE_QOUT is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DIO/c\CONFIG_FLASHMODE_DIO=y' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DOUT/c\# CONFIG_FLASHMODE_DOUT is not set' ./sdkconfig
echo "******** BUILDING BOOTLOADER DIO 80MHz *******"
idf.py bootloader || exit 1
cp build/bootloader/bootloader.bin $TARGET_PATH/bootloader_dio_80m.bin

$SED -i '/CONFIG_FLASHMODE_QIO/c\# CONFIG_FLASHMODE_QIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_QOUT/c\# CONFIG_FLASHMODE_QOUT is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DIO/c\# CONFIG_FLASHMODE_DIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DOUT/c\CONFIG_FLASHMODE_DOUT=y' ./sdkconfig
echo "******** BUILDING BOOTLOADER DOUT 80MHz *******"
idf.py bootloader || exit 1
cp build/bootloader/bootloader.bin $TARGET_PATH/bootloader_dout_80m.bin

$SED -i '/CONFIG_ESPTOOLPY_FLASHFREQ_80M/c\# CONFIG_ESPTOOLPY_FLASHFREQ_80M is not set' ./sdkconfig
$SED -i '/CONFIG_ESPTOOLPY_FLASHFREQ_40M/c\CONFIG_ESPTOOLPY_FLASHFREQ_40M=y' ./sdkconfig

if [ "$IDF_TARGET" = "esp32" ]; then
	echo "CONFIG_BOOTLOADER_SPI_WP_PIN=7" >> ./sdkconfig
	echo "# CONFIG_BOOTLOADER_VDDSDIO_BOOST_1_8V is not set" >> ./sdkconfig
fi

$SED -i '/CONFIG_FLASHMODE_QIO/c\CONFIG_FLASHMODE_QIO=y' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_QOUT/c\# CONFIG_FLASHMODE_QOUT is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DIO/c\# CONFIG_FLASHMODE_DIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DOUT/c\# CONFIG_FLASHMODE_DOUT is not set' ./sdkconfig
echo "******** BUILDING BOOTLOADER QIO 40MHz *******"
idf.py bootloader || exit 1
cp build/bootloader/bootloader.bin $TARGET_PATH/bootloader_qio_40m.bin

$SED -i '/CONFIG_FLASHMODE_QIO/c\# CONFIG_FLASHMODE_QIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_QOUT/c\CONFIG_FLASHMODE_QOUT=y' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DIO/c\# CONFIG_FLASHMODE_DIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DOUT/c\# CONFIG_FLASHMODE_DOUT is not set' ./sdkconfig
echo "******** BUILDING BOOTLOADER QOUT 40MHz *******"
idf.py bootloader || exit 1
cp build/bootloader/bootloader.bin $TARGET_PATH/bootloader_qout_40m.bin

if [ "$IDF_TARGET" = "esp32" ]; then
	echo "CONFIG_SPIRAM_SPIWP_SD3_PIN=7" >> ./sdkconfig
fi

$SED -i '/CONFIG_FLASHMODE_QIO/c\# CONFIG_FLASHMODE_QIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_QOUT/c\# CONFIG_FLASHMODE_QOUT is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DIO/c\CONFIG_FLASHMODE_DIO=y' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DOUT/c\# CONFIG_FLASHMODE_DOUT is not set' ./sdkconfig
echo "******** BUILDING BOOTLOADER DIO 40MHz *******"
idf.py bootloader || exit 1
cp build/bootloader/bootloader.bin $TARGET_PATH/bootloader_dio_40m.bin

$SED -i '/CONFIG_FLASHMODE_QIO/c\# CONFIG_FLASHMODE_QIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_QOUT/c\# CONFIG_FLASHMODE_QOUT is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DIO/c\# CONFIG_FLASHMODE_DIO is not set' ./sdkconfig
$SED -i '/CONFIG_FLASHMODE_DOUT/c\CONFIG_FLASHMODE_DOUT=y' ./sdkconfig
echo "******** BUILDING BOOTLOADER DOUT 40MHz *******"
idf.py bootloader || exit 1
cp build/bootloader/bootloader.bin $TARGET_PATH/bootloader_dout_40m.bin

