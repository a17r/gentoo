# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="sqlite,xml"

MY_P=${PN}6-${PV}
inherit python-single-r1 xdg

DESCRIPTION="Full featured Python IDE using PyQt and QScintilla"
HOMEPAGE="https://eric-ide.python-projects.org/"
SRC_URI="mirror://sourceforge/eric-ide/${PN}6/stable/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="6"
KEYWORDS="~amd64"
IUSE="spell"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/PyQt5-5.12[gui,help,network,printsupport,sql,svg,widgets,${PYTHON_MULTI_USEDEP}]
		dev-python/PyQtChart[${PYTHON_MULTI_USEDEP}]
		dev-python/PyQtWebEngine[${PYTHON_MULTI_USEDEP}]
		dev-python/qscintilla-python[${PYTHON_MULTI_USEDEP}]
		dev-python/sip[${PYTHON_MULTI_USEDEP}]
	')
"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/chardet-3.0.4[${PYTHON_MULTI_USEDEP}]
		>=dev-python/pygments-2.3.1[${PYTHON_MULTI_USEDEP}]
		spell? ( dev-python/pyenchant[${PYTHON_MULTI_USEDEP}] )
	')
"

S=${WORKDIR}/${MY_P}

DOCS=( eric/docs/{changelog,README.rst,README-eric6-doc.rst,README-passive-debugging.rst,THANKS} )

src_prepare() {
	default

	# Delete internal copies of dev-python/{chardet,pygments}
	rm -fr eric/eric6/ThirdParty/{CharDet,Pygments} || die
}

src_install() {
	yes n | "${PYTHON}" install.py \
		-b "${EPREFIX}/usr/bin" \
		-d "$(python_get_sitedir)" \
		-i "${D}" \
		-c \
		-z \
		|| die

	python_optimize
	einstalldocs
}
