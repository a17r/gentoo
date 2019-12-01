# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Noto fonts support tools and scripts plus web site generation"
HOMEPAGE="https://github.com/googlefonts/nototools"
SRC_URI="https://github.com/googlefonts/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-python/booleanOperations-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/fonttools-3.36.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyclipper-1.0.6[${PYTHON_USEDEP}]
	media-gfx/scour
	virtual/python-typing[${PYTHON_USEDEP}]
"

# S="${WORKDIR}/${PN}-${COMMIT}"

python_test() {
	esetup.py test
}
