# nixos config

how to get set up

```
nix-shell -p git
git clone https://github.com/starmaid/config
ln -sf ~/config/hosts/<this-host>/configuration.nix /etc/nixos/configuration.nix
ln -sf ~/config/hosts/<this-host>/files /etc/nixos/

nixos-rebuild switch --use-remote-sudo
```

remember you have to get a new conf from your wireguard server.

