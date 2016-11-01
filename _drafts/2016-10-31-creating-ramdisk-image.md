---
layout: post
title:  "How to Ramdisk Image ramdisk.cpio.gz"
date:   2016-10-31 19:31:50
categories: Linux
tags: android linux embedded reverse
---

gzip -d ramdisk.cpio.gz
mkdir rootfs
cd rootfs
cpio -i -F ../ramdisk.cpio

out/host/linux-x86/bin/mkbootfs -d out/target/product/msm8952_64/system out/target/product/msm8952_64/root | out/host/linux-x86/bin/minigzip > out/target/product/msm8952_64/ramdisk.img

out/host/linux-x86/bin/mkbootimg  --kernel out/target/product/msm8952_64/kernel --ramdisk out/target/product/msm8952_64/ramdisk.img --cmdline "console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk" --base 0x80000000 --pagesize 2048  --output out/target/product/msm8952_64/boot.img

out/host/linux-x86/bin/boot_signer /boot out/target/product/msm8952_64/boot.img build/target/product/security/verity.pk8 build/target/product/security/verity.x509.pem out/target/product/msm8952_64/boot.img
size=$(for i in out/target/product/msm8952_64/boot.img; do stat --format "%s" "$i" | tr -d '\n'; echo +; done; echo 0); total=$(( $( echo "$size" ) )); printname=$(echo -n "out/target/product/msm8952_64/boot.img" | tr " " +); img_blocksize=135168; twoblocks=$((img_blocksize * 2)); onepct=$(((((69206016 / 100) - 1) / img_blocksize + 1) * img_blocksize)); reserve=$((twoblocks > onepct ? twoblocks : onepct)); maxsize=$((69206016 - reserve)); echo "$printname maxsize=$maxsize blocksize=$img_blocksize total=$total reserve=$reserve"; if [ "$total" -gt "$maxsize" ]; then echo "error: $printname too large ($total > [69206016 - $reserve])"; false; elif [ "$total" -gt $((maxsize - 32768)) ]; then echo "WARNING: $printname approaching size limit ($total now; limit $maxsize)"; fi
out/target/product/msm8952_64/boot.img maxsize=68395008 blocksize=135168 total=30418216 reserve=811008

http://pete.akeo.ie/2013/10/compiling-and-running-your-own-android.html
https://leanpub.com/awesomeasciidoctornotebook/read
http://akosma.github.io/eBook-Template/
