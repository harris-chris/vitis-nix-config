{ 
  pkgs ? import <nixpkgs> {}, 
  vitisPath ? "/opt/xilinx/Vitis_HLS/2021.1", 
  vivadoPath ? "/opt/xilinx/Vivado/2021.1",
  run ? "bash" 
}:

let 
  xrt = pkgs.callPackage ./xrt.nix {};
  
  # Necessary or else vitis throws an error
  arch-dummy-script = pkgs.writeShellScriptBin "arch" ''
    #!/bin/bash
    echo $(uname -m)
  '';

  xilinx-fhs = pkgs.buildFHSUserEnv {
    name = "xilinx";
    targetPkgs = pkgs: with pkgs; [
      arch-dummy-script
      eclipses.eclipse-sdk
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
      #glib
      # DEL
      #gtk2
      #gtk3
      # LED
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
      source ${vitisPath}/settings64.sh
      vitis_dir=${vitisPath}/*/bin
      export PATH=$vitis_dir:$PATH
      export XILINX_XRT="${xrt}"
      export DISPLAY=:0
    '';
    #runScript = "vitis_hls -debug -test";
    #runScript = "vitis_hls -i";
    #runScript = "vitis_hls -log ./log/vitis.log -journal ./log/vitis.jou";
    runScript = "${run}";
  };
in xilinx-fhs.env
