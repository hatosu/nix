{ pkgs, ... }: let

  deps = with pkgs; [
    wallpaper
    wlr-randr
    hyprpicker
  ];

  init = pkgs.writeShellScriptBin "-" ''

    #autostart
    # wlr-randr --output eDP-1 --on --mode 2880x1800@60.000999 --scale 1.75 &
    fcitx5 &
    wallpaper &

    #bindings
    mod="Mod4"
    riverctl map normal $mod L spawn alacritty
    riverctl map normal $mod O spawn "hyprpicker -a"
    riverctl map normal $mod Q close
    riverctl map normal $mod A resize horizontal -100
    riverctl map normal $mod M resize vertical 100
    riverctl map normal $mod N resize vertical -100
    riverctl map normal $mod F resize horizontal 100
    riverctl map normal $mod S focus-view next
    riverctl map normal $mod D focus-view previous
    riverctl map normal $mod X toggle-float
    riverctl map normal $mod Up    send-layout-cmd rivertile "main-location top"
    riverctl map normal $mod Right send-layout-cmd rivertile "main-location right"
    riverctl map normal $mod Down  send-layout-cmd rivertile "main-location bottom"
    riverctl map normal $mod Left  send-layout-cmd rivertile "main-location left"
    riverctl map normal $mod+Shift S swap next
    riverctl map normal $mod+Shift D swap previous
    riverctl map normal $mod+Shift F toggle-fullscreen
    riverctl map normal $mod+Shift Y exit
    riverctl map-pointer normal $mod BTN_LEFT move-view
    riverctl map-pointer normal $mod BTN_RIGHT resize-view

    #visual
    riverctl border-color-focused 0xa6729f
    riverctl border-color-unfocused 0x404b66
    riverctl border-width 1
    riverctl default-layout rivertile
    riverctl spawn "rivertile -main-ratio 0.50"

    #rules
    riverctl rule-add -app-id 'float*' -title 'ripdrag' float

    #workspaces
    for i in $(seq 1 6)
    do
      tags=$((1 << ($i - 1)))
      riverctl map normal $mod $i set-focused-tags $tags
      riverctl map normal $mod+Shift $i set-view-tags $tags
      riverctl map normal $mod+Control $i toggle-focused-tags $tags
      riverctl map normal $mod+Shift+Control $i toggle-view-tags $tags
    done

    #misc
    riverctl keyboard-layout us
    riverctl input pointer-10248-536-ASUF1208:00_2808:0218_Touchpad tap enabled
    riverctl input pointer-10248-536-ASUF1208:00_2808:0218_Touchpad drag enabled
    riverctl input pointer-10248-536-ASUF1208:00_2808:0218_Touchpad disable-while-typing enabled enabled
    riverctl input pointer-10248-536-ASUF1208:00_2808:0218_Touchpad middle-emulation enabled
    riverctl input pointer-10248-536-ASUF1208:00_2808:0218_Touchpad natural-scroll enabled
    riverctl input pointer-10248-536-ASUF1208:00_2808:0218_Touchpad tap-button-map left-right-middle
    riverctl input pointer-10248-536-ASUF1208:00_2808:0218_Touchpad scroll method two-finger
    riverctl focus-follows-cursor always
    riverctl hide-cursor when-typing enabled
    riverctl set-cursor-warp on-focus-change
    riverctl set-repeat 50 300
  '';

in {

  programs.river = {
    enable = true;
    package = pkgs.river;
    xwayland.enable = true;
    extraPackages = deps;
  };

  services.displayManager = {
    ly.enable = true;
    sessionPackages = [
      ((pkgs.writeTextDir
      "share/wayland-sessions/river.desktop" ''
        [Desktop Entry]
        Name=RiverDesktop
        Comment=buh
        Exec=dbus-run-session river -c "${init}"
        Type=Application
      '').overrideAttrs(_:{
      passthru.providedSessions=["river"];}))
    ];
  };
  
}
