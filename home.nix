{ pkgs, ... }:

let
  rstudio-bin = pkgs.callPackage ./packages/rstudio-bin.nix { };

  lean4-mode = pkgs.callPackage ./packages/lean4-mode.nix {
    emacsPackages = pkgs.emacsPackages;
  };
in
{
  imports = [
    ./plasma.nix
  ];

  home.username = "i";
  home.homeDirectory = "/home/i";

  # Applications
  home.packages = with pkgs; [
    firefox
    kdePackages.kate
    kdePackages.okular
    rstudio-bin
    slack
  ];

  programs.bash.enable = true;
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  # Git
  programs.git = {
    enable = true;

    settings = {
      user.name = "David Dragota";
      user.email = "atugard@proton.me";
      init.defaultBranch = "main";
    };
  };

  # GitHub CLI
  programs.gh.enable = true;

  # Emacs

  programs.emacs = {
  enable = true;
  package = pkgs.emacs-pgtk;

  extraPackages = epkgs: with epkgs; [
    expand-region
    multiple-cursors
    magit
    nix-mode
    lsp-mode
    envrc
    lean4-mode
    ];
  };
  


home.file.".emacs.d/init.el".source = ./emacs/init.el;

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  # Do not change this just because Home Manager is upgraded.
  home.stateVersion = "26.05";
}
