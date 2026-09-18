{ lib
, fetchFromGitHub
, emacsPackages
}:

emacsPackages.trivialBuild {
  pname = "lean4-mode";
  version = "unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "lean4-mode";
    rev = "1388f9d1429e38a39ab913c6daae55f6ce799479";

    hash = "sha256-6XFcyqSTx1CwNWqQvIc25cuQMwh3YXnbgr5cDiOCxBk=";
  };

  packageRequires = with emacsPackages; [
    compat
    dash
    magit-section
    lsp-mode
  ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/data
    cp -r $src/data/* $out/share/emacs/site-lisp/data/
  '';

  meta = {
    description = "Emacs major mode for Lean 4";
    homepage = "https://github.com/leanprover-community/lean4-mode";
    license = lib.licenses.asl20;
  };
}
