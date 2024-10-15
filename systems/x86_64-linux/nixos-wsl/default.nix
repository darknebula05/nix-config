{
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
{
  ${namespace} = {
    facter = {
      enable = true;
      path = ./facter.json;
    };
    # home = {
    #   enable = true;
    #   path = ./home.nix;
    # };
    suites.common = enabled;
    wsl = enabled;
    stylix = enabled;
    variables = {
      username = "cshearer";
    };
  };

  system.stateVersion = "24.05";

  programs = {
    nix-ld = enabled;
  };

  networking.hostName = "nixos-wsl";

  fonts.packages = with pkgs; [ fira-code-nerdfont ];

  services = {
    avahi = enabled;
    openssh = enabled;
  };
}
