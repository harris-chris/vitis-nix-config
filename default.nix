{ pkgs ? import <nixpkgs> {} }:

let
  vitis-fhs = "./nix/vitis-fhs-env.nix";
  vivado-fhs = "./nix/vivado-fhs-env.nix";
  xilinx-fhs = "./nix/xilinx-fhs-env.nix";

  vitis-shell-script = pkgs.writeShellScriptBin "vitis-shell" ''
    #!/bin/bash
    nix-shell --pure --argstr run "bash" "${xilinx-fhs}"
  '';

  vivado-shell-script = pkgs.writeShellScriptBin "vivado-shell" ''
    #!/bin/bash
    nix-shell --pure --argstr run "vivado" "${vivado-fhs}"
  '';

  xvivado-shell-script = pkgs.writeShellScriptBin "xvivado-shell" ''
    #!/bin/bash
    nix-shell --argstr run "vivado" "${xilinx-fhs}"
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

  run-script = pkgs.writeShellScriptBin "vitis-run" ''
    #!/bin/bash
    nix-shell --pure --argstr run "$@" "${vitis-fhs}"
  '';

  shell-scripts = [ vitis-shell-script vivado-shell-script xvivado-shell-script make-script run-script ];

in pkgs.mkShell {
  packages = with pkgs; [ ] ++ shell-scripts;
}
