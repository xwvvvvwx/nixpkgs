{ lib
, buildPythonPackage
, fetchPypi
, six
, statistics
, pythonOlder
, nose
, psutil
, contextlib2
, mock
, unittest2
, isPy27
, python
}:

buildPythonPackage rec {
  pname = "pyperf";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c37690e810116a83a244dfeec47885e2f0475b4c450313904be3bc2cdaf6d50a";
  };

  checkInputs = [ nose psutil ] ++
    lib.optionals isPy27 [ contextlib2 mock unittest2 ];
  propagatedBuildInputs = [ six ] ++
    lib.optionals (pythonOlder "3.4") [ statistics ];

  # tests not included in pypi repository
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} -m nose
  '';

  meta = with lib; {
    description = "Python module to generate and modify perf";
    homepage = "https://pyperf.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
