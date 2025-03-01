{ pkgs, ... }: { environment = {

  shellAliases = {
    reload = "omz reload";
    md = "${pkgs.glow}/bin/glow -np";
    c = "clear";
    f = "cd $(dirname $(${pkgs.stable.fd}/bin/fd --type file | ${pkgs.stable.skim}/bin/sk))";
    ff = "${pkgs.fastfetch}/bin/fastfetch";
    deepseek = "ollama run deepseek";
    chatgpt = "${pkgs.stable.tgpt}/bin/tgpt";
    phind = "${pkgs.stable.tgpt}/bin/tgpt --provider phind";
    cat = "${pkgs.bat}/bin/bat --theme gruvbox-dark -p";
    scan = "${pkgs.stable.vulnix}/bin/vulnix --system --verbose";
    dupe = "${pkgs.stable.rmlint}/bin/rmlint";
    brightness = "${pkgs.stable.brightnessctl}/bin/brightnessctl";
    disk = "${pkgs.stable.ncdu}/bin/ncdu";
    opt = "${pkgs.stable.image_optim}/bin/image_optim";
    pget = "${pkgs.stable.pirate-get}/bin/pirate-get -T -S ~/Downloads";
    tor = "${pkgs.stable.aria2}/bin/aria2c";
    metaclean = "${pkgs.stable.metadata-cleaner}/bin/metadata-cleaner";
    browse = "${pkgs.stable.w3m}/bin/w3m";
    pings = "${pkgs.stable.gping}/bin/gping";
    tasks = "${pkgs.stable.htop}/bin/htop";
  };

  interactiveShellInit = ''

    webget(){
      printf "name of folder to be created: " >&2
      read -r M
      wget -mEkKp "$1" -P "$M"
    }

    # OPUS IS HIGHER QUALITY THAN MP3 >:D
    getopus(){
      ${pkgs.yt-dlp}/bin/yt-dlp -x --audio-format opus \
      --embed-metadata --embed-thumbnail --add-metadata \
      --parse-metadata "uploader:%artist%" \
      --parse-metadata "title:%title%" \
      --parse-metadata "upload_date:%(upload_date)[:4]:%date%" \
      --parse-metadata "description:%comment%" \
      --parse-metadata "webpage_url:%www%" \
      -o "%(title)s.%(ext)s" "$1"
    }

    epub2pdf(){
      sh -c "${pkgs.calibre}/bin/ebook-convert $1 output.pdf"
    }

    mp42gif(){
      ffmpeg -i "$1" -r 15 -vf \
      "scale=512:-1,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse"
      output.gif
    }

    freeport(){
      ${pkgs.ruby}/bin/ruby -e 'require "socket"; puts Addrinfo.tcp("", 0).bind {|s| s.local_address.ip_port }'
    }

    hist(){
      history | grep "$1" | less +G
    }

    fix_this_directory(){
      sudo chown -R hatosu:users ./*
      sudo chmod -R 774 ./*
      sudo find . -type f -print0 | xargs -0 sudo dos2unix
    }

    webmtomp4(){
      sudo ${pkgs.ffmpeg}/bin/ffmpeg -i "$1" -c copy output.mp4
    }

    merge_opus(){
      find . -maxdepth 1 -name "*.opus" -type f | sort > input_files.txt
      if [ ! -s input_files.txt ]; then
        echo "No .opus files found in current directory"
        rm input_files.txt
        exit 1
      fi
      rm -f concat.txt
      while IFS= read -r file; do
        echo "file '$file'" >> concat.txt
      done < input_files.txt
      ffmpeg -f concat -safe 0 -i concat.txt -c copy final.opus
      rm input_files.txt concat.txt
    }

    shafind(){
      if [[ ! -z "$1" ]]; then
        curl "$1" | sha256sum
      else
        sha256sum "$1"
      fi
    }

    iconfind(){
      if [[ ! -z "$1" ]]; then
        xdg-open "https://www.google.com/search?q=$1+icon+filetype:png&udm=2"
      else
        echo 'Invalid Link!'
      fi
    }

    run(){
      number=$1
      shift
      for i in `seq $number`; do
        $@
      done
    }

    newest(){
      find . -type f \( ! -regex '.*/\..*' \) -print0 | xargs -0 stat -c "%Y:%n" | sort -n| tail -n 10 | cut -d ':' -f2-
    }

    ex(){
      if [ -f $1 ] ; then
        case $1 in
          *.tar.bz2)${pkgs.toybox}/bin/tar xvjf $1 ;;
          *.tar.gz)${pkgs.toybox}/bin/tar xvzf $1 ;;
          *.bz2)${pkgs.toybox}/bin/bunzip2 $1 ;;
          *.rar)${pkgs.unrar}/bin/unrar x $1 ;;
          *.gz)${pkgs.toybox}/bin/gunzip $1 ;;
          *.tar)${pkgs.toybox}/bin/tar xvf $1 ;;
          *.tbz2)${pkgs.toybox}/bin/tar xvjf $1 ;;
          *.tgz)${pkgs.toybox}/bin/tar xvzf $1 ;;
          *.zip)${pkgs.unzip}/bin/unzip $1 ;;
          *.Z)${pkgs.ncompress}/bin/compress $1 ;;
          *.7z)${pkgs.p7zip}/bin/7z x $1 ;;
          *)echo "can't extract '$1'..." ;;
        esac
      else
        echo "'$1' is not a valid file!"
      fi
    }

  '';

};}
