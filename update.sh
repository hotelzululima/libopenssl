#!/bin/bash

# resync this library with the upstream project

#git clone --depth 1 https://bitbucket.org/braindamaged/openbsd-src.git

copy_src() {
	mkdir -p $1
	for file in $2; do
		cp openbsd-src/lib/libssl/src/$1/$file $1
	done
}

copy_hdrs() {
	for file in $2; do
		cp openbsd-src/lib/libssl/src/$1/$file include/openssl
	done
}

cp openbsd-src/lib/libssl/src/LICENSE COPYING
cp openbsd-src/lib/libssl/src/ACKNOWLEDGMENTS AUTHORS
cp openbsd-src/lib/libssl/src/CHANGES ChangeLog

cp openbsd-src/lib/libssl/src/e_os.h crypto
cp openbsd-src/lib/libssl/src/e_os2.h include/openssl

copy_hdrs crypto "stack/stack.h lhash/lhash.h stack/safestack.h opensslv.h
	ossl_typ.h err/err.h crypto.h comp/comp.h x509/x509.h buffer/buffer.h
	evp/evp.h objects/objects.h asn1/asn1.h bn/bn.h ec/ec.h ecdsa/ecdsa.h
	ecdh/ecdh.h rsa/rsa.h sha/sha.h x509/x509_vfy.h pkcs7/pkcs7.h pem/pem.h
	pem/pem2.h hmac/hmac.h pqueue/pqueue.h rand/rand.h md5/md5.h
	krb5/krb5_asn.h asn1/asn1_mac.h x509v3/x509v3.h conf/conf.h ocsp/ocsp.h
	srp/srp.h aes/aes.h modes/modes.h asn1/asn1t.h dso/dso.h bf/blowfish.h
	bio/bio.h cast/cast.h cmac/cmac.h"

copy_hdrs ssl "srtp.h ssl.h ssl2.h ssl3.h ssl23.h tls1.h dtls1.h kssl.h"

sed -ie 's/__attribute__((__bounded__.*;/;/' include/openssl/bio.h

mkdir -p crypto/ec
cp ./openbsd-src/lib/libssl/src/crypto/ec/ec_lcl.h crypto/ec/

for i in ssl/srtp.h \
	ssl/kssl_lcl.h \
	ssl/ssl_locl.h; do
	cp openbsd-src/lib/libssl/src/$i ssl
done

copy_src ssl "s3_meth.c s3_srvr.c s3_clnt.c s3_lib.c s3_enc.c s3_pkt.c
	s3_both.c s23_meth.c s23_srvr.c s23_clnt.c s23_lib.c s23_pkt.c t1_meth.c
	t1_srvr.c t1_clnt.c t1_lib.c t1_enc.c d1_meth.c d1_srvr.c d1_clnt.c
	d1_lib.c d1_pkt.c d1_both.c d1_enc.c d1_srtp.c ssl_lib.c ssl_err2.c
	ssl_cert.c ssl_sess.c ssl_ciph.c ssl_stat.c ssl_rsa.c ssl_asn1.c ssl_txt.c
	ssl_algs.c bio_ssl.c ssl_err.c kssl.c tls_srp.c t1_reneg.c s3_cbc.c"

copy_src crypto "cryptlib.h cryptlib.c malloc-wrapper.c mem_dbg.c cversion.c
	ex_data.c cpt_err.c uid.c o_time.c o_time.h o_str.c o_str.h o_fips.c
	o_init.c"

copy_src crypto/aes "aes_misc.c aes_ecb.c aes_cfb.c aes_ofb.c aes_ctr.c
	aes_ige.c aes_wrap.c aes_locl.h"

copy_src crypto/asn1 "a_object.c a_bitstr.c a_utctm.c a_gentm.c a_time.c
	a_int.c a_octet.c a_print.c a_type.c a_dup.c a_d2i_fp.c a_i2d_fp.c a_enum.c
	a_utf8.c a_sign.c a_digest.c a_verify.c a_mbstr.c a_strex.c x_algor.c
	x_val.c x_pubkey.c x_sig.c x_req.c x_attrib.c x_bignum.c x_long.c x_name.c
	x_x509.c x_x509a.c x_crl.c x_info.c x_spki.c nsseq.c x_nx509.c d2i_pu.c
	d2i_pr.c i2d_pu.c i2d_pr.c t_req.c t_x509.c t_x509a.c t_crl.c t_pkey.c
	t_spki.c t_bitst.c tasn_new.c tasn_fre.c tasn_enc.c tasn_dec.c tasn_utl.c
	tasn_typ.c tasn_prn.c ameth_lib.c f_int.c f_string.c n_pkey.c f_enum.c
	x_pkey.c a_bool.c x_exten.c bio_asn1.c bio_ndef.c asn_mime.c asn1_gen.c
	asn1_par.c asn1_lib.c asn1_err.c a_bytes.c a_strnid.c evp_asn1.c asn_pack.c
	p5_pbe.c p5_pbev2.c p8_pkey.c asn_moid.c asn1_locl.h charmap.h"

copy_src crypto/bf "bf_skey.c bf_ecb.c bf_cfb64.c bf_ofb64.c bf_locl.h bf_pi.h"

copy_src crypto/bio "bio_lib.c bio_cb.c bio_err.c bss_mem.c bss_null.c bss_fd.c
	bss_file.c bss_sock.c bss_conn.c bf_null.c bf_buff.c b_print.c b_dump.c
	b_sock.c bss_acpt.c bf_nbio.c bss_log.c bss_bio.c bss_dgram.c"

copy_src crypto/bn "bn_add.c bn_div.c bn_exp.c bn_lib.c bn_ctx.c bn_mul.c
	bn_mod.c bn_print.c bn_rand.c bn_shift.c bn_word.c bn_blind.c bn_kron.c
	bn_sqrt.c bn_gcd.c bn_prime.c bn_err.c bn_sqr.c bn_recp.c bn_mont.c
	bn_mpi.c bn_exp2.c bn_gf2m.c bn_nist.c bn_depr.c bn_const.c bn_x931p.c
	bn_lcl.h bn_prime.h"

copy_src crypto/buffer "buffer.c buf_err.c buf_str.c"

copy_src crypto/cast "c_skey.c c_ecb.c c_enc.c c_cfb64.c c_ofb64.c cast_lcl.h cast_s.h"

copy_src crypto/cmac "cmac.c cm_ameth.c cm_pmeth.c"

copy_src crypto/comp "comp_lib.c comp_err.c c_rle.c c_zlib.c"

(cd include/openssl
	cp Makefile.am.tpl Makefile.am
	for i in *.h; do
		echo "opensslinclude_HEADERS += $i" >> Makefile.am
	done
)

(cd ssl
	cp Makefile.am.tpl Makefile.am
	for i in *.c; do
		echo "libssl_la_SOURCES += $i" >> Makefile.am
	done
)

(cd crypto
	cp Makefile.am.tpl Makefile.am
	for i in *.c; do
		echo "libcrypto_la_SOURCES += $i" >> Makefile.am
	done
	for subdir in aes asn1 bf bio bn buffer cast comp; do
		for i in $subdir/*.c; do
			echo "libcrypto_la_SOURCES += $i" >> Makefile.am
		done
	done
)
