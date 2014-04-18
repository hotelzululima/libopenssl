#!/bin/bash

# resync this library with the upstream project

#git clone --depth 1 https://bitbucket.org/braindamaged/openbsd-src.git

cp openbsd-src/lib/libssl/src/LICENSE COPYING
cp openbsd-src/lib/libssl/src/ACKNOWLEDGMENTS AUTHORS
cp openbsd-src/lib/libssl/src/CHANGES ChangeLog

for i in e_os2.h \
	ssl/srtp.h \
	ssl/ssl.h  \
	ssl/ssl2.h \
	ssl/ssl3.h \
	ssl/ssl23.h \
	ssl/tls1.h \
	ssl/dtls1.h \
	ssl/kssl.h \
	crypto/stack/stack.h \
	crypto/lhash/lhash.h \
	crypto/stack/safestack.h \
	crypto/opensslv.h \
	crypto/ossl_typ.h \
	crypto/err/err.h \
	crypto/crypto.h \
	crypto/comp/comp.h \
	crypto/x509/x509.h \
	crypto/buffer/buffer.h \
	crypto/evp/evp.h \
	crypto/objects/objects.h \
	crypto/asn1/asn1.h \
	crypto/bn/bn.h \
	crypto/ec/ec.h \
	crypto/ecdsa/ecdsa.h \
	crypto/ecdh/ecdh.h \
	crypto/rsa/rsa.h \
	crypto/sha/sha.h \
	crypto/x509/x509_vfy.h \
	crypto/pkcs7/pkcs7.h \
	crypto/pem/pem.h \
	crypto/pem/pem2.h \
	crypto/hmac/hmac.h \
	crypto/pqueue/pqueue.h \
	crypto/rand/rand.h \
	crypto/md5/md5.h \
	crypto/krb5/krb5_asn.h \
	crypto/asn1/asn1_mac.h \
	crypto/x509v3/x509v3.h \
	crypto/conf/conf.h \
	crypto/ocsp/ocsp.h \
	crypto/srp/srp.h \
	crypto/bio/bio.h ; do
	cp openbsd-src/lib/libssl/src/$i include/openssl
done

sed -ie 's/__attribute__((__bounded__.*;/;/' include/openssl/bio.h

mkdir -p crypto/ec
cp ./openbsd-src/lib/libssl/src/crypto/ec/ec_lcl.h crypto/ec/

for i in ssl/srtp.h \
	ssl/kssl_lcl.h \
	ssl/ssl_locl.h; do
	cp openbsd-src/lib/libssl/src/$i ssl
done

pushd include
	cp openssl.h.tpl openssl.h
	for i in openssl/*.h; do
		echo "#include <$i>" >> openssl.h;
	done
	pushd openssl
		cp Makefile.am.tpl Makefile.am
		for i in *.h; do
			echo "opensslinclude_HEADERS += $i" >> Makefile.am
		done
	popd
popd

for i in s3_meth.c s3_srvr.c s3_clnt.c s3_lib.c s3_enc.c s3_pkt.c s3_both.c \
		s23_meth.c s23_srvr.c s23_clnt.c s23_lib.c s23_pkt.c \
		t1_meth.c t1_srvr.c t1_clnt.c t1_lib.c t1_enc.c \
		d1_meth.c d1_srvr.c d1_clnt.c d1_lib.c d1_pkt.c \
		d1_both.c d1_enc.c d1_srtp.c \
		ssl_lib.c ssl_err2.c ssl_cert.c ssl_sess.c \
		ssl_ciph.c ssl_stat.c ssl_rsa.c \
		ssl_asn1.c ssl_txt.c ssl_algs.c \
		bio_ssl.c ssl_err.c kssl.c tls_srp.c t1_reneg.c	s3_cbc.c;
do
	cp openbsd-src/lib/libssl/src/ssl/$i ssl/
done

pushd ssl
	cp Makefile.am.tpl Makefile.am
	for i in *.c; do
		echo "libssl_la_SOURCES += $i" >> Makefile.am
	done
popd

for i in crypto/cryptlib.h \
	crypto/cryptlib.c \
	crypto/malloc-wrapper.c \
	crypto/mem_dbg.c \
	crypto/cversion.c \
	crypto/ex_data.c \
	crypto/cpt_err.c \
	crypto/uid.c \
	crypto/o_time.c \
	crypto/o_time.h \
	crypto/o_str.c \
	crypto/o_str.h \
	crypto/o_fips.c \
	e_os.h \
	crypto/o_init.c;
do
	cp openbsd-src/lib/libssl/src/$i crypto
done

pushd crypto
	cp Makefile.am.tpl Makefile.am
	for i in *.c; do
		echo "libcrypto_la_SOURCES += $i" >> Makefile.am
	done
popd
