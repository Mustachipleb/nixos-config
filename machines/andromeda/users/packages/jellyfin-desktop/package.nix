{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  cef-binary,
  mpv-unwrapped,
  ffmpeg,
  systemdLibs,
  libxkbcommon,
  wayland,
  wayland-protocols,
  libdrm,
  libGL,
  libX11,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXScrnSaver,
  libXtst,
  xcb-util-cursor,
  libxcb,
}:

stdenv.mkDerivation rec {
  pname = "jellyfin-desktop";
  version = "3.0.0-dev-d8c1aea";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-desktop";
    rev = "d8c1aeab742e6add76ec6679ee2a380f1e7429b7";
    hash = "sha256-5rSbOo688ILgcYfKStQCq+bN9iFXgr6B06Wy2+KbxHE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    cef-binary
    mpv-unwrapped
    ffmpeg
    systemdLibs
    libxkbcommon
    wayland
    wayland-protocols
    libdrm
    libGL
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXScrnSaver
    libXtst
    xcb-util-cursor
    libxcb
  ];

  cmakeFlags = [
    "-DEXTERNAL_CEF_DIR=${cef-binary}"
    "-DEXTERNAL_MPV_DIR=${mpv-unwrapped}"
    "-DBUILD_TESTING=OFF"
  ];

  preConfigure = ''
    # Ensure VERSION file exists if it's used for versioning
    echo "3.0.0-dev" > VERSION
  '';

  meta = with lib; {
    description = "A native desktop client for Jellyfin";
    homepage = "https://github.com/jellyfin/jellyfin-desktop";
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
