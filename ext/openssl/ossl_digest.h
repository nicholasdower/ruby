/*
 * 'OpenSSL for Ruby' project
 * Copyright (C) 2001-2002  Michal Rokos <m.rokos@sh.cvut.cz>
 * All rights reserved.
 */
/*
 * This program is licensed under the same licence as Ruby.
 * (See the file 'COPYING'.)
 */
#if !defined(_OSSL_DIGEST_H_)
#define _OSSL_DIGEST_H_

const EVP_MD *ossl_evp_get_digestbyname(VALUE);
VALUE ossl_digest_new(const EVP_MD *);
void Init_ossl_digest(void);

#endif /* _OSSL_DIGEST_H_ */
