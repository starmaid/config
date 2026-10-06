# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  t2fanrd,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    "${
      builtins.fetchGit {
        url = "https://github.com/NixOS/nixos-hardware.git";
        rev = "06f9ecaea5f64b6ff61cf42cb32f21621c4fa14a";
      }
    }/apple/t2"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation (final: {
      name = "brcm-firmware";
      src = /. + "/home/star/config/hosts/star-mbp20/firmware/brcm";
      installPhase = ''
        mkdir -p $out/lib/firmware/brcm
        cp ${final.src}/* "$out/lib/firmware/brcm"
      '';
    }))
  ];

  services.t2fanrd.enable = true;
  services.t2fanrd.config = {
    Fan1 = {
      low_temp = 40;
      high_temp = 70;
      speed_curve = "linear";
      always_full_speed = false;
    };
    Fan2 = {
      low_temp = 40;
      high_temp = 70;
      speed_curve = "linear";
      always_full_speed = false;
    };
  };

  networking.hostName = "star-mbp20"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "US/Pacific";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.desktopManager.gnome.extraGSettingsOverridePackages = [ pkgs.mutter ];
  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['scale-monitor-framebuffer']
  '';

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # from https://discourse.nixos.org/t/enable-palm-rejection-on-macbook-pro-late-2013/78599
  services.udev.extraRules = ''
    ACTION=="add|change", \\

    SUBSYSTEM=="input", \\

    ENV{ID_INPUT_TOUCHPAD}=="1", \\

    ENV{ID_VENDOR_ID}=="05ac", \\

    ENV{ID_MODEL_ID}=="027e", \\

    ENV{ID_INPUT_TOUCHPAD_INTEGRATION}="internal"
  '';

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.star = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "sudo"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      nixfmt
      tree
      vscode.fhs
      calibre
      direnv
      libreoffice
      sunvox
      discord
      pwsafe
      vscode
      git
      freecad
      blender
      inkscape-with-extensions
      krita
      vim
      wireguard-tools
      wireguard-ui
      rnote
      vlc
      drawio
      tmux
      eternal-terminal
      protontricks
    ];
  };

  programs.firefox.enable = true;
  programs.steam.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    btop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  environment.shellAliases = {
    vpn-up = "sudo systemctl start wg-quick-wg0.service";
    vpn-down = "sudo systemctl stop wg-quick-wg0.service";
    editconf = "sudo nano /etc/nixos/configuration.nix";
    rebuildnix = "nixos-rebuild switch --use-remote-sudo";
  };

  # Bugfix until https://github.com/NixOS/nixpkgs/pull/507455 merges
  environment.extraInit = ''
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  '';

  # touchbar buttons to control kbd backlight don't work after sleep
  systemd.services.t2-touchbar-sleep-fix = {
    description = "Reload T2 Touch Bar modules after suspend";

    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];

    unitConfig = {
      StopWhenUnneeded = true;
    };

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      # Before suspend: remove the T2 Touch Bar stack.
      ExecStart = "${pkgs.kmod}/bin/modprobe -r hid_appletb_kbd hid_appletb_bl appletbdrm";

      # After resume: bring it back in dependency order.
      ExecStop = [
        "${pkgs.coreutils}/bin/sleep 3"
        "${pkgs.kmod}/bin/modprobe appletbdrm hid_appletb_bl hid_appletb_kbd"
        "${pkgs.systemd}/bin/udevadm settle"
        "${pkgs.systemd}/bin/systemctl restart upower.service"
      ];
    };
  };

  # wireguard stuff
  networking.wg-quick.interfaces.wg0.configFile = "/etc/nixos/files/wireguard/wg0.conf";
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.11"; # Did you read the comment?

}
