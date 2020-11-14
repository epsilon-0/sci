# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="AKHUETTEL"
inherit perl-module

DESCRIPTION="Perl interface to National Instrument's VISA library"
HOMEPAGE="http://www.labvisa.de/"

LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="sci-libs/ni-visa"
RDEPEND="${DEPEND}"
