#!/usr/bin/env bash
set -o errexit \
    -o nounset \
    -o pipefail

if [ -z ${CACHIX_AUTH_TOKEN+x} ]; then
    echo "Please set the CACHIX_AUTH_TOKEN"
    exit 1
fi;

# Build for Apple M1 architecture (arm64)
nix build -f '<nixpkgs>' --arg config "{ allowUnfree = true; }" --argstr system "arm64-darwin" --print-build-logs --print-out-paths

VERSION=$(result/bin/glualint --version)
echo "Packing glualint version $VERSION"

cp result/bin/glualint .

zip "glualint-$VERSION-arm64-darwin.zip" glualint

rm -f glualint
cachix push glualint "$(readlink result)"
