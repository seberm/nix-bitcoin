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
    sha256 = "sha256-wY+WAqZ2u59lR5rvalUefLilhLkeKhGHZlZrQD08TTU=";
  };

  vendorSha256 = "sha256-xvkK9rMQlXTnNyOMd79qxVSvhgPobcBk9cq4/YWbupY=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Light bitcoin node implementation";
    homepage = "https://github.com/nbd-wtf/trustedcoin";
    maintainers = with maintainers; [ seberm fort-nix ];
    platforms = platforms.linux;
  };
}
