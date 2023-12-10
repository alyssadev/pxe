pxe
===

My iPXE config for my LAN

Usage
-----

* Edit `default.ipxe` with the path to where you're going to put httpboot
* Mount the isos you want presented as described in `fstab`
* Edit `httpboot/utils/*install.bat` with the paths to your smb mounts, example in `smb.conf`
* Install deps for ipxe
* `make`
