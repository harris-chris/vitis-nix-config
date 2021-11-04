{ pkgs ? import <nixpkgs> {} }:

let
  xrt = pkgs.callPackage ./xrt.nix {};

  fhs = pkgs.buildFHSUserEnv {
    name = "xilinx-env";
    targetPkgs = pkgs: with pkgs; [
      bash
      xrt
      coreutils
      zlib
      stdenv.cc.cc
      ncurses5
      xorg.libXext
      xorg.libX11
      xorg.libXrender
      xorg.libXtst
      xorg.libXi
      xorg.libXft
      xorg.libxcb
      xorg.libxcb
      # common requirements
      freetype
      fontconfig
      glib
      gtk2
      gtk3

      # from installLibs.sh
      graphviz
      (lib.hiPrio gcc)
      unzip
      nettools
    ];
    multiPkgs = null;
    profile = ''
      vitis_dir=$(echo /opt/xilinx/Vitis/*/bin)
      export PATH=$vitis_dir:$PATH
      export XILINX_XRT="${xrt}"
    '';
  };
in fhs.env
