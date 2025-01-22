# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Remote video eavesdropping using a software-defined radio platform"
HOMEPAGE="https://github.com/deltj/TempestSDR.git"

LICENSE="GPL-3"
SLOT="0"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/deltj/TempestSDR.git"
else
	KEYWORDS="~amd64 ~x86"
	COMMIT="93c238725bdcf2f50c8a1d3789cf56e90f7bab7f"
	SRC_URI="https://github.com/deltj/TempestSDR/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/TempestSDR-${COMMIT}"
fi

DEPEND=">=virtual/jdk-1.8:*
		dev-libs/boost:=
		net-wireless/airspy
		net-wireless/uhd:=
		net-wireless/rtl-sdr
		net-wireless/bladerf:=
		net-wireless/hackrf-tools"
RDEPEND="${DEPEND}"

src_compile() {
	emake all
}

src_install() {
	java-pkg_dojar JavaGUI/JTempestSDR.jar
	java-pkg_dolauncher tempestsdr --jar JTempestSDR.jar
}
