{
  pkgs,
  pname,
  ...
}:

pkgs.stdenv.mkDerivation rec {
  inherit pname;
  version = "0.9.3-final";
  src = pkgs.fetchzip {
    url = "https://github.com/debridmediamanager/zurg-testing/releases/download/v${version}/zurg-v${version}-linux-amd64.zip";
    hash = "sha256-uGwP1QV6ZLSIFUCv1ywrbD5ECF5GYhLff0Ub1xrc9rA=";
  };

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall
    install -m755 -D zurg $out/bin/zurg
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/debridmediamanager/zurg-testing";
    maintainers = with pkgs.lib.maintainers; [ camms205 ];
    platforms = pkgs.lib.platforms.linux;
    mainProgram = "zurg";
  };
}
