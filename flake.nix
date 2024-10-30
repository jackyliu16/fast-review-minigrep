{
  description = "Only Provide the support of qemu";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ 
          (import rust-overlay)
          (_: super: {
            rust-toolchain =
              let
                rust = super.rust-bin;
              in
              if builtins.pathExists ./rust-toolchain.toml then
                rust.fromRustupToolchainFile ./rust-toolchain.toml
              else if builtins.pathExists ./rust-toolchain then
                rust.fromRustupToolchainFile ./rust-toolchain
              else
                rust.nightly.latest.default;
                # The rust-toolchain when i make this file, which maybe change
                # (rust.nightly.latest.override {
                #   extensions = [ "rust-src" "llvm-tools-preview" "rustfmt" "clippy" ];
                #   targets = [ "x86_64-unknown-none" "riscv64gc-unknown-none-elf" "aarch64-unknown-none-softfloat" ];
                # });
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs;[
              gnumake
              # Basic
              openssl
              pkg-config
              fd
              # Development tools
              ripgrep
              fzf
              zellij
              # Rust Configuraiton  
              zlib
              rustup
              cargo-binutils
              rust-toolchain
            ];

            # nativeBuildInputs = with pkgs; [
            #   llvmPackages.libclang
            #   llvmPackages.libcxxClang
            #   clang
            # ];
            # LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib"; # nixpkgs@52447
            # BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${pkgs.llvmPackages.libclang.lib}/lib/clang/${pkgs.lib.getVersion pkgs.clang}/include"; # https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-853429315

            shellHook = ''
              # exec zsh

              # Change the mirror of rust
              export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
              export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
            '';
              # unset OBJCOPY # Avoiding Overlay
              # export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib" # nixpkgs@52447
              # export LD_LIBRARY_PATH="${pkgs.zlib}/lib:$LD_LIBRARY_PATH" # nixpkgs@92946
          };
        };
      }
    );
}
