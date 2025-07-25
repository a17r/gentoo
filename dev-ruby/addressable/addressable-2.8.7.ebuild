# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="A replacement for the URI implementation that is part of Ruby's standard library"
HOMEPAGE="https://rubygems.org/gems/addressable https://github.com/sporkmonger/addressable"

LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc test"

ruby_add_rdepend "dev-ruby/public_suffix:6"

ruby_add_bdepend "test? ( dev-ruby/rspec-its )"

all_ruby_prepare() {
	# Remove spec-related tasks so that we don't need to require rspec
	# just to build the documentation, bug 383611.
	sed -i -e '/spectask/d' Rakefile || die
	rm -f tasks/rspec.rake || die
	sed -i -e '/bundler/ s:^:#:' \
		-e '/^begin/,/^end/ s:^:#:' \
		spec/spec_helper.rb || die

	# Remove specs requiring network connectivity
	rm -f spec/addressable/net_http_compat_spec.rb || die

	# Remove spec that tests against an unreleased github fork
	rm -f spec/addressable/rack_mount_compat_spec.rb || die
}
