source /global/etc/sh.bashrc

module purge

# QSC-S
#module load binutils/2.33.1
module load gcc/9.2.0
module load gmake/4.2
module load cmake/3.22.3
module load git/2.30.0

GCC="gcc"; export GCC
CC="gcc"; export CC

OPENSSL="/remote/sdg_sv_vsa/janick/openssl-3.0.9"

( cd build \
      && make )

echo "Building liblibspdm.so..."
( cd build/objs \
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
