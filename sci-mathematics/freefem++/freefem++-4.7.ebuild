# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils flag-o-matic mpi versionator toolchain-funcs

DESCRIPTION="Solve PDEs using FEM on 2d and 3d domains"
HOMEPAGE="https://www.freefem.org"
SRC_URI="https://github.com/FreeFem/FreeFem-sources/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/FreeFem-sources-${PV}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples mpi opengl X"

RDEPEND="
	sci-libs/fftw:3.0
	virtual/cblas
	virtual/lapack
	sci-libs/umfpack
	sci-libs/arpack
	mpi? ( $(mpi_pkg_deplist) )
	opengl? (
		media-libs/freeglut
		virtual/opengl
		)
	X? (
		media-fonts/font-misc-misc
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm
		x11-libs/libXxf86vm
		)"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-latexextra
		virtual/latex-base
		media-gfx/imagemagick
		)"

src_configure() {
	local mycmakeargs=(
		
	)

	if use mpi; then
		myconf="${myconf} --with-mpi=$(mpi_pkg_cxx)"
	else
		myconf="--without-mpi"
	fi

	econf \
		--disable-download \
		--disable-optim \
		--enable-generic \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)" \
		$(use_enable opengl) \
		$(use_with X x) \
		${myconf}
}

src_compile() {
	default

	if use doc; then
		emake documentation
	fi
}

src_test() {
	if use mpi; then
		# This may depend on the used MPI implementation. It is needed
		# with mpich2, but should not be needed with lam-mpi or mpich
		# (if the system is configured correctly).
		ewarn "Please check that your MPI root ring is on before running"
		ewarn "the test phase. Failing to start it before that phase may"
		ewarn "result in a failing emerge."
		epause
	fi
	emake -j1 check
}

src_install() {
	default

	insinto /usr/share/doc/${PF}
	if use doc; then
		doins DOC/freefem++doc.pdf
	fi

	if use examples; then
		einfo "Installing examples..."

		# Remove compiled examples:
		emake clean

		einfo "Some of the installed examples assumes that the user has write"
		einfo "permissions in the working directory and other will look for"
		einfo "data files in the working directory. For this reason in order to"
		einfo "run the examples it's better to temporary copy them somewhere"
		einfo "in the user folder. For example to run the tutorial examples"
		einfo "it's better to copy the entire examples++-tutorial folder into"
		einfo "the user directory."

		rm -f examples*/Makefile* || die
		doins -r examples*
	fi
}
