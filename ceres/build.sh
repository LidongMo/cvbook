#!/bin/bash

THIS_DIR="$(dirname "${0}")"
cd ${THIS_DIR}
./download-prerequisites.sh

mkdir -p install

mkdir -p build/eigen
cd build/eigen
cmake ../../eigen -DCMAKE_INSTALL_PREFIX=${PWD}/../../install
make install
cd ../..

mkdir -p build/gflags
cd build/gflags
if ! [ -f config.status ]; then
  ../../gflags/configure --prefix=${PWD}/../../install
fi
make -j10
make install
cd ../..

mkdir -p build/glog
cd build/glog
if ! [ -f config.status ]; then
  ../../glog/configure --with-gflags=${PWD}/../../install \
                       --prefix=${PWD}/../../install
fi
make -j10
make install
cd ../..

mkdir -p build/protobuf
cd build/protobuf
if ! [ -f config.status ]; then
  ../../protobuf/configure --prefix=${PWD}/../../install
fi
make -j10
make install
cd ../..

cd suitesparse
cp SuiteSparse_config/SuiteSparse_config_Mac.mk \
   SuiteSparse_config/SuiteSparse_config.mk
make
make install INSTALL_LIB=${PWD}/../install/lib \
             INSTALL_INCLUDE=${PWD}/../install/include
cd ..

# This is only needed for goto2blas:
# FIXME: need gfortran from http://cran.r-project.org/bin/macosx/tools/
# goto2blas needs
# . s/wget/curl -O/
# . fixed md5 check
# . `make netlib MD5SUM=md5`
# . `make blas`  # has assembler errors

