# Party UP! Makefile
# by default we always build debug.
.PHONY: debug
debug:
	rm -rf ./build
	xcodebuild -configuration Debug

.PHONY: clean
clean:
	rm -rf ./build

.PHONY: release
release:
	rm -rf ./build
	xcodebuild -configuration Release 
