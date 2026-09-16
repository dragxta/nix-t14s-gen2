{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  patchelf,
  which,

  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libgbm,
  libglvnd,
  libsecret,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxcb,
  nspr,
  nss,
  pango,
  R,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "rstudio-bin";
  version = "2026.09.0-174";

  src = fetchurl {
    url = "https://download1.rstudio.org/electron/jammy/amd64/rstudio-${version}-amd64.deb";
    hash = "sha256-c70t1159y+Nogl03kXF2p4JhyPXn/CqkUfXqF4YUpp8=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    patchelf
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libgbm
    libglvnd
    libsecret
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxcb
    nspr
    nss
    pango
    R
    stdenv.cc.cc.lib
    systemd
  ];

  # nixpkgs' libR.so has no ELF SONAME, so autoPatchelf
  # cannot automatically match rsession's libR.so dependency.
  autoPatchelfIgnoreMissingDeps = [
    "libR.so"
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x "$src" .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r usr/* "$out/"

    # RStudio's bundled JavaScript assumes an Ubuntu-style /usr/bin/which.
    # Replace that absolute path with the Nix-managed executable.
    substituteInPlace \
      "$out/lib/rstudio/resources/app/.webpack/main/index.js" \
      --replace-fail "/usr/bin/which" "${which}/bin/which"

    # Wrap RStudio so it can discover R and dynamically loaded graphics
    # libraries at runtime.
    mkdir -p "$out/bin"

    makeWrapper "$out/lib/rstudio/rstudio" "$out/bin/rstudio" \
      --prefix PATH : "${R}/bin" \
      --set R_HOME "${R}/lib/R" \
      --prefix LD_LIBRARY_PATH : "${libglvnd}/lib"

    runHook postInstall
  '';

  postFixup = ''
    # rsession needs libR.so, which autoPatchelf cannot resolve
    # automatically because nixpkgs' libR.so has no SONAME.
    patchelf \
      --add-rpath "${R}/lib/R/lib" \
      "$out/lib/rstudio/resources/app/bin/rsession"
  '';

  meta = {
    description = "RStudio Desktop";
    homepage = "https://posit.co/products/open-source/rstudio/";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "rstudio";
  };
}
