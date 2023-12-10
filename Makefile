.PHONY: all kernels tftp utils ipxe_build clean

all: kernels utils tftp

kernels: httpboot/gparted/vmlinuz httpboot/gparted/initrd httpboot/systemrescue/vmlinuz httpboot/systemrescue/initrd

utils: httpboot/utils/wimboot httpboot/utils/netboot.xyz-snponly.efi httpboot/utils/netboot.xyz-undionly.kpxe

tftp: tftpboot/ipxe.efi tftpboot/undionly.kpxe

clean:
	rm -rf ipxe
	rm -f tftpboot/ipxe.efi tftpboot/undionly.kpxe
	rm -f httpboot/utils/wimboot httpboot/utils/netboot.xyz-snponly.efi httpboot/utils/netboot.xyz-undionly.kpxe
	rm -f httpboot/gparted/vmlinuz httpboot/gparted/initrd httpboot/systemrescue/vmlinuz httpboot/systemrescue/initrd

ipxe:
	git clone https://github.com/ipxe/ipxe
	git apply --directory=ipxe ipxe-src-config-general-h.patch
	cd ipxe/src && make bin/undionly.kpxe bin-x86_64-efi/ipxe.efi EMBED=../../default.ipxe

ipxe/src/bin/undionly.kpxe: ipxe
ipxe/src/bin-x86_64-efi/ipxe.efi: ipxe

httpboot/gparted/vmlinuz:
	wget https://github.com/netbootxyz/debian-squash/releases/download/1.5.0-6-521af9dc/vmlinuz -O httpboot/gparted/vmlinuz

httpboot/gparted/initrd:
	wget https://github.com/netbootxyz/debian-squash/releases/download/1.5.0-6-521af9dc/vmlinuz -O httpboot/gparted/initrd

httpboot/systemrescue/vmlinuz:
	wget https://github.com/netbootxyz/asset-mirror/releases/download/10.02-182f0000/vmlinuz -O httpboot/systemrescue/vmlinuz

httpboot/systemrescue/initrd:
	wget https://github.com/netbootxyz/asset-mirror/releases/download/10.02-182f0000/initrd -O httpboot/systemrescue/initrd

httpboot/utils/wimboot:
	wget https://boot.netboot.xyz/wimboot -O httpboot/utils/wimboot

httpboot/utils/netboot.xyz-snponly.efi:
	wget http://boot.netboot.xyz/ipxe/netboot.xyz-snponly.efi -O httpboot/utils/netboot.xyz-snponly.efi

httpboot/utils/netboot.xyz-undionly.kpxe:
	wget http://boot.netboot.xyz/ipxe/netboot.xyz-undionly.kpxe -O httpboot/utils/netboot.xyz-undionly.kpxe

tftpboot/ipxe.efi: ipxe/src/bin-x86_64-efi/ipxe.efi
	cp ipxe/src/bin-x86_64-efi/ipxe.efi tftpboot/ipxe.efi

tftpboot/undionly.kpxe: ipxe/src/bin/undionly.kpxe
	cp ipxe/src/bin/undionly.kpxe tftpboot/undionly.kpxe
