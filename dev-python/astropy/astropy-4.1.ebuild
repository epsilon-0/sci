# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Core functionality for performing astrophysics with Python"
HOMEPAGE="http://astropy.org/"
SRC_URI="https://github.com/astropy/astropy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

RDEPEND="
	dev-libs/expat:0=
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-astronomy/erfa:0=
	sci-astronomy/wcslib:0=
	>=sci-libs/cfitsio-3.350:0=
	sys-libs/zlib:0="
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)
	test? (
		dev-libs/libxml2
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e '/import ah_bootstrap/d' -i setup.py || die "Removing ah_bootstrap failed"
}

python_compile() {
	distutils-r1_python_compile --use-system-libraries
}

python_compile_all() {
	if use doc; then
		python_export_best
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${BUILD_DIR}" \
			PYTHONPATH="${BUILD_DIR}"/lib \
			esetup.py build_sphinx
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_src_install_all
}
