{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "trustedcoin";
  version = "0.6.1";
  src = fetchFromGitHub {
    #owner = "nbd-wtf";
    owner = "seberm";
    repo = pname;
    #rev = "v${version}";
    rev = "feature/add-proxy-support";
    #sha256 = "sha256-UNQjxhAT0mK1In7vUtIoMoMNBV+0wkrwbDmm7m+0R3o=";
    sha256 = "sha256-OqHOSyh1Gny+9QrmfpdL7QOHOrt1+TI20iDtakjo9pU=";
  };

  #vendorSha256 = "sha256-xvkK9rMQlXTnNyOMd79qxVSvhgPobcBk9cq4/YWbupY=";
  vendorSha256 = "sha256-VMltdpxPr8Y6K5rmG/7z6C9DwQUy4lOAATJc7AgVrjE=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Light bitcoin node implementation";
    homepage = "https://github.com/nbd-wtf/trustedcoin";
    maintainers = with maintainers; [ seberm fort-nix ];
    platforms = platforms.linux;
  };
}
