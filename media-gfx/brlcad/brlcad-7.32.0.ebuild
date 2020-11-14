# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake eutils java-pkg-opt-2 flag-o-matic

DESCRIPTION="Constructive solid geometry modeling system"
HOMEPAGE="http://brlcad.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="benchmarks debug doc +examples java opencl opengl openvdb osg qt runtime-debug smp"

RDEPEND="
	sci-libs/tnt
	dev-lang/tcl
	dev-lang/tk
	dev-tcltk/tktable
	media-gfx/appleseed
	media-libs/libpng:0
	media-libs/netpbm[jpeg,png,X,zlib]
	media-libs/urt[X]
	sci-libs/gdal[gif,jpeg,jpeg2k,opencl?,png,java?]
	sys-libs/libtermcap-compat
	sys-libs/zlib
	x11-libs/libXt
	x11-libs/libXi
	java? (
		sci-libs/jama
		>=virtual/jre-1.5:*
	)
	openvdb? ( media-gfx/openvdb )
	opencl? ( virtual/opencl )
	osg? ( dev-games/openscenegraph )
	qt? (
		dev-qt/qtcore
		dev-qt/qtwidgets
		dev-qt/qtgui
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig
	dev-lang/tcl
	dev-lang/tk
	sys-devel/bison
	sys-devel/flex
	doc? (
		dev-libs/libxslt
		app-doc/doxygen
	)
"

BRLCAD_DIR="${EPREFIX}/usr/${PN}"

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup

	if use debug; then
		export CMAKE_BUILD_TYPE=Debug
	else
		export CMAKE_BUILD_TYPE=Release
	fi
}

src_prepare() {
	use java && java-pkg-opt-2_src_prepare
	cmake_src_prepare
}

src_configure() {
	# bullet is borked in brlcad
	# disable for now
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${BRLCAD_DIR}"
		-DBUILD_STATIC_LIBS=NO
		-DUSE_OBJECT_LIBS=NO
		-DBRLCAD_FLAGS_OPTIMIZATION=ON
		-DBRLCAD_BUNDLED_LIBS=AUTO
		-DBRLCAD_ENABLE_MINIMAL=OFF
		-DBRLCAD_ENABLE_BRLCAD_LIBRARY=OFF
		-DBRLCAD_ENABLE_STRICT=NO
		-DBRLCAD-ENABLE_COMPILER_WARNINGS=NO
		-DBRLCAD_ENABLE_X11=ON
		-DBRLCAD_ENABLE_OSG=ON
		-DBRLCAD_ENABLE_VERBOSE_PROGRESS=ON
		-DBRLCAD_ENABLE_64BIT=ON
		-DBRLCAD_ENABLE_BULLET=OFF
		-DBRLCAD_ENABLE_GCT=ON
		-DBRLCAD_ENABLE_OSG=$(usex osg)
		-DBRLCAD_ENABLE_QT=$(usex qt)
		-DBRLCAD_ENABLE_OPENCL=$(usex opencl)
		-DBRLCAD_ENABLE_TCL=ON
		-DBRLCAD_ENABLE_OPENVDB=$(usex openvdb)
		-DBRLCAD_ENABLE_BINARY_ATTRIBUTES=OFF
		-DBRLCAD_ENABLE_RUNTIME_DEBUG=$(usex runtime-debug)
		-DBRLCAD_ENABLE_OPENGL=$(usex opengl)
		-DBRLCAD_ENABLE_RTGL=$(usex opengl)
		-DBRLCAD_ENABLE_SMP=$(usex smp)
		-DBRLCAD_ENABLE_RTSERVER=$(usex java)
		-DBRLCAD_INSTALL_EXAMPLE_GEOMETRY=$(usex examples)
		-DBRLCAD_EXTRADOCS=$(usex doc)
		${EXTRA_ECONF[@]}
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm -f "${D}"/usr/share/brlcad/{README,NEWS,AUTHORS,HACKING,INSTALL,COPYING}
	dodoc AUTHORS NEWS README HACKING TODO BUGS ChangeLog
	echo "PATH=\"${BRLCAD_DIR}/bin\"" >  99brlcad
	echo "MANPATH=\"${BRLCAD_DIR}/man\"" >> 99brlcad
	doenvd 99brlcad
	newicon misc/macosx/Resources/ReadMe.rtfd/brlcad_logo_tiny.png brlcad.png
	make_desktop_entry mged "BRL-CAD" brlcad "Graphics;Engineering"
}
