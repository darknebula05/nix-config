{ config, pkgs, ... }:

{
  time.timeZone = "America/New_York";
  services = {

    printing.enable = true;

    pipewire = {
      enable = true;
      # alsa.enable = true;
      # pulse.enable = true;
      # jack.enable = true;
    };
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };

  nixpkgs.config.allowUnfree = true;
  environment = {
    systemPackages = with pkgs; [
      vim
      helix
      wget
      curl
      git
      compsize
      efibootmgr
    ];
    variables.EDITOR = "hx";
    etc = {
    	"wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
    		bluez_monitor.properties = {
    			["bluez5.enable-sbc-xq"] = true,
    			["bluez5.enable-msbc"] = true,
    			["bluez5.enable-hw-volume"] = true,
    			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
    		}
    	'';
    };
  };
  security.polkit.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  users.users.cameron = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
