#!/usr/bin/env bash
# Build and publish a new drain3 release to PyPI.
#
# setup.py was removed when the build migrated to poetry-core (see
# "Migrate CI and build tools"), so the package is built from
# pyproject.toml via `poetry build`. Prerequisites: poetry, twine.
set -euo pipefail

command -v poetry >/dev/null 2>&1 || { echo "error: poetry is required (pip install poetry)" >&2; exit 1; }
command -v twine  >/dev/null 2>&1 || { echo "error: twine is required (pip install twine)" >&2; exit 1; }

# Never upload stale artifacts left over from previous releases.
rm -rf dist

poetry build

# Fail early on malformed metadata instead of after upload.
twine check dist/*

VERSION="$(poetry version --short)"
twine upload "dist/drain3-${VERSION}.py3-none-any.whl" "dist/drain3-${VERSION}.tar.gz"
