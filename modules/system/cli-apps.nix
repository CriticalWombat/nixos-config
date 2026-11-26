{ pkgs, ...}: 

{
    environment.systemPackages = with pkgs; [
        vim
        wget
        kitty
        wev
        claude-code
    ];
}
