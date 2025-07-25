# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: unbundle libtommath, libtomcrypt. There's experimental support upstream.
# bug #732634

DIST_AUTHOR=MIK
DIST_VERSION=0.087
inherit perl-module

DESCRIPTION="Self-contained crypto toolkit"

LICENSE="|| ( Artistic GPL-1+ ) public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="minimal"

RDEPEND="
	!minimal? (
		dev-perl/JSON
	)
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		!minimal? (
			>=virtual/perl-Math-BigInt-1.999.715
			>=virtual/perl-Storable-2.0.0
		)
	)
"

PERL_RM_FILES=(
	t/002_all_pm.t
	t/003_all_pm_pod.t
	t/004_all_pm_pod_spelling.t
	t/005_all_pm_pod_coverage.t
)

PATCHES=(
	"${FILESDIR}"/${PN}-0.85.0-respect-flags.patch
)

#src_configure() {
#	CRYPTX_LDFLAGS='-ltommath -ltomcrypt' perl-module_src_configure
#}
