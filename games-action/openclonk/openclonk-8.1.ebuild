# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit cmake-utils gnome2-utils python-any-r1 xdg-utils toolchain-funcs

MY_P=${PN}-release-${PV}-src

DESCRIPTION="A free multiplayer action game where you control clonks"
HOMEPAGE="https://openclonk.org/"
SRC_URI="https://www.openclonk.org/builds/release/${PV}/openclonk-${PV}-src.tar.bz2"

LICENSE="BSD ISC CLONK-trademark LGPL-2.1 POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client server editor doc"
REQUIRED_USE="
	|| ( client server )
	editor? ( client )
"

RDEPEND="
	dev-libs/tinyxml
	net-libs/libupnp:=
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/jpeg:0
	client? (
		dev-libs/glib:2
		media-libs/freealut
		media-libs/freetype:2
		media-libs/glew:=
		media-libs/libsdl2[X,opengl,sound,video]
		media-libs/libvorbis
		media-libs/openal
		media-libs/sdl2-mixer[mp3,vorbis,wav]
		virtual/opengl
		virtual/glu
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:3
		x11-libs/libXrandr
		x11-libs/libX11
	)
	editor? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	server? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		${PYTHON_DEPS}
		dev-libs/libxml2[python]
		sys-devel/gettext
	)
"

S=${WORKDIR}/${PN}-release-${PV}-src

PATCHES=( "${FILESDIR}"/${PN}-7.0-paths.patch )

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

# src_prepare() {
# 	cmake-utils_src_prepare
# }

src_configure() {
	local mycmakeargs=(
		$(usex client "" "-DHEADLESS_ONLY=ON")
		-DWITH_AUTOMATIC_UPDATE=OFF
		-DINSTALL_GAMES_BINDIR=/usr/bin
		-DINSTALL_DATADIR=/usr/share
		-DUSE_STATIC_BOOST=OFF
		-DUSE_SYSTEM_TINYXML=ON
		$(usex editor "" "-DQt5Widgets_FOUND=No") # sadly, there is no proper flag to configure this
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile c4group c4script $(usex client openclonk '') $(usex server openclonk-server '')
	use doc && emake -C docs
}

src_install() {
	cmake-utils_src_install

	if use client; then
		mv "${ED%/}/usr/bin/"{openclonk,clonk} || die
		newbin "${FILESDIR}"/${PN}-wrapper-script.sh ${PN}
	fi
	if use server; then
		dobin "${BUILD_DIR}/openclonk-server"
	fi
	use doc && dohtml -r docs/online/*
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
