{ pkgs ? import <nixpkgs> {}, }: let

helix_config = pkgs.writers.writeTOML "-" {
  theme = "ferra";
  editor = {
    color-modes = true;
    true-color = true;
    mouse = false;
    cursorline = false;
    line-number = "relative";
    bufferline = "multiple";
    end-of-line-diagnostics = "hint";
    rulers = [0]; # change to 1 to add ruler at first column
    cursor-shape = {
      insert = "block";
      normal = "block";
      select = "block";
    };
    indent-guides = {
      render = true;
      character = "┊";
    };
    file-picker = {
      hidden = false;
    };
    soft-wrap = {
      enable = true;
      max-wrap = 25;
      max-indent-retain = 0;
      wrap-indicator = ""; /* hides wrap indicator */
    };
    statusline = {
      left = [
        "mode"
        "spinner"
        "version-control"
        "file-name"
      ];
      center = [];
      right = [
        "diagnostics"
        "selections"
        "position"
        "file-encoding"
        "file-line-ending"
        "file-type"
      ];
      separator = "│";
    };
    lsp = {
      auto-signature-help = false;
      display-messages = true;
    };
    inline-diagnostics = {
      cursor-line = "error";
      other-lines = "disable";
    };
  };
};

lsp_packages = builtins.concatStringsSep '':'' [
  "${pkgs.nixd}/bin"
  "${pkgs.marksman}/bin"
  "${pkgs.markdown-oxide}/bin"
  "${pkgs.bash-language-server}/bin"
  "${pkgs.shellcheck}/bin"
];

lsp_config = pkgs.writers.writeTOML "-" {
  language = [
    {
      name = "nix";
      language-servers = [ "nixd" ];
    }
    {
      name = "markdown";
      language-servers = [ "markdown-oxide" "marksman" ];
    }
    {
      name = "bash";
      language-servers = [ "bash-language-server" "shellcheck" ];
    }
  ];
};

/*--------*/
_ = pkgs.runCommand "-" {} ''
  mkdir -p $out/home/hx/.config/helix/themes
  cp -f ${helix_config} $out/home/hx/.config/helix/config.toml
  cp -f ${lsp_config} $out/home/hx/.config/helix/languages.toml
'';
in pkgs.writeShellScriptBin "hx" ''
  if [ ! -f $HOME/.cache/helix/helix.log ]; then
    mkdir -p $HOME/.cache/helix
    touch $HOME/.cache/helix/helix.log
  fi
  CATCH="$(echo $HOME)"
  HOME="${_}/home/hx" \
  PATH="$PATH:${lsp_packages}:${pkgs.nano}/bin" \
  ${pkgs.helix}/bin/hx --log \
  "$CATCH/.cache/helix/helix.log"
''
