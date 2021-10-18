{ pkgs ? import <nixpkgs> {}, vivadoPath ? "/opt/xilinx/Vivado/2021.1", run ? "bash" }:

let
  xrt = pkgs.callPackage ./xrt.nix {};

  fhs = pkgs.buildFHSUserEnv {
    name = "vivado";
    targetPkgs = pkgs: with pkgs; [
      bash
      coreutils
      libuuid
      ncurses5
      stdenv.cc.cc
      xorg.libSM
      xorg.libICE
      xorg.libX11
      xorg.libxcb
      xorg.libXext
      xorg.libXft
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
      xrt
      zlib
      # common requirements
      freetype
      fontconfig
      glib
      gtk2
      gtk3
      # from installLibs.sh
      graphviz
      # gcc
      #gccMultiStdenv
      (lib.hiPrio gcc)
      glibc
      unzip
      nettools
    ];
    multiPkgs = null;
    profile = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      source ${vivadoPath}/settings64.sh
    '';
    runScript = "${run}";
    #runScript = "vivado -log ./log/vivado.log -journal ./log/vivado.jou";
  };
in fhs.env
