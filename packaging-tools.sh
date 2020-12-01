alias ba='rpm -ba --define "_sourcedir `pwd`" *.spec'
alias m="make -j `getconf _NPROCESSORS_ONLN` || make"
co() {
	mkdir -p ~/abf
	cd ~/abf
	git clone git@github.com:OpenMandrivaAssociation/$1.git
	cd $1
	abf fetch
}
