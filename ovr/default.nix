{inputs}: let

  addPatches = pkg: patches:
  pkg.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ patches;
  });

in {

  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {

    ciano = prev.ciano.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "robertsanseries";
        repo = "ciano";
        rev = "31ae62057660e327eaf5e358a31c2364b62addbf";
        hash = "sha256-QVXvcBTyY82AZbAqCeRSEhECm4k9y/3zv0pBkuk0W9I=";
      };
      postInstall =
        (oldAttrs.postInstall or "")
        + ''
          substituteInPlace $out/share/applications/com.github.robertsanseries.ciano.desktop --replace "Name=Ciano" "Name=Convert"
        '';
    });

    waybar = addPatches prev.waybar [
      ./waybar_markup.patch
      ./waybar_workspaces.patch
    ];

    vim-numbertoggle = addPatches prev.vimPlugins.vim-numbertoggle [
      ./vim-numbertoggle-command-mode.patch
    ];

  };

  latest-packages = final: _prev: {
    latest = import inputs.nixpkgs-latest {
      system = final.system;
      config.allowUnfree = true;
      config.allowBroken = true;
    };
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

}
