https://hydra.nixos.org/job/nixos/release-25.11/nixos.sd_image.aarch64-linux
https://github.com/nvmd/nixos-raspberrypi?tab=readme-ov-file

Load the image.

```
passwd
sudo passwd
```

now you can modify the config file. Remember to add a user for real.

```
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024
sudo mkswap /swapfile
sudo swapon /swapfile
```

now you can build.

```
sudo nixos-rebuild switch
```

you may have to login as `root` and passwd any new users you created.)


```
systemctl status docker-wireguard.service
journalctl -u docker-wireguard.service
```