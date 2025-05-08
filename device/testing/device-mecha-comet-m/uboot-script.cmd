setenv bootargs init=/init.sh rw console=ttymxc1,115200 PMOS_FORCE_PARTITION_RESIZE

dtb_file=dtbs/freescale/imx8mm-mecha-comet-m-gen1-rev3.dtb

echo Resizing FDT
run set_fdt_overlay_addr
run set_fdt_overlays_env
run import_fdt_overlays_env
fdt addr 0x43000000
fdt resize 8192
run load_fdt_overlays

echo Loading DTB
ext2load mmc ${mmcdev}:1 ${fdt_addr_r} ${dtb_file}

echo Loading Initramfs
ext2load mmc ${mmcdev}:1 ${initrd_addr} initramfs

echo Loading Kernel
ext2load mmc ${mmcdev}:1 ${kernel_addr_r} vmlinuz

echo Booting kernel
booti ${kernel_addr_r} ${initrd_addr}:${filesize} ${fdt_addr_r}
