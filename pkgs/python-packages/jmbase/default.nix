{ version, src, format, lib, buildPythonPackageWithDepsCheck, buildPythonPackage, fetchurl, twisted, cryptography, service-identity, chromalog, txtorcon, setuptools, pythonOlder, pythonAtLeast }:

#buildPythonPackageWithDepsCheck rec {
buildPythonPackage rec {
  pname = "joinmarketbase";
  inherit version src format;

  # From v0.9.11, the Python older than v3.8 is not supported. Python v3.12 is
  # still not supported.
  disabled = (pythonOlder "3.8") || (pythonAtLeast "3.13");

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    chromalog
    service-identity
    twisted
    txtorcon
  ];

  # FIXME: Try to use twisted and service-identity from nixpkgs-23.11 (there are lower stable versions)?
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-warn 'twisted==23.10.0' 'twisted==24.3.0' \
      --replace-warn 'service-identity==21.1.0' 'service-identity==24.1.0' \
      --replace-warn 'cryptography==41.0.6' 'cryptography==42.0.5'
  '';

  # Has no tests
  doCheck = false;

  pythonImportsCheck = [
    "jmbase"
  ];

  meta = with lib; {
    homepage = "https://github.com/Joinmarket-Org/joinmarket-clientserver";
    maintainers = with maintainers; [ seberm ];
    license = licenses.gpl3;
  };
}
