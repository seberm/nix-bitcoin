{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "trustedcoin";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nbd-wtf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Blha4Ba9ao/MCjfmG/V/VyDap4bfQAOCL1ZiPyt21ao=";
  };

  vendorHash = "sha256-hKaSB8/pymA7o2LuUpLjLZYn37JzEBn3a/3vkGbhLdM=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Light bitcoin node implementation";
    homepage = "https://github.com/nbd-wtf/trustedcoin";
    maintainers = with maintainers; [ seberm fort-nix ];
    platforms = platforms.linux;
  };
}
