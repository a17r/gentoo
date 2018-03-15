# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

REV=312
inherit desktop qmake-utils

MY_PN="${PN/-/}"
DESCRIPTION="A program to generate 3D structures by specifying a design grammar"
HOMEPAGE="https://structuresynth.sourceforge.net/"
SRC_URI="https://sourceforge.net/code-snapshots/svn/s/st/${MY_PN}/code/${MY_PN}-code-${REV}-trunk.zip -> ${P}.zip"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtscript:5
	virtual/opengl
"
DEPEND="${RDEPEND}
	app-arch/unzip
	app-text/dos2unix
"

PATCHES=( "${FILESDIR}/${P}-qmake.patch" )

S="${WORKDIR}/${MY_PN}-code-${REV}-trunk"

src_prepare() {
	dos2unix -- StructureSynth.pro || die "Failed to sanitise StructureSynth.pro"
	default
}

src_configure() {
	eqmake5 StructureSynth.pro
}

src_install() {
	dobin ${PN}
	dodoc roadmap.txt changelog.txt bugs.txt
	domenu ${PN}.desktop
	newicon images/structuresynth.png ${PN}.png
}
