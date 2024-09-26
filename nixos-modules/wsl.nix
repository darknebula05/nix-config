{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = config.variables.username;
    useWindowsDriver = true;
  };
}
