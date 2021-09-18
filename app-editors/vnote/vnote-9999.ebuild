# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="Vim-inspired note taking application that knows programmers and Markdown better"
HOMEPAGE="https://tamlok.gitee.io/vnote"

if [[ ${PV} == "9999" ]];then
	EGIT_REPO_URI="https://github.com/vnotex/vnote.git"
	EGIT_SUBMODULES=('*')
	inherit git-r3
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/vnotex/vnote/archive/v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/vnote-${PV}"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-qt/qtcore
	dev-qt/qtwebengine[widgets]
	dev-qt/qtsvg
"

RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare(){
	sed -i -e "/LIBDIR =/{s@lib@$(get_libdir)@}" libs/vtextedit/src/editor/editor.pro || die "wrong editor libdir"
	sed -i -e "/LIBDIR =/{s@lib@$(get_libdir)@}" libs/vtextedit/src/libs/syntax-highlighting/syntax-highlighting.pro || die "wrong syntax-highlighting libdir"
	sed -i -e "/LIBDIR =/{s@lib@$(get_libdir)@}" src/src.pro || die "wrong libdir"
	default
}

src_configure(){
	eqmake5 vnote.pro
}

src_install(){
	INSTALL_ROOT="${ED%/}" 	default
}
