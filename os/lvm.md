# Configure the lvm on AWS
> when not using EBS

1. create Linux LVM.

- (on every device you want)

  ```bash
  fdisk /dev/nvme1n1
  fidsk> p  (파티션 확인)
  fidsk> n  (파티션 만들기)
  fidsk> p  (주 파티션)
  fidsk> 1  (1번 파티션)
  fidsk> L  (파티션들의 Type 보기)
  fidsk> t  (파티션 시스템의 ID 변경)
  fidsk> 8e (파티션을 LVM으로 설정)
  fidsk> p  (설정한 파티션 확인)
  fidsk> w  (설정판 파티션 저장)
  ```

2. create Physical Volume.

- (on every LVM you want)

  ```bash
  pvcreate /dev/nvme1n1p1
  pvcreate /dev/nvme2n1p1
  pvdisplay
  ```

3. create Volume Group

  ```bash
  vgcreate data-vg /dev/nvme1n1p1 /dev/nvme2n1p1
  vgdisplay
  ```

4. create Logical Volume

  ```bash
  lvcreate -n data-lv -l 100%FREE data-vg
  lvdisplay
  ```

5. make the ext4 file system

```bash
mkfs.ext4 /dev/data-vg/data-lv
```

6. make mount permantly

```bash
sudo vi /etc/fstab

# add the follow line on the bottom
/dev/data-vg/data-lv /home/data/        ext4    errors=remount-ro,noatime,discard 0 1
```