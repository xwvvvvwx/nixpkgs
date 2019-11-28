{ stdenv, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "git-remote-s3";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "bgahagan";
    repo = "git-remote-s3";
    rev = "v${version}";
    sha256 = "1xmp878vwvgcdwjh1v0klfykj9l1s3shqmrl78kigw7lbmm9wkyk";
  };

  cargoSha256 = "0q68qyl2h6i0qsz82z840myxlnjay8p1w5z7hfyr8fqp7wgwa9cx";

  meta = with stdenv.lib; {
    description = "Push and pull git repos to/from an s3 bucket. Uses gpg to encrypt the repo contents.";
    homepage = https://github.com/bgahagan/git-remote-s3;
    license = licenses.mit;
    maintainers = [ maintainers.xwvvvvwx ];
    platforms = platforms.linux;
  };
}
