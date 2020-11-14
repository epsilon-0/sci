# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Placeholder for an NI-VISA library ebuild"
HOMEPAGE="http://www.ni.com/"
SRC_URI="NI-VISA-0.0.1.iso"

LICENSE="ni-visa"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
SLOT="0"

RESTRICT="fetch"

pkg_nofetch() {
	elog "Please download the NI-VISA library for linux from"
	elog "   https://www.ni.com/en-us/support/downloads/drivers/download.ni-linux-device-drivers.html#350003"
	elog "and install it."
	elog "Afterwards run the command 'echo > /usr/portage/distfiles/NI-VISA-0.0.1.iso'"
	elog ""
	elog "See for more information - "
	elog "https://forums.ni.com/t5/Linux-Users/NI-VISA-488-2-licensing-questions/gpm-p/3377618?profile.language=en#M248"
}

src_install() {
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}/70nivisa"
}
