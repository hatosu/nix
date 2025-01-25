{ pkgs, ... }: { environment = {

  shellAliases = {

    # general
    y = "yazi";
    m = "mpv";
    c = "clear";
    logout = "kill -9 -1";
    hist = "history | grep";
    fixdir = "sudo chown -R hatosu:users";
    skip = "playerctl next";
    pause = "playerctl play-pause";
    back = "playerctl previous";
    radio = "radio-cli";
  
    # nixpkgs
    f = "cd $(dirname $(${pkgs.stable.fd}/bin/fd --type file | ${pkgs.stable.skim}/bin/sk))";
    ff = "${pkgs.fastfetch}/bin/fastfetch";
    scan = "${pkgs.stable.vulnix}/bin/vulnix --system --verbose";
    dupe = "${pkgs.stable.rmlint}/bin/rmlint";
    anime = "${pkgs.ani-cli}/bin/ani-cli -q 1080p";
    brightness = "${pkgs.stable.brightnessctl}/bin/brightnessctl";
    chatgpt = "${pkgs.stable.tgpt}/bin/tgpt";
    phind = "${pkgs.stable.tgpt}/bin/tgpt --provider phind";
    disk = "${pkgs.stable.ncdu}/bin/ncdu";
    audio = "${pkgs.stable.ponymix}/bin/ponymix";
    drag = "${pkgs.stable.ripdrag}/bin/ripdrag -r";
    opt = "${pkgs.stable.image_optim}/bin/image_optim";
    home = "cd && v $(${pkgs.stable.skim}/bin/sk)";
    conf = "cd ~/files/config && v $(${pkgs.stable.skim}/bin/sk) && cd";
    pget = "${pkgs.stable.pirate-get}/bin/pirate-get -T -S ~/Downloads";
    tor = "${pkgs.stable.aria2}/bin/aria2c";
    metaclean = "${pkgs.stable.metadata-cleaner}/bin/metadata-cleaner";
    cat = "${pkgs.bat}/bin/bat --theme gruvbox-dark -p";
    webget = "${pkgs.latest.wget}/bin/wget -mpEk";
    gifget = "${pkgs.latest.yt-dlp}/bin/yt-dlp --format gif";
    vidget = "${pkgs.stable.yt-dlp}/bin/yt-dlp --format mp4";
    audget = "${pkgs.stable.yt-dlp}/bin/yt-dlp -x --no-keep-video";
    spotget = "${pkgs.stable.spotdl}/bin/spotdl --format mp3";
    browse = "${pkgs.stable.w3m}/bin/w3m";
    pings = "${pkgs.stable.gping}/bin/gping";
    tasks = "${pkgs.stable.htop}/bin/htop";
  
  };

  interactiveShellInit = ''

    open(){
      sudo updatedb
      nvim $(locate -ie "$1" | ${pkgs.skim}/bin/sk)
    }

    epubtopdf(){
      PATH=$PATH:${pkgs.texliveFull}/bin
      ${pkgs.pandoc}/bin/pandoc -V fontsize=12pt -V geometry:margin=1in -f epub -t latex -o output.pdf --pdf-engine=xelatex
    }

    hist(){
      history | grep "$1" | less +G
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
