# NixOS Configuration

This is the configuration setup for my personal use case of NixOS. It is broken up into modules to make the configuration somewhat sensible and allows reusing Nix code for different hosts. There is also a few shell scripts that can be added to a NixOS system. They are also in modules that can be imported individually.

The configuration uses flakes and manages a couple different systems I run located in the hosts directory:

- xansaware - the configuration for the main desktop PC I run
- xansawarejb - the configuration for a Raspberry Pi 4 Model B which is responsible for allowing me to remotely turn on the xansaware host using WOL
- xansago - the configuration for a lightweight laptop that I have
- xansaserver - the configuration for a system I run as a server

## Additional Notes

- xansawarejb currently doesn't output any display but does indeed run. Currently, the only way to access it is to SSH into it with a bit of setup beforehand to allow connecting to my home network.
- xansawarejb's configuration is in the old structure that I started with and has not been restructured. This will be dealt with, eventually.
- xansaserver is a lightweight server I use that's always online but it runs on an old Acer Aspire R15 laptop since it's the only spare machine I have.
