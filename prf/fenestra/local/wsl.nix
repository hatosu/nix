{ ... }: let
  
  path = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe";

in {

  wsl = {
    enable = true;
    defaultUser = "hatosu";
  };

  environment.shellAliases = {
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

    vidget(){
      ${path} yt-dlp --cookies-from-browser firefox --format mp4 "$1"
    }

    audget(){
      ${path} yt-dlp -x \
      --audio-format opus --embed-metadata \
      --embed-thumbnail --add-metadata \
      --parse-metadata "uploader:%artist%" \
      --parse-metadata "title:%title%" \
      --parse-metadata "upload_date:%(upload_date)[:4]:%date%" \
      --parse-metadata "description:%comment%" \
      --cookies-from-browser firefox \
      --parse-metadata "webpage_url:%www%" -o "%(title)s.%(ext)s" "$1"
    }

  '';
}
