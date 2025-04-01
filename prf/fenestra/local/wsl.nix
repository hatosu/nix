{ pkgs, ... }: let
  
  path = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe";

in {

  wsl = {
    enable = true;
    defaultUser = "hatosu";
  };

  environment.shellAliases = {
    user = "${path}";
    off = "${path} wsl --shutdown";
  };

  environment.interactiveShellInit = ''

    cd /mnt/c/Users/hatosu/files/

    cd(){
      if [ $# -eq 0 ]; then
        builtin cd /mnt/c/Users/hatosu/files/
      else
        builtin cd "$@"
      fi
    }
    
    fix_this_directory(){
      sudo chown -R hatosu:users ./*
      sudo chmod -R 774 ./*
      sudo find . -type f -print0 | xargs -0 sudo ${pkgs.dos2unix}/bin/dos2unix
    }

  '';
}
