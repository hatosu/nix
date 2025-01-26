{ pkgs, ... }: { environment.systemPackages =
    
      # default
      with pkgs; [
        wget
      ]
      
      # fresh
      ++ (with pkgs.fresh; [
        git
      ])
      
      # latest
      ++ (with pkgs.latest; [
        firefox
      ])
      
      # stable
      ++ (with pkgs.stable; [
        vim
      ])
      
      # pinned
      ++ (with pkgs.pinned; [
        xdotool
      ]);

      fonts.packages = with pkgs; [
        noto-fonts
        hack-font
        gohufont
      ] ++ (lib.filter lib.isDerivation (lib.attrValues pkgs.nerd-fonts));

}
