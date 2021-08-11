#!/bin/bash
set -e -x

# Install a system package required by our library
yum install -y cmake make bzip2-devel libxml2-devel zchunk-devel zlib-devel xz-devel libcurl-devel

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" --plat $PLAT -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/*/bin/; do
    "${PYBIN}/pip" install libcomps --no-index -f /io/wheelhouse
done
