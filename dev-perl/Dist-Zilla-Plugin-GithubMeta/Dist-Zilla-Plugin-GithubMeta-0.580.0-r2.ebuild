# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BINGOS
DIST_VERSION=0.58
inherit perl-module

DESCRIPTION="Automatically include GitHub meta information in META.yml"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Dist-Zilla-4.101.582
	dev-perl/File-pushd
	>=dev-perl/Moose-1.70.0
	>=dev-perl/MooseX-Types-URI-0.30.0
	dev-perl/Try-Tiny
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Path-Tiny
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.880.0
	)
"

PERL_RM_FILES=(
	"t/author-pod-coverage.t"
	"t/author-pod-syntax.t"
)
