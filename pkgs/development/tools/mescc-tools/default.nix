{ stdenv, lib }:
stdenv.mkDerivation {
  pname = "mescc-tools";
  version = "0.6.1";
  makeFlags = [ "PREFIX=$(out)" ];
  src = fetchGit {
    url = "https://github.com/oriansj/mescc-tools.git";
    ref = "refs/tags/Release_0.6.1";
    rev = "47df414d2182211f8143816da54438c4a2a2bfc1";
  };
}
