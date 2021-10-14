{ pkgs ? import <nixpkgs> {} }:

let
  vitis-fhs = "./nix/vitis-fhs-env.nix";
  vivado-fhs = "./nix/vivado-fhs-env.nix";
  xilinx-fhs = "./nix/xilinx-fhs-env.nix";

  vitis-repl-script = pkgs.writeShellScriptBin "vitis-repl" ''
    #!/bin/bash
    nix-shell --pure --argstr run "vitis_hls -i" "${xilinx-fhs}"
  '';

  vivado-run-command = "vivado -log ./logfiles/vivado/vivado.log -journal ./logfiles/vivado/vivado.jou";
  vivado-gui-script = pkgs.writeShellScriptBin "vivado-gui" ''
    #!/bin/bash
    nix-shell --argstr run "${vivado-run-command}" "${xilinx-fhs}"
  '';

  makefile-contents = builtins.readFile ./nix/Makefile;
  makefile-run-command = "make -f ./nix/Makefile -I ./ $*";
  make-script = pkgs.writeShellScriptBin "make" ''
    function run {
      nix-shell --pure --argstr run "${makefile-run-command}" "${xilinx-fhs}"
    }

    if [[ $# -eq 0 ]]; then
      run
    else
      run "$@"
    fi
  '';

  run-script = pkgs.writeShellScriptBin "xilinx-shell" ''
    #!/bin/bash
    nix-shell --pure --argstr run "bash" "${xilinx-fhs}"
  '';

  shell-scripts = [ vitis-repl-script vivado-gui-script make-script run-script ];

in pkgs.mkShell {
  packages = with pkgs; [ ] ++ shell-scripts;
}
