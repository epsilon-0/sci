# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Data visualization toolchain based on aggregating into a grid"
HOMEPAGE=""
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

#	dev-python/panel[${PYTHON_USEDEP}]
#	dev-python/pyviz_comms[${PYTHON_USEDEP}]
RDEPEND="${PYTHON_DEPS}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/param[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/bokeh[${PYTHON_USEDEP}]
		dev-python/ipython[matplotlib,notebook,${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/notebook[${PYTHON_USEDEP}]
		dev-python/path-py
	)
"

distutils_enable_tests nose
