{ pkgs, ... }: { environment = let
_ = "command disabled"; x = pkgs; in {

  shellAliases = {

    # general
    logout = "kill -9 -1";
    hist = "history | grep";
  
    # pkgs
    cat = "${x.bat}/bin/bat --theme gruvbox-dark -p";
    scan = "${x.vulnix}/bin/vulnix --system --verbose";
    anime = "${x.ani-cli}/bin/ani-cli -q 1080p";
    bright = "${x.brightnessctl}/bin/brightnessctl";
    audio = "${x.ponymix}/bin/ponymix";
    drag = "${x.ripdrag}/bin/ripdrag -r";
    opt = "${x.image_optim}/bin/image_optim";
    tor = "${x.aria2}/bin/aria2c";
    meta = "${x.metadata-cleaner}/bin/metadata-cleaner";

    # gets
    pirget = "${x.pirate-get}/bin/pirate-get -T -S ~/Downloads";
    webget = "${x.wget}/bin/wget -mpEk";
    gifget = "${x.yt-dlp}/bin/yt-dlp --format gif";
    vidget = ''${x.yt-dlp}/bin/yt-dlp --format mp4 -S "height:1080" -f "bv*"'';
    audget = "${x.yt-dlp}/bin/yt-dlp -x --no-keep-video";

    # disable
    clear = "echo ${_}";
  
  };

  interactiveShellInit = ''

    storage(){
      sudo printf "\nthis will take a while...\n\n"
      sudo du -aBG -d 1 / 2> >(grep -v \
      '^du: cannot \(access\|read\)' >&2) | sort -nr | head -20
    }
  
    freeport(){
      ${x.ruby}/bin/ruby -e 'require "socket"; \
      puts Addrinfo.tcp("", 0).bind {|s| s.local_address.ip_port }'
    }

    music(){
      PLAYLIST="$(find ~/files/song/ -type d | ${x.skim}/bin/sk)"
      PICKED_SONG="$(find $PLAYLIST -type f -name "*.opus" | ${x.skim}/bin/sk)"
      ${x.sox}/bin/play "$PICKED_SONG"
      while true; do
        RANDOM_SONG="$(find $PLAYLIST -type f -name "*.opus" | shuf -n 1)"
        ${x.sox}/bin/play "$RANDOM_SONG"
      done
    }

    opusget(){
      ${x.yt-dlp}/bin/yt-dlp -x --audio-format opus \
      --embed-metadata --embed-thumbnail --add-metadata \
      --parse-metadata "uploader:%artist%" \
      --parse-metadata "title:%title%" \
      --parse-metadata "upload_date:%(upload_date)[:4]:%date%" \
      --parse-metadata "description:%comment%" \
      --parse-metadata "webpage_url:%www%" \
      -o "%(title)s.%(ext)s" "$1"
    }

    newest(){
      find . -type f \( ! -regex '.*/\..*' \) -print0 | xargs -0 stat -c "%Y:%n" | sort -n| tail -n 10 | cut -d ':' -f2-
    }

    ex(){
      if [ -f $1 ] ; then
        case $1 in
          *.tar.bz2)${x.toybox}/bin/tar xvjf $1 ;;
          *.tar.gz)${x.toybox}/bin/tar xvzf $1 ;;
          *.bz2)${x.toybox}/bin/bunzip2 $1 ;;
          *.rar)${x.unrar}/bin/unrar x $1 ;;
          *.gz)${x.toybox}/bin/gunzip $1 ;;
          *.tar)${x.toybox}/bin/tar xvf $1 ;;
          *.tbz2)${x.toybox}/bin/tar xvjf $1 ;;
          *.tgz)${x.toybox}/bin/tar xvzf $1 ;;
          *.zip)${x.unzip}/bin/unzip $1 ;;
          *.Z)${x.ncompress}/bin/compress $1 ;;
          *.7z)${x.p7zip}/bin/7z x $1 ;;
          *)echo "can't extract '$1'..." ;;
        esac
      else
        echo "'$1' is not a valid file!"
      fi
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

    run(){
      number=$1
      shift
      for i in `seq $number`; do
        $@
      done
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

    epub2pdf(){
      sh -c "${x.calibre}/bin/ebook-convert $1 output.pdf"
    }

    webm2mp4(){
      sudo ${x.ffmpeg}/bin/ffmpeg -i "$1" -c copy output.mp4
    }
 
  '';

};}
