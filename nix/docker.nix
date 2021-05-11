{ imageTag ? null }:

with import ./stackyaml.nix {};

let
  dockerTools = pkgs.dockerTools;
  sourceImage = dockerTools.pullImage {
        imageName = "centos";
        imageDigest = "sha256:e4ca2ed0202e76be184e75fb26d14bf974193579039d5573fb2348664deef76e";
        sha256 = "1j6nplfs6999qmbhjkaxwjgdij7yf31y991sna7x4cxzf77k74v3";
        finalImageTag = "7";
        finalImageName = "centos";
      };

  makeDockerImage = name: revision: packages: entryPoint:
    dockerTools.buildImage {
      name = name;
      tag = revision;
      fromImage = sourceImage;
      contents = (with pkgs; [ bashInteractive coreutils htop strace ]) ++ packages;
      config.Cmd = entryPoint;
    };

  hello-world = project.hello-world.components.exes.hello-world;
  helloImage = makeDockerImage "hello" 
    (if imageTag == null then "undefined" else imageTag)
    [ hello-world ]
    [ "${hello-world}/bin/hello-world"
    ];

in { inherit helloImage; }
