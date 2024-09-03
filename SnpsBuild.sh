source /global/etc/sh.bashrc

module purge

# QSC-S
#module load binutils/2.33.1
module load gcc/9.2.0
#module load gcc/12.3.0
module load gmake/4.2
module load cmake/3.22.3
module load git/2.30.0

GCC="gcc"; export GCC
CC="gcc"; export CC

git submodule update

OPENSSL="/remote/sdg_sv_vsa/janick/openssl-3.0.9"

rm -rf build
mkdir build
( cd build \
      && cmake -DARCH=x64 -DTOOLCHAIN=GCC -DTARGET=Debug -DDISABLE_TESTS=1 \
               -DCRYPTO=openssl -DENABLE_BINARY_BUILD=1 -DDISABLE_EDDSA=1 -DCOMPILED_LIBCRYPTO_PATH=${OPENSSL}/lib64/libcrypto.so -DCOMPILED_LIBSSL_PATH=${OPENSSL}/lib64/libssl.so \
               .. \
      && make )

echo "Building liblibspdm.so..."
( mkdir build/objs \
      && cd build/objs \
      && ar x ../lib/libspdm_common_lib.a \
      && ar x ../lib/libspdm_transport_pcidoe_lib.a \
      && ar x ../lib/libspdm_requester_lib.a \
      && ar x ../lib/libspdm_responder_lib.a \
      && ar x ../lib/libspdm_secured_message_lib.a \
      && ar x ../lib/libspdm_crypt_lib.a \
      && ar x ../lib/libcryptlib_openssl.a \
      && ar x ../lib/libspdm_device_secret_lib_snps.a \
      && ar x ../lib/libdebuglib.a \
      && ar x ../lib/libplatform_lib_null.a \
      && ar x ../lib/libmalloclib.a \
      && ar x ../lib/libmemlib.a \
      && gcc -o ../lib/liblibspdm.so -shared *.o -L${OPENSSL}/lib64 -lcrypto -lssl )
