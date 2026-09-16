{ pkgs, ... }:

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
    #rstudio
  ];

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
  };

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  # Do not change this just because Home Manager is upgraded.
  home.stateVersion = "26.05";
}
