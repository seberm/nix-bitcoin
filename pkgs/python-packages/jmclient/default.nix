{
  version
, src
, format
, lib
, buildPythonPackage
, argon2_cffi
, autobahn
, bencoderpyx
, configparser
, fetchurl
, future
, joinmarketbase
, joinmarketbitcoin
, joinmarketdaemon
, klein
, mnemonic
, pyjwt
, werkzeug
}:

buildPythonPackage rec {
  pname = "joinmarketclient";
  inherit version src format;

  #nativeBuildInputs = [
  #  setuptools
  #];

  propagatedBuildInputs = [
    argon2_cffi
    autobahn
    bencoderpyx
    configparser
    future
    joinmarketbase
    joinmarketbitcoin
    joinmarketdaemon
    klein
    mnemonic
    pyjwt
    werkzeug
  ];

  #patchPhase = ''
  #  substituteInPlace setup.py \
  #    --replace "'klein==20.6.0'" "'klein>=20.6.0'"
  #  substituteInPlace setup.py \
  #    --replace "'argon2_cffi==21.3.0'" "'argon2_cffi==23.1.0'"
  #  substituteInPlace setup.py \
  #    --replace "'pyjwt==2.4.0'" "'pyjwt==2.8.0'"
  #  substituteInPlace setup.py \
  #    --replace "'werkzeug==2.2.3'" "'werkzeug==2.3.8'"
  #'';

  # The unit tests can't be run in a Nix build environment
  doCheck = false;

  pythonImportsCheck = [
    "jmclient"
  ];

  meta = with lib; {
    description = "Client library for Bitcoin coinjoins";
    homepage = "https://github.com/Joinmarket-Org/joinmarket-clientserver";
    maintainers = with maintainers; [ seberm ];
    license = licenses.gpl3;
  };
}
