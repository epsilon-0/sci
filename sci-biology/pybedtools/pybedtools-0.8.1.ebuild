# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Use BED and GFF files from python using BEDtools"
HOMEPAGE="https://daler.github.io/pybedtools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc minimal"
#RESTRICT="test"
# Tests reported to fail on Gentoo:
# https://github.com/daler/pybedtools/issues/329

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sci-biology/bedtools
	sci-biology/pysam[${PYTHON_USEDEP}]
	!minimal? ( sci-libs/htslib )
"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
"
BDEPEND="
	doc? ( dev-python/sphinx )
"
src_compile(){
	esetup.py cythonize
	distutils-r1_src_compile
	use doc && cd docs && emake html
}

src_install(){
	distutils-r1_src_install
	if use doc; then
		dodoc -r docs/build/html
	fi
}

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing
	pytest -vv || die
}
