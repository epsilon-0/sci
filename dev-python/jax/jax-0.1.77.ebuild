# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="XLA library for JAX"
HOMEPAGE="https://github.com/google/jax"
SRC_URI="https://github.com/google/jax/archive/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/jax-jax-v${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${PYTHON_DEPS}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/jaxlib[${PYTHON_USEDEP}]
	dev-python/python-six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
