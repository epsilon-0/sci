# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java GUI frontend for managing BibTeX and other bibliographies."
HOMEPAGE="http://jabref.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/JabRef-${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

EANT_BUILD_TARGET="jars"

COMMON_DEPEND=""
DEPEND=">=virtual/jre-1.6
		${COMMON_DEPEND}"
RDEPEND=">=virtual/jdk-1.6
		 ${COMMON_DEPEND}"

src_install() {
	java-pkg_newjar build/lib/JabRef-${PV}.jar
	java-pkg_dolauncher ${PN} --main net.sf.jabref.JabRef
	newicon src/images/JabRef-icon-48.png JabRef-icon.png || die "failed to create icon"
	make_desktop_entry ${PN} JabRef JabRef-icon Office
}
