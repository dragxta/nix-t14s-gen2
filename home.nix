{ pkgs, ... }:

let
  rstudio-bin = pkgs.callPackage ./packages/rstudio-bin.nix { };
  photocraft = pkgs.callPackage ./packages/photocraft.nix { };
  lean4-mode = pkgs.callPackage ./packages/lean4-mode.nix {
    emacsPackages = pkgs.emacsPackages;
  };

  # Tree-sitter grammars for the built-in *-ts-mode majors (c-ts-mode,
  # c++-ts-mode, cmake-ts-mode). The compilers and clangd come from each
  # project's own flake via direnv/envrc, not from here.
  emacs-grammars =
    pkgs.emacsPackages.treesit-grammars.with-grammars (g: with g; [
      tree-sitter-c
      tree-sitter-cpp
      tree-sitter-cmake
    ]);
in
{
  imports = [
    ./plasma.nix
  ];

  home.username = "i";
  home.homeDirectory = "/home/i";
  home.sessionPath = [ "$HOME/.local/bin" ];
  programs.bash.initExtra = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';


  # Applications
  home.packages = with pkgs; [
    firefox
    ungoogled-chromium
    kdePackages.kate
    kdePackages.okular
    rstudio-bin
    slack
    zip
    unzip
    codex
    claude-code
    telegram-desktop
    signal-desktop
    blender
    photocraft
    gimp
  ];

  programs.bash.enable = true;
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  programs.mcp = {
    enable = true;

    servers = {
      playwright = {
        command = "${pkgs.nodejs}/bin/npx";
        args = [ "-y" "@playwright/mcp@latest" ];
      };
    };
  };

  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        jnoortheen.nix-ide
        mkhl.direnv
        dotenv.dotenv-vscode
        editorconfig.editorconfig
        esbenp.prettier-vscode
        eamodio.gitlens
        usernamehw.errorlens
        streetsidesoftware.code-spell-checker
      ];

      enableMcpIntegration = true;
      userSettings = {
        "cSpell.enabledLanguageIds" = [
          "markdown"
          "plaintext"
        ];
      };
    };
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
    catppuccin-theme
    company

    # C / C++
    lsp-ui
    flycheck
    clang-format
    cmake-mode
    emacs-grammars
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
