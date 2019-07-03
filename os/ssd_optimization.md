## SSD optimization

+ (on BIOS)
	+ SATA configuration : IDE Mode -> AHCI Mode
	+ External STAT 6GB/s configuration : IDE Mode -> AHCI Mode
	+ reboot computer


+ (on /etc/fstab)
	+ in fstab, put 'noatime' but not in **swap**


+ TRIM operation periodically
+ check your SSD trim operation
```bash
lsblk -D
```
> Non-zero values in DISC-GRAN and DISC-MAX indicate TRIM support
+ put a daily operation
```bash
sudo mv -v /etc/cron.weekly/fstrim /etc/cron.daily
```
+ if you don't have fstrim
```bash
#!/bin/sh
# trim all mounted file systems which support it
/sbin/fstrim --all || true
```


+ reduce swappiness
+ put the below lines on /etc/sysctl.conf
```bash
# Sharply reduce the inclination to swap
vm.swappiness=1
```


+ check the OS level scheduler
```bash
cat /sys/block/sda/queue/scheduler
```
> expects 'noop [deadline] cfq'
+ if you don't have 'deadline' put the below in /etc/default/grub
```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
(change)
GRUB_CMDLINE_LINUX_DEFAULT="elevator=deadline quiet splash"
sudo update-grub
```