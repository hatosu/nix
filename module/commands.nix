{ pkgs, ... }: { environment = {

  interactiveShellInit = ''

    freeport(){
      ${pkgs.ruby}/bin/ruby -e 'require "socket"; puts Addrinfo.tcp("", 0).bind {|s| s.local_address.ip_port }'
    }

  '';

};}
