# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Breakout-like game by KDE"
HOMEPAGE="https://apps.kde.org/kbreakout/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-apps/libkdegames-${PVCUT}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}"
