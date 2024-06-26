# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple ncurses bandwidth monitor"
HOMEPAGE="https://bwmon.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

BDEPEND="virtual/pkgconfig"
RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

SLOT="0"
LICENSE="GPL-2 public-domain"
KEYWORDS="amd64 ~hppa ppc sparc x86"

PATCHES=(
		"${FILESDIR}"/${P}-build.patch
		"${FILESDIR}"/${P}-typo-fix.patch
		"${FILESDIR}"/${P}-overflow.patch
		"${FILESDIR}"/${P}-tinfo.patch
)

src_compile() {
	emake -C src CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	dobin ${PN}
	dodoc README
}
