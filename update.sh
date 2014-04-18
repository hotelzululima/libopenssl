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
	crypto/aes/aes.h \
	crypto/modes/modes.h \
	crypto/asn1/asn1t.h \
	crypto/dso/dso.h \
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

(cd include
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
)

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

(cd ssl
	cp Makefile.am.tpl Makefile.am
	for i in *.c; do
		echo "libssl_la_SOURCES += $i" >> Makefile.am
	done
)

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

(cd crypto
	cp Makefile.am.tpl Makefile.am
	for i in *.c; do
		echo "libcrypto_la_SOURCES += $i" >> Makefile.am
	done
)

mkdir -p crypto/aes
for i in aes_misc.c aes_ecb.c aes_cfb.c aes_ofb.c \
	aes_ctr.c aes_ige.c aes_wrap.c aes_locl.h;
do
	cp openbsd-src/lib/libssl/src/crypto/aes/${i} crypto/aes
done

mkdir -p crypto/asn1
for i in a_object.c a_bitstr.c a_utctm.c a_gentm.c a_time.c a_int.c a_octet.c \
	a_print.c a_type.c a_dup.c a_d2i_fp.c a_i2d_fp.c \
	a_enum.c a_utf8.c a_sign.c a_digest.c a_verify.c a_mbstr.c a_strex.c \
	x_algor.c x_val.c x_pubkey.c x_sig.c x_req.c x_attrib.c x_bignum.c \
	x_long.c x_name.c x_x509.c x_x509a.c x_crl.c x_info.c x_spki.c nsseq.c \
	x_nx509.c d2i_pu.c d2i_pr.c i2d_pu.c i2d_pr.c \
	t_req.c t_x509.c t_x509a.c t_crl.c t_pkey.c t_spki.c t_bitst.c \
	tasn_new.c tasn_fre.c tasn_enc.c tasn_dec.c tasn_utl.c tasn_typ.c \
	tasn_prn.c ameth_lib.c \
	f_int.c f_string.c n_pkey.c \
	f_enum.c x_pkey.c a_bool.c x_exten.c bio_asn1.c bio_ndef.c asn_mime.c \
	asn1_gen.c asn1_par.c asn1_lib.c asn1_err.c a_bytes.c a_strnid.c \
	evp_asn1.c asn_pack.c p5_pbe.c p5_pbev2.c p8_pkey.c asn_moid.c \
	asn1_locl.h charmap.h;
do
	cp openbsd-src/lib/libssl/src/crypto/asn1/${i} crypto/asn1
done

(cd crypto
	for subdir in aes asn1; do
		for i in $subdir/*.c; do
			echo "libcrypto_la_SOURCES += $i" >> Makefile.am
		done
	done
)
