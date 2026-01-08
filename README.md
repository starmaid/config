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

