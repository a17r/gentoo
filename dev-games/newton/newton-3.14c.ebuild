# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="Integrated solution for real time simulation of physics environments"
HOMEPAGE="http://newtondynamics.com/forum/newton.php"
SRC_URI="https://github.com/MADEAPPS/newton-dynamics/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/glfw
	media-libs/openal
	virtual/opengl
"
BDEPEND="${DEPEND}"
BDEPEND="dev-libs/tinyxml"

S="${WORKDIR}"/${PN}-dynamics-${PV}

src_prepare() {
	cmake_src_prepare
	sed -i -e '/packages/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DNEWTON_BUILD_SANDBOX_DEMOS=OFF
		-DCMAKE_VERBOSE_MAKEFILE=ON
	)
	cmake_src_configure
}
