# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils optfeature xdg-utils

DESCRIPTION="Tool for extracting unformatted bibliographic references"
HOMEPAGE="https://www.molspaces.com/cb2bib/"
SRC_URI="https://www.molspaces.com/dl/progs/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lz4 +lzo zlib"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	lz4? ( app-arch/lz4:= )
	lzo? ( dev-libs/lzo:2 )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CHANGELOG COPYRIGHT )

PATCHES=( "${FILESDIR}/${P}-buildsystem.patch" )

src_configure() {
	eqmake5 \
		$(use lz4 && echo -config use_lz4) \
		$(use lzo && echo -config use_lzo) \
		$(use zlib && echo -config use_qt_zlib)
}

src_compile() {
	# bug #709940
	emake -j1
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	elog "For best functionality, emerge the following packages:"
	optfeature "PDF file data import" "app-text/poppler[utils]"
	optfeature "DVI file data import" "app-text/dvipdfm"
	optfeature "ISI data import, endnote format" "app-text/bibutils"
	optfeature "display mathematical notation" "media-fonts/jsmath"
	optfeature "proper UTF-8 metadata writing in PDF text strings" "media-libs/exiftool"
	optfeature "BibTeX file checks and nice printing via \`bib2pdf\` shell script" "virtual/latex-base"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
