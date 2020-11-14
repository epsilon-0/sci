# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit cmake python-single-r1
CMAKE_BUILD_TYPE=Release

DESCRIPTION="embeddable arithmetic expression language for graphics"
HOMEPAGE="https://wdas.github.io/SeExpr/"

SRC_URI="https://github.com/wdas/SeExpr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug demo doc llvm +python qt slow-tests test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) slow-tests? ( test )"
RESTRICT="!test? ( test )"

DEPEND="
	dev-cpp/gtest
	dev-libs/boost
	media-libs/libpng
	virtual/opengl
	llvm? ( sys-devel/llvm )
	python? ( qt? (
		$(python_gen_cond_dep '
			dev-python/PyQt5[${PYTHON_USEDEP}]
			dev-python/PyQt5-sip[${PYTHON_USEDEP}]
			dev-qt/qtopengl
		') )
		$(python_gen_cond_dep '
			dev-libs/boost[${PYTHON_USEDEP}]
			dev-python/sip[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
	)
	qt? (
		dev-qt/qtcore
		dev-qt/qtgui
		dev-qt/qtwidgets
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	llvm? ( sys-devel/llvm )
	doc? ( app-doc/doxygen )
"

PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

pkg_setup() {
	if use debug; then
		CMAKE_BUILD_TYPE=debug
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_UTILS=ON
		-DBUILD_DEMOS=$(usex demo)
		-DBUILD_DOC=$(usex doc)
		-DENABLE_LLVM_BACKEND=$(usex llvm)
		-DENABLE_QT5=$(usex qt)
		-DUSE_PYTHON=$(usex python)
		-DBUILD_TESTS=$(usex test)
		-DENABLE_SLOW_TESTS=$(usex slow-tests)
	)
	cmake_src_configure
}
