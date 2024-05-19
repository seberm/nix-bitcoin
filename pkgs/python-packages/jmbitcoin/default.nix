{ version, src, format, lib, buildPythonPackage, fetchurl, setuptools, python-bitcointx, joinmarketbase, pytestCheckHook }:

#buildPythonPackageWithDepsCheck rec {
buildPythonPackage rec {
  pname = "joinmarketbitcoin";
  inherit version src format;

  #postUnpack = "sourceRoot=$sourceRoot/src/jmbitcoin";

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    python-bitcointx
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-warn 'twisted==23.10.0' 'twisted==24.3.0' \
      --replace-warn 'service-identity==21.1.0' 'service-identity==24.1.0' \
      --replace-warn 'cryptography==41.0.6' 'cryptography==42.0.5'
  '';

  checkInputs = [ joinmarketbase ];

  # FIXME: fix checks?
  nativeCheckInputs = [
    #pytestCheckHook
  ];

  # TODO: possibly missing?
  #pythonImportsCheck = [
  #  "jmbitcoin"
  #];

  meta = with lib; {
    homepage = "https://github.com/Joinmarket-Org/joinmarket-clientserver";
    maintainers = with maintainers; [ seberm ];
    license = licenses.gpl3;
  };
}
