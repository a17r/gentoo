# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md CONTRIBUTING.md README.md Upgrade.md"

RUBY_FAKEGEM_GEMSPEC="vcr.gemspec"

inherit ruby-fakegem

DESCRIPTION="Records your test suite's HTTP interactions and replay them during test runs"
HOMEPAGE="https://github.com/vcr/vcr/"
SRC_URI="https://github.com/vcr/vcr/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
IUSE="json test"

# Tests require all supported HTTP libraries to be present, and it is
# not possible to avoid some of them without very extensive patches.
RESTRICT="test"

ruby_add_rdepend "
	dev-ruby/base64
	json? ( dev-ruby/json )
"
