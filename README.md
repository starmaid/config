# nixos config

how to get set up

```
nix-shell -p git
git clone https://github.com/starmaid/config
NEWHOSTNAME=star-flex
sudo ln -sf ~/config/hosts/$NEWHOSTNAME/configuration.nix /etc/nixos/configuration.nix
sudo ln -sf ~/config/hosts/$NEWHOSTNAME/files /etc/nixos/

nixos-rebuild switch --use-remote-sudo
```

remember you have to get a new conf from your wireguard server.

```
nix-shell -p nixfmt
```

```
sudo nix-channel --list
sudo nix-channel --add https://channels.nixos.org/nixos-25.05 nixos
sudo nix-channel --update
```

https://nix.dev/tutorials/nixos/distributed-builds-setup.html

```
sudo nixos-rebuild switch --max-jobs 0
```

update a computer with flakes

```
sudo nix flake update
sudo nixos-rebuild switch
```


```
sudo nix-env --profile /nix/var/nix/profiles/system --list-generations
```

rsync -azu --progress star@192.168.0.94:/srv/dev-disk-by-uuid-1af4f3d6-6e2b-44ef-b951-4102146e859c/MainDrive ./MainDrive




## My camera doesnt work

https://github.com/linux-surface/linux-surface/discussions/1354

https://discourse.nixos.org/t/usb-webcam-not-usable-despite-being-detected/70969