# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME=lacaml
inherit dune toolchain-funcs

DESCRIPTION="BLAS/LAPACK interfaces for OCaml"
HOMEPAGE="
	https://mmottl.github.io/lacaml
	https://github.com/mmottl/lacaml
"
SRC_URI="https://github.com/mmottl/lacaml/releases/download/${PV}/${P}.tbz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ocamlopt"

RDEPEND="
	virtual/blas
	virtual/lapack
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( "README.md" "CHANGES.md" )
