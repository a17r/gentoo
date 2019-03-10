# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit autotools multilib-minimal python-single-r1

DESCRIPTION="LASH Audio Session Handler"
HOMEPAGE="http://www.nongnu.org/lash/"
SRC_URI="mirror://nongnu/${PN}/${P/_/~}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa debug gtk libedit python static-libs" # doc

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# doc? ( >=app-text/texi2html-5 )
BDEPEND="
	virtual/pkgconfig
	python? ( >=dev-lang/swig-1.3.40 )
"
DEPEND="
	dev-libs/libxml2
	>=sys-apps/util-linux-2.24.1-r3[${MULTILIB_USEDEP}]
	virtual/jack
	alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:2 )
	!libedit? ( sys-libs/readline:0= )
	libedit? ( dev-libs/libedit )
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

S="${WORKDIR}/${PN}-0.6.0.594"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	sed -i \
		-e '/texi2html/s:-number:&-sections:' \
		docs/Makefile.am || die #422045

# 	epatch \
# 		"${FILESDIR}"/${P}-glibc2.8.patch \
# 		"${FILESDIR}"/${P}-swig_version_comparison.patch \
# 		"${FILESDIR}"/${P}-gcc47.patch \
# 		"${FILESDIR}"/${P}-underlinking.patch \
# 		"${FILESDIR}"/${P}-strcmp.patch

	AT_M4DIR=m4 eautoreconf
}

multilib_src_configure() {
	# 'no' could be '$(usex doc)' but we use the pregenerated lash-manual.html
	export ac_cv_prog_lash_texi2html=no #422045

	local myconf=(
		$(use_enable static-libs static)
		$(multilib_native_use_enable alsa alsa-midi)
		$(multilib_native_use_enable gtk gtk2)
		$(multilib_native_use_enable debug)
	)
	# --enable-pylash would disable it
	if ! multilib_is_native_abi || ! use python; then
		myconf+=( --disable-pylash )
	fi

	if ! multilib_is_native_abi; then
		# disable remaining configure checks
		myconf+=(
			JACK_CFLAGS=' '
			JACK_LIBS=' '
			XML2_CFLAGS=' '
			XML2_LIBS=' '

			vl_cv_lib_readline=no
		)
	fi

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		emake -C liblash
	fi
}

multilib_src_test() {
	multilib_is_native_abi && default
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install
	else
		# headers
		emake -C lash DESTDIR="${D}" install
		# library
		emake -C liblash DESTDIR="${D}" install
		# pkg-config
		emake DESTDIR="${D}" install-pkgconfigDATA
	fi
}

multilib_src_install_all() {
	dohtml docs/lash-manual-html-*/lash-manual.html
	find "${D}" -name '*.la' -type f -delete || die
	use python && python_optimize
}
