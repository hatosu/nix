{
  pkgs,
  strings,
  ...
}: let
  icon = strings.logotxt;
in {
  home-manager.users.hatosu.programs.fastfetch = {
    enable = true;
    package = pkgs.fastfetch;
    settings = {
      # visual
      display = {
        size.binaryPrefix = "si";
        color = "blue";
        separator = " ";
      };

      # modules
      modules = [
        {
          type = "os";
          format = "{2} {9}";
          key = "╭────";
        }
        {
          type = "kernel";
          format = "{1} {2}";
          key = "│ ";
        }
        {
          type = "packages";
          key = "│ ";
        }
        {
          type = "wm";
          key = "│ ";
        }
        {
          type = "terminal";
          key = "│ ";
        }
        {
          type = "cpu";
          key = "│ ";
        }
        {
          type = "gpu";
          key = "│ ";
        }
        {
          type = "disk";
          key = "│ ";
        }
        {
          type = "command";
          text = "printf '\\0'";
          key = "╰────────────────────";
        }
      ];

      logo = {
        source = "${icon}";
      };
    };
  };
}
