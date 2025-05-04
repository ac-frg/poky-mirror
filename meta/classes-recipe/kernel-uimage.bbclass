#
# Copyright OpenEmbedded Contributors
#
# SPDX-License-Identifier: MIT
#

# fitImage kernel compression algorithm
FIT_KERNEL_COMP_ALG ?= "gzip"
FIT_KERNEL_COMP_ALG_EXTENSION ?= ".gz"

# Kernel image type passed to mkimage (i.e. kernel kernel_noload...)
UBOOT_MKIMAGE_KERNEL_TYPE ?= "kernel"


python __anonymous () {
    if "uImage" in d.getVar('KERNEL_IMAGETYPES'):
        depends = d.getVar("DEPENDS")
        depends = "%s u-boot-tools-native" % depends
        d.setVar("DEPENDS", depends)

        # Override KERNEL_IMAGETYPE_FOR_MAKE variable, which is internal
        # to kernel.bbclass . We override the variable here, since we need
        # to build uImage using the kernel build system if and only if
        # KEEPUIMAGE == yes. Otherwise, we pack compressed vmlinux into
        # the uImage .
        if d.getVar("KEEPUIMAGE") != 'yes':
            typeformake = d.getVar("KERNEL_IMAGETYPE_FOR_MAKE") or ""
            if "uImage" in typeformake.split():
                d.setVar('KERNEL_IMAGETYPE_FOR_MAKE', typeformake.replace('uImage', 'vmlinux'))

            # Enable building of uImage with mkimage
            bb.build.addtask('do_uboot_mkimage', 'do_install', 'do_kernel_link_images', d)
}

uboot_prep_kimage() {
	output_dir=$1
	# For backward compatibility with kernel-fitimage.bbclass and kernel-uboot.bbclass
	# support calling without parameter as well
	if [ -z "$output_dir" ]; then
		output_dir='.'
	fi

	linux_bin=$output_dir/linux.bin
	if [ -e "arch/${ARCH}/boot/compressed/vmlinux" ]; then
		vmlinux_path="arch/${ARCH}/boot/compressed/vmlinux"
		linux_suffix=""
		linux_comp="none"
	elif [ -e "arch/${ARCH}/boot/vmlinuz.bin" ]; then
		rm -f "$linux_bin"
		cp -l "arch/${ARCH}/boot/vmlinuz.bin" "$linux_bin"
		vmlinux_path=""
		linux_suffix=""
		linux_comp="none"
	else
		vmlinux_path="vmlinux"
		# Use vmlinux.initramfs for $linux_bin when INITRAMFS_IMAGE_BUNDLE set
		# As per the implementation in kernel.bbclass.
		# See do_bundle_initramfs function
		if [ "${INITRAMFS_IMAGE_BUNDLE}" = "1" ] && [ -e vmlinux.initramfs ]; then
			vmlinux_path="vmlinux.initramfs"
		fi
		linux_suffix="${FIT_KERNEL_COMP_ALG_EXTENSION}"
		linux_comp="${FIT_KERNEL_COMP_ALG}"
	fi

	[ -n "$vmlinux_path" ] && ${KERNEL_OBJCOPY} -O binary -R .note -R .comment -S "$vmlinux_path" "$linux_bin"

	if [ "$linux_comp" != "none" ] ; then
		if [ "$linux_comp" = "gzip" ] ; then
			gzip -9 "$linux_bin"
		elif [ "$linux_comp" = "lzo" ] ; then
			lzop -9 "$linux_bin"
		elif [ "$linux_comp" = "lzma" ] ; then
			xz --format=lzma -f -6 "$linux_bin"
		fi
		mv -f "$linux_bin$linux_suffix" "$linux_bin"
	fi

	printf "$linux_comp" > "$output_dir/linux_comp"
}

do_install:append() {
	# Provide the kernel artifacts to post processing recipes e.g. for creating a FIT image
	install -d ${D}/sysroot-only
	uboot_prep_kimage ${D}/sysroot-only
	# For x86 a setup.bin needs to be included in a fitImage as well
	if [ -e ${KERNEL_OUTPUT_DIR}/setup.bin ]; then
		install -D ${B}/${KERNEL_OUTPUT_DIR}/setup.bin ${D}/sysroot-only/setup.bin
	fi
}

do_uboot_mkimage[dirs] += "${B}"
do_uboot_mkimage() {
	linux_bin=${D}/sysroot-only/setup.bin
	linux_comp=$(cat "${D}/sysroot-only/linux_comp")

	ENTRYPOINT=${UBOOT_ENTRYPOINT}
	if [ -n "${UBOOT_ENTRYSYMBOL}" ]; then
		ENTRYPOINT=`${HOST_PREFIX}nm ${B}/vmlinux | \
			awk '$3=="${UBOOT_ENTRYSYMBOL}" {print "0x"$1;exit}'`
	fi

	uboot-mkimage -A ${UBOOT_ARCH} -O linux -T ${UBOOT_MKIMAGE_KERNEL_TYPE} -C "$linux_comp" -a ${UBOOT_LOADADDRESS} -e $ENTRYPOINT -n "${DISTRO_NAME}/${PV}/${MACHINE}" -d "$linux_bin" ${B}/arch/${ARCH}/boot/uImage
	rm -f linux.bin
}
