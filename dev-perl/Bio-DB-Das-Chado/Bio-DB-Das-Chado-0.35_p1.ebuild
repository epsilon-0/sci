# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="SCAIN"
DIST_VERSION=0.35a
inherit perl-module

DESCRIPTION="A Chado database interface for Gbrowse-2"

LICENSE="|| ( Artistic-2 GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/DBD-Pg
	dev-perl/Module-Build
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}-${PV%_*}