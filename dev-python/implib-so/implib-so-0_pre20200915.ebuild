# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit python-single-r1

DESCRIPTION="POSIX equivalent of Windows DLL import libraries"
HOMEPAGE="https://github.com/yugr/Implib.so"
COMMIT=5bc0ea3676449403fda6b97c941bccdf7d54c95e
SRC_URI="https://github.com/yugr/Implib.so/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/Implib.so-${COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	default
	python_fix_shebang implib-gen.py
}

src_install() {
	default
	newbin implib-gen.py implib-gen
}
