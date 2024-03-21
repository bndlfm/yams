{
  description = "YAMS - Yet Another Mpd Scrobbler";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    yams.url = "github:Berulacks/yams";
  };

  outputs = { self, nixpkgs, yams }: {

    packages.x86_64-linux.yams = let
      pkgs = import nixpkgs {system = "x86_64-linux";};
      pythonEnv = pkgs.python3.withPackages (ps: with ps; [pyyaml psutil python-mpd2]);
      src = "${yams}";

    in pkgs.stenv.mkDerivation{
      pname = "yams";
      version = "0.7.3";
      buildInputs = [ pythonEnv pkgs.makeWrapper ];


      phases = "installPhase";

      installPhase = ''
        mkdir -p $out/bin
        cp -r ${src}/yams $out/yams
        # Assuming __main__.py is your entry point
        makeWrapper ${pythonEnv}/bin/python $out/bin/yams --add-flags "$out/yams/__main__.py"
      '';
    };

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.yams;

      meta = {
        description = "Yet Another Mpd Scrobbler";
        homepage = "https://github.com/Berulacks/yams";
        license = nixpkgs.lib.licenses.gpl3;
        maintainers = with nixpkgs.lib.maintainers; [ berulacks ];
      };
    };

}
