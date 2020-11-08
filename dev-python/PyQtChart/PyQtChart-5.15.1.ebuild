# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

MY_P=PyQtChart-${PV}
MY_HASHDIR=49c7e5774835a97543b9759c617d0ad2bfd2e3e3596e4c2cddf9b38aeee2
inherit python-r1 qmake-utils

DESCRIPTION="Python bindings for the Qt Chart framework"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtchart/intro"
SRC_URI="https://files.pythonhosted.org/packages/cf/97/${MY_HASHDIR}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
	>=dev-qt/qtcharts-5.11:5
"
DEPEND="${RDEPEND}
	>=dev-python/sip-4.19:=[${PYTHON_USEDEP}]
"

DOCS=( ChangeLog NEWS )

src_configure() {
	configuration() {
		local myconf=(
			${PYTHON}
			configure.py
			--verbose
			--qmake="$(qt5_get_bindir)"/qmake
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die
	}
	python_copy_sources
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		sed -i -e 's/install_distinfo/ /' Makefile || die
		local tmp_root=${D%/}/tmp
		emake INSTALL_ROOT="${tmp_root}" install

		multibuild_merge_root "${tmp_root}" "${D}"
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation
	einstalldocs
}
