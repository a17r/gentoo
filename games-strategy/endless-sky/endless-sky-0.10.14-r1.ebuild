# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Space exploration, trading & combat in the tradition of Terminal Velocity"
HOMEPAGE="https://endless-sky.github.io/"
SRC_URI="
	https://github.com/endless-sky/endless-sky/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="
	GPL-3+
	CC-BY-2.0 CC-BY-3.0 CC-BY-4.0
	CC-BY-SA-3.0 CC-BY-SA-4.0
	CC0-1.0 Unsplash public-domain
"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gles2-only test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libglvnd
	media-libs/libjpeg-turbo:=
	media-libs/libmad
	media-libs/libpng:=
	media-libs/libsdl2[video]
	media-libs/openal
	sys-apps/util-linux
	sys-libs/zlib:=[minizip]
	gles2-only? ( media-libs/libsdl2[gles2] )
	!gles2-only? (
		media-libs/glew:0=
		media-libs/libsdl2[opengl]
	)
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/catch:0 )
"

src_prepare() {
	cmake_src_prepare

	# no /usr/*games/ on Gentoo, adjust docdir, install even if != Release,
	# and GLEW is unused if USE=gles2-only (using sed for less rebasing)
	sed -e '/install(/s: games: libexec:' \
		-e '/install(/s: share/games: share:' \
		-e "/install(/s: share/doc/endless-sky: share/doc/${PF}:" \
		-e '/install(/s: CONFIGURATIONS Release::' \
		-e 's:GLEW REQUIRED:GLEW:' \
		-i CMakeLists.txt || die

	# do not use sanitizers for tests
	sed -i '/SANITIZER_OPTS/d' tests/CMakeLists.txt || die

	# source/Files.cpp has odd logic to find resources, make a wrapper
	# rather than try to modify it
	printf '#!/usr/bin/env sh\nexec %q --resources %q "$@"\n' \
		"${EPREFIX}"/usr/libexec/${PN} \
		"${EPREFIX}"/usr/share/${PN} > "${T}"/${PN} || die
}

src_configure() {
	filter-lto # -Werror=odr issues

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DES_GLES=$(usex gles2-only)
		-DES_USE_SYSTEM_LIBRARIES=yes
		-DES_USE_VCPKG=no
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dobin "${T}"/${PN}

	gzip -d -- "${ED}"/usr/share/man/man6/${PN}.6.gz || die
	rm -- "${ED}"/usr/share/doc/${PF}/{copyright,license.txt} || die
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Endless Sky provides high-res sprites for high-dpi screens."
		elog "If you want to use them, download:"
		elog
		elog "   https://github.com/endless-sky/endless-sky-high-dpi/releases"
		elog
		elog "and extract it to ~/.local/share/endless-sky/plugins/"
	fi
}
