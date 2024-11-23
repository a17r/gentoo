# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRYSTALS_PV="1.98.0"
FRAGMENTS_PV="1.99.0"
MOLECULES_PV="1.99.0"
inherit cmake

DESCRIPTION="Advanced molecule editor and visualizer 2 - libraries"
HOMEPAGE="https://www.openchemistry.org/ https://github.com/OpenChemistry/avogadrolibs"
SRC_URI="
	https://github.com/OpenChemistry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/OpenChemistry/fragments/archive/refs/tags/${FRAGMENTS_PV}.tar.gz -> ${PN}-fragments-${FRAGMENTS_PV}.tar.gz
	https://github.com/OpenChemistry/crystals/archive/refs/tags/${CRYSTALS_PV}.tar.gz -> ${PN}-crystals-${CRYSTALS_PV}.tar.gz
	https://github.com/OpenChemistry/molecules/archive/refs/tags/${MOLECULES_PV}.tar.gz -> ${PN}-molecules-${MOLECULES_PV}.tar.gz
	vtk? ( https://github.com/psavery/genXrdPattern/releases/download/1.0-static/linux64-genXrdPattern -> linux64-genXrdPattern-${P} )"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="archive doc hdf5 qt6 test vtk"
RESTRICT="!test? ( test )"
REQUIRED_USE="vtk? ( qt6 )"

# TODO: Not yet packaged:
# sci-libs/libmsym (https://github.com/mcodev31/libmsym)
RDEPEND="
	dev-cpp/nlohmann_json
	dev-libs/pugixml
	>=sci-chemistry/molequeue-0.7
	archive? ( app-arch/libarchive:= )
	hdf5? ( sci-libs/hdf5:= )
	qt6? (
		dev-qt/qtbase:6[concurrent,gui,network,widgets]
		dev-qt/qtsvg:6
		media-libs/glew:0=
		virtual/opengl
	)
	vtk? ( sci-libs/vtk[-qt5,qt6,views] )
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	test? ( dev-cpp/gtest )
"
BDEPEND="
	doc? ( app-text/doxygen[dot] )
	qt6? ( dev-qt/qttools:6[linguist] )
"

PATCHES=(
	"${FILESDIR}/"${PN}-1.91.0_pre20180406-bundled-genxrdpattern.patch
	"${FILESDIR}/"${PN}-1.95.1-tests.patch
)

src_unpack() {
	default

	if use vtk; then
		cp "${DISTDIR}"/linux64-genXrdPattern-${P} "${WORKDIR}/genXrdPattern" || die
	fi

	# hardcoded assumptions in
	# avogadro/qtplugins/insertfragment/CMakeLists.txt
	mv crystals-${CRYSTALS_PV} crystals || die
	mv fragments-${FRAGMENTS_PV} fragments || die
	mv molecules-${MOLECULES_PV} molecules || die
}

src_prepare() {
	sed -e "s/Qt5LinguistTools/Qt6LinguistTools/" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_LIBARCHIVE=$(usex archive)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DUSE_HDF5=$(usex hdf5)
		-DENABLE_TRANSLATIONS=$(usex qt6)
		-DUSE_OPENGL=$(usex qt6)
		-DUSE_QT=$(usex qt6)
		-DQT_VERSION=6
		-DENABLE_TESTING=$(usex test)
		-DUSE_VTK=$(usex vtk)
		-DUSE_EXTERNAL_NLOHMANN=ON
		-DUSE_EXTERNAL_PUGIXML=ON
		# -DUSE_EXTERNAL_STRUCT=ON # not packaged
		# disabled libraries
		-DUSE_PYTHON=OFF
		-DUSE_MMTF=OFF
		-DUSE_LIBMSYM=OFF
		# find_package(Spglib) completely broken
		-DUSE_SPGLIB=OFF
	)
	use qt6 && mycmakeargs+=(
		-DBUILD_GPL_PLUGINS=ON
		-DBUILD_STATIC_PLUGINS=ON
		-DOpenGL_GL_PREFERENCE=GLVND
	)
	use vtk && mycmakeargs+=(
		-DBUNDLED_GENXRDPATTERN="${WORKDIR}/genXrdPattern"
	)

	cmake_src_configure
}
