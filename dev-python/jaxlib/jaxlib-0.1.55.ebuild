# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit bazel cuda distutils-r1

DESCRIPTION="XLA library for JAX"
HOMEPAGE="https://github.com/google/jax"
SRC_URI="https://github.com/google/jax/archive/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/jax-jaxlib-v${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${PYTHON_DEPS}
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/python-six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_compile() {
	${EPYTHON} build/build.py || die
}

python_install() {
	distutils-r1_python_install build
}
