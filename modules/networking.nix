{pkgs, config, ...}:

{
# Enable networking
  networking.networkmanager.enable = true;

# Tailscale settings
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraSetFlags = [ "--accept-routes" ];
  };
  networking.firewall = {
    enable = true;
    trustedInterfaces = [
      "tailscale0"
    ];
  };

# SSH settings

  services.openssh = {
    enable = true;
    ports = [22];
    settings.PasswordAuthentication = false;
    settings.Banner = "/etc/ssh/banner";
    settings.UsePAM = true;
  };

}
