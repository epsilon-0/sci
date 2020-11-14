# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit cmake eutils flag-o-matic python-single-r1

DESCRIPTION="Automatic 3d tetrahedral mesh generator"
HOMEPAGE="https://ngsolve.org/"
SRC_URI="https://github.com/NGSolve/netgen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="ccache cgns ffmpeg gui jpeg mpi opencascade openmp spdlog test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	dev-lang/tcl:=
	dev-lang/tk:=
	dev-python/pybind11-stubgen
	dev-tcltk/tix
	dev-tcltk/togl:1.7
	x11-libs/libX11
	x11-libs/libXmu
	virtual/opengl
	cgns? ( sci-libs/cgnslib )
	spdlog? ( dev-libs/spdlog )
	opencascade? ( sci-libs/opencascade:* )
	ffmpeg? ( media-video/ffmpeg )
	jpeg? ( virtual/jpeg:0= )
	mpi? (
		virtual/mpi
		|| (
			sci-libs/parmetis
			<sci-libs/metis-5.0
		)
		opencascade? ( sci-libs/hdf5[mpi] )
	)
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/catch )
"

PATCHES=( "${FILESDIR}"/${PN}-6.2.2008-cmake.patch )

src_prepare() {
	if use mpi; then
		export CC=mpicc
		export CXX=mpic++
		export FC=mpif90
		export F90=mpif90
		export F77=mpif77
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_NATIVE_ARCH=OFF
		-DBUILD_FOR_CONDA=OFF
		-DINSTALL_PROFILES=OFF
		-DUSE_PYTHON=ON
		-DBUILD_STUB_FILES=OFF
		-DINTEL_MIC=OFF
		-DUSE_MPI=$(usex mpi)
		-DUSE_MPI4PY=$(usex mpi)
		-DUSE_OCC=$(usex opencascade)
		-DUSE_JPEG=$(usex jpeg)
		-DUSE_MPEG=$(usex ffmpeg)
		-DUSE_CGNS=$(usex cgns)
		-DUSE_CCACHE=$(usex ccache)
		-DUSE_SUPERBUILD=$(usex ccache)
		-DUSE_SPDLOG=$(usex spdlog)
		-DUSE_GUI=$(usex gui)
		-DENABLE_UNIT_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	python_optimize "${ED}"
}
