# Copyright 2001-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="HTTP and WebDAV client library"
HOMEPAGE="https://notroj.github.io/neon/ https://github.com/notroj/neon"
SRC_URI="https://notroj.github.io/neon/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+" # manpages+tests, core project
SLOT="0/27"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+expat gnutls kerberos libproxy nls pkcs11 ssl test zlib"
RESTRICT="!test? ( test )"

DEPEND="
	expat? ( dev-libs/expat:0=[${MULTILIB_USEDEP}] )
	!expat? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	kerberos? ( virtual/krb5:0=[${MULTILIB_USEDEP}] )
	libproxy? ( net-libs/libproxy:0=[${MULTILIB_USEDEP}] )
	nls? ( virtual/libintl:0=[${MULTILIB_USEDEP}] )
	ssl? (
		gnutls? (
			app-misc/ca-certificates
			net-libs/gnutls:0=[${MULTILIB_USEDEP}]
		)
		!gnutls? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		pkcs11? ( dev-libs/pakchois:0=[${MULTILIB_USEDEP}] )
	)
	zlib? ( sys-libs/zlib:0=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		ssl? (
			dev-libs/openssl:0
			pkcs11? ( dev-libs/nss )
		)
	)
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/neon-config
)

DOCS=( AUTHORS BUGS NEWS README.md THANKS TODO )
HTML_DOCS=( doc/html/. )

src_prepare() {
	if use gnutls; then
		# Ignore failure of test pkcs11.
		# https://github.com/notroj/neon/issues/72
		sed -e "s/T(pkcs11)/T_XFAIL(pkcs11)/" -i test/ssl.c || die
	fi

	default

	AT_M4DIR="macros" eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable nls)
		$(use_with expat)
		$(use_with kerberos gssapi)
		$(use_with libproxy)
		$(use_with pkcs11 pakchois)
		$(use_with zlib)
	)
	use expat || myeconfargs+=( --with-libxml2 ) # add libxml if expat is not used

	if has_version sys-libs/glibc; then
		einfo "Enabling SSL library thread-safety using POSIX threads..."
		myeconfargs+=( --enable-threadsafe-ssl=posix )
	fi

	if use ssl; then
		if use gnutls; then
			myeconfargs+=(
				--with-ssl=gnutls
				--with-ca-bundle="${EPREFIX}/etc/ssl/certs/ca-certificates.crt"
			)
		else
			myeconfargs+=( --with-ssl=openssl )
		fi
	fi

	econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install-{config,headers,lib,man,nls}
}

multilib_src_install_all() {
	find "${ED}" -name "*.la" -delete || die

	einstalldocs
}
