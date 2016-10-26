#! /bin/sh
rm /tmp/bootcd.iso
sleep 1
mkisofs -o /tmp/bootcd.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table bootcd
sleep 1
qemu -cdrom /tmp/bootcd.iso -boot d
