{ pkgs ? import <nixpkgs> {}, vitisPath ? "/opt/xilinx/Vitis_HLS/2021.1" }:

let
  vitis-fhs = "./nix/vitis-fhs-env.nix";

  vitis-shell-script = pkgs.writeShellScriptBin "vitis-shell" ''
    #!/bin/bash
    nix-shell --pure --argstr run "vitis_hls -i" "${vitis-fhs}"
  '';

  makefile-contents = builtins.readFile ./nix/Makefile;
  make-script = pkgs.writeShellScriptBin "make" ''
    function run {
      nix-shell --pure --argstr run "make -f ./nix/Makefile -I ./ $*" "${vitis-fhs}"
    }

    if [[ $# -eq 0 ]]; then
      run
    else
      run "$@"
    fi
  '';

  shell-scripts = [ vitis-shell-script make-script ];

in pkgs.mkShell {
  packages = with pkgs; [ ] ++ shell-scripts;
}
