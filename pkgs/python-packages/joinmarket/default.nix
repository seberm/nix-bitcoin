{ version
, src
, lib
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, pytestCheckHook
, setuptools
, fetchurl
, chromalog
, cryptography
, service-identity
, twisted
, txtorcon
, python-bitcointx
, argon2_cffi
, autobahn
, bencoderpyx
, klein
, mnemonic
, pyjwt
, werkzeug
, libnacl
, pyopenssl
}:

buildPythonPackage rec {
  pname = "joinmarket";
  inherit version src;
  format = "pyproject";

  # Since v0.9.11, Python older than v3.8 is not supported. Python v3.12 is
  # still not supported.
  disabled = (pythonOlder "3.8") || (pythonAtLeast "3.12");

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    # base jm packages
    chromalog
    cryptography
    service-identity
    twisted
    txtorcon

    # jmbitcoin
    python-bitcointx

    # jmclient
    argon2_cffi
    autobahn
    bencoderpyx
    klein
    mnemonic
    pyjwt
    werkzeug

    # jmdaemon
    libnacl
    pyopenssl
  ];

  # TODO-EXTERNAL:
  # Remove this when fixed upstream.
  #
  # Fix the following error:
  #   File "/nix/store/...-python3.11-pytest-8.1.1/lib/python3.11/site-packages/_pytest/config/argparsing.py", line 133, in _getparser
  #     arggroup.add_argument(*n, **a)
  #   File "/nix/store/...-python3-3.11.9/lib/python3.11/argparse.py", line 1460, in add_argument
  #     raise ValueError('%r is not callable' % (type_func,))
  #   ValueError: 'int' is not callable
  patches = [ ./fix-conftest-arg-type-error.patch ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'txtorcon==23.11.0' 'txtorcon==23.11.0' \
      --replace-fail 'twisted==23.10.0' 'twisted==24.3.0' \
      --replace-fail 'service-identity==21.1.0' 'service-identity==24.1.0' \
      --replace-fail 'cryptography==41.0.6' 'cryptography==42.0.5'

    # Modify pyproject.toml to include only specific modules. Do not include 'jmqtui'.
    sed -i '/^\[tool.setuptools.packages.find\]/a include = ["jmbase", "jmbitcoin", "jmclient", "jmdaemon"]' pyproject.toml
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test/jmbase/"
    "test/jmbitcoin/"
    "test/jmdaemon/test_enc_wrapper.py"

    # Other tests require preconfigured bitcoind and miniircd
    # https://github.com/JoinMarket-Org/joinmarket-clientserver/blob/master/docs/TESTING.md
    # "test/jmclient/"
    # "test/jmdaemon/"
  ];

  pythonImportsCheck = [
    "jmbase"
    "jmbitcoin"
    "jmclient"
    "jmdaemon"
  ];

  meta = with lib; {
    homepage = "https://github.com/Joinmarket-Org/joinmarket-clientserver";
    maintainers = with maintainers; [ seberm nixbitcoin ];
    license = licenses.gpl3;
  };
}
