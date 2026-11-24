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
}
