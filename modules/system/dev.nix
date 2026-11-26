{ pkgs, ...}: 

{
# Install System Packages

    environment.systemPackages = with pkgs; [
        jetbrains.pycharm
    ];

# Install Git

  programs.git = {
    enable = true;
    config = {
      user.name = "CriticalWombat";
      user.email = "CriticalWombats@gmail.com";
      init.defaultBranch = "main";
    };
  };

# SSH GitHub Authentication
  programs.ssh.extraConfig = ''
    Host github.com
      User git
      IdentityFile ~/.ssh/gh_auth.key
      IdentitiesOnly yes
  '';  

# Install Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      allVolumes.enable = true;
    };
  };

}
