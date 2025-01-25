{ ... }: {

  wsl = {
    enable = true;
    defaultUser = "hatosu";
  };

  environment.shellAliases = let
    path = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe";
  in {
    user = "${path}";
    admin = "${path} sudo";
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
  '';

}
