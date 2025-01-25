{ pkgs, ... }: let

  EDITOR = "nvim";

  LOGO = "⁎";

  INIT = pkgs.writeShellScriptBin "tmux_init" ''
    S="hatosu-tmux"
    tmux has-session -t=$S 2> /dev/null
    if [[ $? -ne 0 ]]; then
      TMUX="" tmux new-session -d -s "$S" -n "zsh"
      TMUX="" tmux send-keys -t $S:zsh "echo 'guh... mlem...'" C-m
      #TMUX="" tmux new-window -t $S -n "edit"
      #TMUX="" tmux send-keys -t $S:edit "${EDITOR}" C-m
      #TMUX="" tmux new-window -t $S -n "logs"
      #TMUX="" send-keys -t $S:logs "sudo journalctl -f" C-m
    fi
    if [[ -z "$TMUX" ]]; then
      tmux attach -t "$S"
    else
      tmux switch-client -t "$S"
    fi
  '';

in {

  home-manager.users.hatosu = {

    programs.zsh.initExtraFirst = "tmux_init";

    programs.tmux = {

      enable = true;
      package = pkgs.tmux;
      aggressiveResize = false;
      clock24 = true;
      customPaneNavigationAndResize = false;
      disableConfirmationPrompt = true;
      focusEvents = false;
      mouse = false;
      newSession = false;
      reverseSplit = false;
      secureSocket = true;
      sensibleOnTop = false;

      keyMode = if let x = [ "vi" "vim" "nvim" ]; in builtins.elem EDITOR x then "vi" else "emacs";

      prefix = "C-a";
      shortcut = "b";
      terminal = "screen-256color";

      baseIndex = 0;
      escapeTime = 500;
      historyLimit = 5000;
      resizeAmount = 5;

      plugins = with pkgs; [
        
        tmuxPlugins.cpu
        
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '1' # minutes
          '';
        }
      
      ];

      extraConfig = ''
         bind h select-pane -L
         bind j select-pane -D
         bind k select-pane -U
         bind l select-pane -R
         set-option -sg escape-time 10
         set -g pane-border-style fg='#6272a4'
         set -g pane-active-border-style fg='#ff79c6'
         set -g message-style bg='#44475a',fg='#8be9fd'
         set -g status-style bg='#44475a',fg='#bd93f9'
         set -g status-interval 1
         set -g status-left '#[bg=#f8f8f2]#[fg=#282a36]#{?client_prefix,#[bg=#ff79c6],} ${LOGO} '
         set -ga status-left '#[bg=#44475a]#[fg=#ff79c6] #{?window_zoomed_flag, ↕  ,   }'
         set -g window-status-current-format "#[fg=#44475a]#[bg=#bd93f9]#[fg=#f8f8f2]#[bg=#bd93f9] #I #W #[fg=#bd93f9]#[bg=#44475a]"
         set -g window-status-format "#[fg=#f8f8f2]#[bg=#44475a]#I #W #[fg=#44475a] "
         set -g status-right '#[fg=#8be9fd,bg=#44475a]#[fg=#44475a,bg=#8be9fd] #(tmux-mem-cpu-load -g 5 --interval 2) '
         set -ga status-right '#[fg=#ff79c6,bg=#8be9fd]#[fg=#44475a,bg=#ff79c6] #(uptime | cut -f 4-5 -d " " | cut -f 1 -d ",") '
         set -ga status-right '#[fg=#bd93f9,bg=#ff79c6]#[fg=#f8f8f2,bg=#bd93f9] %a %H:%M:%S #[fg=#6272a4]%Y-%m-%d '
         set -ga terminal-overrides ",xterm-256color:Tc"
       '';
  
};home.packages=[INIT];};}
