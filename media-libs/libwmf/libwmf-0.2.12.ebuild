# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2-utils

DESCRIPTION="Library for reading vector images in Microsoft's Windows Metafile Format (WMF)"
HOMEPAGE="https://github.com/caolanm/libwmf"
SRC_URI="https://github.com/caolanm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc expat X"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	app-text/ghostscript-gpl
	media-fonts/urw-fonts
	media-libs/freetype:2=
	media-libs/libpng:0=
	sys-libs/zlib:=
	x11-libs/gdk-pixbuf:2[X?]
	virtual/jpeg:0=
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2:2= )
	X? (
		x11-libs/libX11
		x11-libs/libXpm
		x11-libs/libXt
	)
"
DEPEND="${RDEPEND}"

DOCS=( "AUTHORS" "BUILDING" "ChangeLog" "CREDITS" "INSTALL" "NEWS" "README" "TODO" )

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.8.4-build.patch
	"${FILESDIR}"/${P}-gdk-pixbuf.patch
	"${FILESDIR}"/${PN}-0.2.8.4-libpng-1.5.patch
	"${FILESDIR}"/${PN}-0.2.8.4-pngfix.patch
	"${FILESDIR}"/${PN}-0.2.8.4-use-freetype2-pkg-config.patch
	"${FILESDIR}"/${P}-use-system-fonts.patch
	"${FILESDIR}"/${P}-nullptr-crashfix.patch
)

src_prepare() {
	default

	if ! use doc ; then
		sed -i -e 's:doc::' Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	# Support for GD is disabled, since it's never linked, even, when enabled
	# See https://bugs.gentoo.org/268161
	local myeconfargs=(
		--disable-gd
		--disable-static
		$(use_enable debug)
		$(use_with expat)
		$(use_with !expat libxml2)
		$(use_with X x)
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
		--with-fontdir="${EPREFIX}"/usr/share/fonts/urw-fonts
		--with-freetype
		--with-gsfontdir="${EPREFIX}"/usr/share/fonts/urw-fonts
		--with-gsfontmap="${EPREFIX}"/usr/share/ghostscript/9.21/Resource/Init/Fontmap
		--with-jpeg
		--with-layers
		--with-png
		--with-sys-gd
		--with-zlib
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	# address parallel build issue, bug 677566
	MAKEOPTS=-j1

	default
}

pkg_preinst() {
	gnome2_gdk_pixbuf_savelist
}

pkg_postinst() {
	gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	gnome2_gdk_pixbuf_update
}
