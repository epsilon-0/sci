# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
inherit check-reqs cmake dotnet llvm python-any-r1

DESCRIPTION="game and rendering engine for complex graphical tasks"
HOMEPAGE="https://www.unrealengine.com"

SRC_URI="${P}-release.tar.gz"

S="${WORKDIR}"/${P}-release

KEYWORDS="~amd64"

LICENSE="UnrealEngine"
SLOT="0"

BDEPEND="
	app-text/dos2unix
	dev-lang/mono
	dev-vcs/git
"
RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/libmcpp
	dev-libs/cloog
	dev-libs/gmp
	dev-libs/icu
	dev-libs/isl
	dev-libs/mpfr
	media-libs/freetype[X,png]
	media-libs/libsdl2[opengl,X]
	media-libs/libvorbis
	media-libs/opus
	media-sound/mpc
	sys-devel/gettext
	sys-devel/lld
	sys-libs/zlib
	x11-misc/xdg-user-dirs
	x11-misc/xdg-utils
	x11-terms/xterm
"
DEPEND="${RDEPEND}"

pkg_pretend() {
	CHECKREQS_DISK_BUILD="20G"

	check-reqs_pkg_pretend
}

pkg_setup() {
	python-any-r1_pkg_setup 
	dotnet_pkg_setup
}
