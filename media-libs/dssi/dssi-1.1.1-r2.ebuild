# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Plugin API for software instruments with user interfaces"
HOMEPAGE="http://dssi.sourceforge.net/"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="qt5"

RDEPEND="
	media-libs/alsa-lib
	>=media-libs/ladspa-sdk-1.12-r2
	>=media-libs/liblo-0.12
	>=media-libs/libsamplerate-0.1.1-r1
	>=media-libs/libsndfile-1.0.11
	virtual/jack
	qt5? ( dev-qt/qtgui:5 )"
DEPEND="${RDEPEND}
	sys-apps/sed
	virtual/pkgconfig"

DOCS=( README doc/TODO doc/{midi-controllers,RFC,why-use}.txt )

PATCHES=( "${FILESDIR}"/${P}-qt5.patch )

src_prepare() {
	default

	sed -i \
		-e 's:libdir=.*:libdir=@libdir@:' \
		dssi.pc.in || die

	if ! use qt5; then
		sed -i -e '/PKG_CHECK_MODULES(QT/s:QtGui:dIsAbLe&:' configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11 -fPIC

	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	einstalldocs
	find "${D}" -name '*.la' -delete
}
