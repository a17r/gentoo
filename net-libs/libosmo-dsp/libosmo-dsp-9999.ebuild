# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library with SDR DSP primitives"
HOMEPAGE="https://gitea.osmocom.org/sdr/libosmo-dsp/"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.osmocom.org/${PN}"
else
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="doc static-libs"

RDEPEND="sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-text/doxygen )
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use doc || export ac_cv_path_DOXYGEN=false
	default_src_configure
}

src_install() {
	default_src_install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/libosmodsp.a
	use static-libs || rm "${ED}"/usr/$(get_libdir)/libosmodsp.la
}
