set -e

double_pop() {
	popd >/dev/null || exit
	popd >/dev/null || exit
}

source versions.sh

package_slug() {
	echo "$1-${VERSIONS[$1]}"
}

SLUG="$(package_slug "$PACKAGE")"
test "$SLUG"

DOCDIR="/usr/share/doc/$SLUG"
test "$DOCDIR"

unpack_package() {
	local slug
	slug=$(package_slug "$1")

	pushd "$LFS/sources" >/dev/null || exit

	if [ ! -d "$slug" ]; then
		if [ -f "$slug.tar.xz" ]; then
			tar xf "$slug.tar.xz"
		elif [ -f "$slug.tar.gz" ]; then
			tar xf "$slug.tar.gz"
		fi
	fi

	popd >/dev/null || exit

	echo "$slug"
}

ensure_unpacked() {
	pushd "$LFS/sources" >/dev/null || exit

	pushd "$(unpack_package "$PACKAGE")" >/dev/null || exit

	trap double_pop EXIT
}

ensure_clean_unpacked() {
	pushd "$LFS/sources" >/dev/null || exit

	rm -rf "$SLUG"
	pushd "$(unpack_package "$PACKAGE")" >/dev/null || exit

	trap double_pop EXIT
}

make_nproc() {
	make "-j$(nproc)"
}

make_install() {
	make_nproc
	make install
}

make_check_install() {
	make_nproc
	make check
	make install
}

make_test_install() {
	make_nproc
	make test
	make install
}
