how to install:
  ```bash
  # run this within usb installer
  nix --experimental-features "nix-command flakes" run github:hatosu/nix#install

  # power off & unplug usb stick
  shutdown now

  # reboot, choose profile & rebuild
  nixos-rebuild switch --flake github:hatosu/nix#<insert-profile-of-choice>
  ```