{ pkgs, ...}: 

{
    environment.systemPackages = with pkgs; [
        discord
        spotify
        bitwarden-desktop
        kdePackages.kate
    ];
  # Install firefox.
  programs.firefox.enable = true;
  # Install thunderbird
  programs.thunderbird.enable = true;

}
