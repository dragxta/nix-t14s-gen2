{ lib, appimageTools, fetchurl }:

let
  pname = "photocraft";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/storytold/photocraft/releases/download/v${version}/photocraft-${version}-linux-x86_64.AppImage";
    hash = "sha256-Y1+TiT+Unb8Xorwg4cKFqO/byIWchErS+6ro5wCfZ9Y=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications

    cat > $out/share/applications/photocraft.desktop <<EOF
    [Desktop Entry]
    Name=PhotoCraft
    Exec=$out/bin/photocraft
    Type=Application
    Categories=Graphics;Photography;
    Terminal=false
    EOF
  '';
}
