{
  pkgs,
  inputs,
  pname,
  ...
}:
let
  poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
  version = "0.15.3";
  projectDir = pkgs.fetchFromGitHub {
    owner = "rivenmedia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Jwnb9pXhzI8yvewKGKVWLQgiSgdb4+xIaWLh/zpHP+k=";
  };
  pypkgs-build-requirements = {
    babelfish = [ "poetry" ];
    parsett = [ "poetry" ];
    rapidfuzz = [ "scikit-build-core" ];
    scalar-fastapi = [ "setuptools" ];
    apprise = [
      "setuptools-scm"
      "babel"
    ];
    sqla-wrapper = [ "poetry" ];
    rank-torrent-name = [ "poetry" ];
  };
  overrides = poetry2nix.defaultPoetryOverrides.extend (
    final: prev:
    (builtins.mapAttrs (
      package: build-requirements:
      (builtins.getAttr package prev).overridePythonAttrs (old: {
        buildInputs =
          (old.buildInputs or [ ])
          ++ (builtins.map (
            pkg: if builtins.isString pkg then builtins.getAttr pkg prev else pkg
          ) build-requirements);
      })
    ) pypkgs-build-requirements)
    // {
      levenshtein = prev.levenshtein.overridePythonAttrs (old: {
        nativeBuildInputs = [ pkgs.cmake ] ++ old.nativeBuildInputs;
        buildInputs = [
          prev.scikit-build
          prev.packaging
        ] ++ (old.buildInputs or [ ]);
        dontUseCmakeConfigure = true;
      });
    }
  );
  env = poetry2nix.mkPoetryEnv {
    inherit projectDir overrides;
    groups = [ ];
    checkGroups = [ ];
  };
in
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;
  src = projectDir;

  nativeBuildInputs = [
    env
    pkgs.makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/riven/data
    mv {src,pyproject.toml} $out/share/riven/

    makeWrapper "${env}/bin/python" "$out/bin/riven" \
      --add-flags $out/share/riven/src/main.py

    runHook postInstall
  '';

  meta = {
    description = "The frontend for riven";
    homepage = "https://github.com/rivenmedia/riven-frontend";
    license = pkgs.lib.licenses.gpl3Plus;
    maintainers = with pkgs.lib.maintainers; [ camms205 ];
    platforms = pkgs.lib.platforms.linux;
    mainProgram = "riven";
  };
})
