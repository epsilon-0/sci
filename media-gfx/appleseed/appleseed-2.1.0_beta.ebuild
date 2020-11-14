# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit cmake python-single-r1

MY_PV=${PV/_/-}

DESCRIPTION="modern open source rendering engine for stunning visual effects"
HOMEPAGE="https://appleseedhq.net/"
SRC_URI="https://github.com/appleseedhq/appleseed/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64"

X86_CPU_FEATURES=(
	sse2:sse2 sse4_2:sse42 avx:avx avx2:avx2 f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="doc gpu test ${CPU_FEATURES[@]%:*}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	gpu? ( 
		dev-libs/optix
		>=dev-util/nvidia-cuda-toolkit-9.0.0
	)
	$(python_gen_cond_dep '
		dev-libs/boost[${PYTHON_USEDEP}]

	')
	app-arch/lz4
	dev-libs/xerces-c
	dev-qt/qtcore
	dev-qt/qtwidgets[X]
	dev-qt/qtgui[X]
	media-libs/ilmbase
	media-libs/libpng
	media-libs/opencolorio
	media-libs/openexr
	media-libs/openimageio
	media-libs/osl
	net-libs/libnsl
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen
	)
"

pkg_setup() {
	elog "${IUSE}"
	python-single-r1_pkg_setup
}

src_configure() {
	# DisneyMaterial needs SeExpr - https://wdas.github.io/SeExpr/
	# embree needs... embree (painful af)
	local mycmakeargs=(
		-DWITH_DISNEY_MATERIAL=OFF
		-DWITH_EMBREE=OFF
		-DUSE_SSE=$(usex cpu_flags_x86_sse2)
		-DUSE_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DUSE_AVX=$(usex cpu_flags_x86_avx)
		-DUSE_AVX2=$(usex cpu_flags_x86_avx2)
		-DUSE_F16C=$(usex cpu_flags_x86_f16c)
		-DWITH_GPU=$(usex gpu)
		-DWITH_DOXYGEN=$(usex doc)
		-DINSTALL_TESTS=$(usex test)
		-DWITH_CLI=ON
		-DWITH_STUDIO=ON
		-DWITH_TOOLS=ON
		-DWITH_PYTHON2_BINDINGS=OFF
		-DWITH_PYTHON3_BINDINGS=ON
		-DWITH_SPECTRAL_SUPPORT=ON
		-DINSTALL_HEADERS=ON
		-DINSTALL_API_EXAMPLES=ON
		-DUSE_STATIC_BOOST=OFF
		-DUSE_STATIC_EMBREE=OFF
		-DUSE_STATIC_EXR=OFF
		-DUSE_STATIC_OCIO=OFF
		-DUSE_STATIC_OIIO=OFF
		-DUSE_STATIC_OSL=OFF
		-DWARNINGS_AS_ERRORS=OFF
		-DHIDE_SYMBOLS=OFF
		-DUSE_VISIBILITY_MAP=OFF
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
