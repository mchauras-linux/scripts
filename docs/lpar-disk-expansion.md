13  vgs   
14  vgextend fedora_ltcrain8ok-lp3
   15  vgextend fedora_ltcrain8ok-lp3 /dev/sda3
   16  lvs
   17  vgs
   18  lsblk
   19  vgdisplay fedora_ltcrain8ok-lp3\n
   20  lvextend -l +100%FREE /dev/mapper/fedora_ltcrain8ok--lp3-root\n
   21  lsblk
   22  df -h\\n
   23  df -h\n
   24  resize2fs /dev/mapper/fedora_ltcrain8ok--lp3-root\n
   25  xfs_growfs /dev/mapper/fedora_ltcrain8ok--lp3-root\n
