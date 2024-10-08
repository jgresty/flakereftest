{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };

      lastMod = self.lastModifiedDate or self.lastModified or "";
      version =
        if (self ? shortRef) then
          self.shortRef
        else if (self ? ref) then
          self.ref
        else if (self ? rev) then
          self.rev
        else if (lastMod != "") then
          builtins.substring 0 8 lastMod
        else
          "develop";
    in
    {
      inherit self;
      packages.x86_64-linux.default = pkgs.writeShellApplication {
        name = "flake-ref-test";
        text = ''
          echo ${version}
        '';
      };
    };
}
