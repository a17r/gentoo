# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple Event Correlator"
HOMEPAGE="https://simple-evcorr.github.io/ https://github.com/simple-evcorr/sec"
SRC_URI="https://github.com/simple-evcorr/sec/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux"

RDEPEND="
	>=dev-lang/perl-5.8.0
	virtual/perl-JSON-PP
"

src_install() {
	dobin sec

	dodoc ChangeLog README
	docinto contrib
	dodoc contrib/{itostream.c,convert.pl,swatch2sec.pl}

	newman sec.man sec.1

	newinitd "${FILESDIR}"/sec.init.d sec
	newconfd "${FILESDIR}"/sec.conf.d sec
}
