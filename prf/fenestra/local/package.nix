{ pkgs, ... }: { environment.systemPackages =

      # default
      with pkgs; [
        install
        help
        nixfind
        tokei
        zip
        wget
        lshw
        dos2unix
        openssh
      ]

      # fresh
      ++ (with pkgs.fresh; [
        git
      ])

      # latest
      ++ (with pkgs.latest; [
        httrack
        ffmpeg
      ])

      # stable
      ++ (with pkgs.stable; [
        tree
        ripgrep
        rarcrack
        hyperfine
        watchexec
        shellcheck
        rclone
      ])

      # pinned
      ++ (with pkgs.pinned; [
        element
      ]);

      # fonts
      fonts.packages = with pkgs; [
        source-code-pro
        font-awesome
        gohufont
        hack-font
        noto-fonts
      ] ++ (lib.filter lib.isDerivation (lib.attrValues pkgs.nerd-fonts));

}
