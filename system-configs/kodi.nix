# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  nixpkgs.config.allowUnfree = true;
  services.avahi = {
  	nssmdns4 = true;
  	enable = true;
  	publish = {
		enable = true;
		addresses = true;
		workstation = true;
		userServices = true
    		domain = true;
  	};
  };

  # auto update
 system.autoUpgrade = {
  enable = true;
  flake = "github:okoknik/nixos-config";
  flags = [
    "--update-input"
    "nixpkgs"
    "-L" # print build logs
  ];
  dates = "Mon *-*-* 20:30:00";
  randomizedDelaySec = "45min";
  };
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kodi"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # allow flakes
  nix.settings. experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
   time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
   i18n.defaultLocale = "de_DE.UTF-8";
   console = {
  #   font = "Lat2-Terminus16";
     keyMap = "de";
  #   useXkbConfig = true; # use xkb.options in tty.
   };

  # Enable the X11 windowing system.
   services.xserver = {
	enable = true;
	desktopManager.kodi.enable = true;
	desktopManager.kodi.package = pkgs.kodi.withPackages (pkgs: with pkgs; [ pvr-iptvsimple netflix mediathekview ]);
  };
  services = {
	displayManager.autoLogin = {
    		enable = true;
    		user = "kodi";
   	};
};

  # Configure keymap in X11
   services.xserver.xkb.layout = "de";
   services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

   security.rtkit.enable = true;
   services.pipewire = {
	  enable = true;
	  pulse.enable = true;
    	  alsa.enable = true;
   };

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.kodi = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     initialPassword = "test";
     packages = with pkgs; [
	    git
	   firefox
	   uxplay
     ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 22 8080 22000 8384 7100 7000 7001 ];
   networking.firewall.allowedUDPPorts = [ 8080 22000 21027 6000 6001 7011 ];
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
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

