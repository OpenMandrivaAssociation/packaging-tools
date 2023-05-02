#!/bin/sh
if [ "$#" -gt 0 ]; then
	TARGET="$1"
	shift
elif [ -z "$TARGET" ]; then
	TARGET="riscv64"
fi
exec rpmbuild -ba --define "_specdir $(pwd)" --define "_sourcedir $(pwd)" --define "_builddir $(pwd)/BUILD" --define "_srcrpmdir $(pwd)/SRPMS" --define "_buildrootdir $(pwd)/BUILDROOT" --define "_rpmdir $(pwd)/RPMS" "$@" --target ${TARGET} $(ls *.spec)
