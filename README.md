<br />
<div align="center">
<img src="https://files.catbox.moe/umlmfy.png" alt="hatosu" width="350" height="auto" />
</div>

<h1 align="center">ハトスのNIX</h1>

<div align="center">
  
![Nix](https://img.shields.io/badge/NIX-5277C3.svg?style=for-the-badge&logo=NixOS&logoColor=white)
![Buh](https://files.catbox.moe/7uz0sd.png)
![Linux](https://img.shields.io/badge/Linux-b6debd?style=for-the-badge&logo=linux&logoColor=black)

</div>

<p float="left">
  <img src="https://files.catbox.moe/qnde5w.png" width="370" />
  <img src="https://files.catbox.moe/p246gh.png" width="370" />
</p>

> [!IMPORTANT]
> make sure `nix` is installed on your system before usage, unless you already have a `NixOS` machine…​

> [!WARNING]
> these are required if using [Windows](https://github.com/nix-community/NixOS-WSL) or [Android](https://github.com/nix-community/nix-on-droid)

---

# examples of how to use this repository...
```sh
# if an error occurs, run this command & try again (deletes any previously existing nix.conf)
echo "extra-experimental-features = flakes nix-command" | sudo tee /etc/nix/nix.conf

# install package from the "pkgs" folder (Non-declarative)
nix profile install github:hatosu/nix#chrome

# without installing anything, execute a package from the "pkgs" folder
nix run github:hatosu/nix#helix

# use the nixos-mobile configuration (Android only)
nix-on-droid switch --flake github:hatosu/nix#keitai

# use install script via NixOS usb installer (NixOS only)
nix --experimental-features "nix-command flakes" run github:hatosu/nix#install

# rebuild system according to a profile from the "prf" folder (NixOS only)
nixos-rebuild switch --flake github:hatosu/nix#benzi
```
