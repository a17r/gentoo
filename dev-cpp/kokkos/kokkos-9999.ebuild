# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="C++ Performance Portability Programming EcoSystem"
HOMEPAGE="https://github.com/kokkos"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kokkos/kokkos.git"
else
	MY_PV="$(ver_cut 1-2).0$(ver_cut 3)"
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="+openmp test"
RESTRICT="!test? ( test )"

DEPEND="sys-apps/hwloc:="
RDEPEND="${DEPEND}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=include/kokkos
		-DKokkos_ENABLE_TESTS=$(usex test)
		-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON
		-DKokkos_ENABLE_SERIAL=ON
		-DKokkos_ENABLE_HWLOC=ON
		-DKokkos_HWLOC_DIR="${EPREFIX}/usr"
		-DKokkos_ENABLE_OPENMP=$(usex openmp)
		-DBUILD_SHARED_LIBS=ON
	)

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		# Contains "death tests" which are known/expected(?) to fail
		# https://github.com/kokkos/kokkos/issues/3033
		# bug #791514
		-E "(KokkosCore_UnitTest_OpenMP|KokkosCore_UnitTest_Serial)"
	)

	cmake_src_test
}
