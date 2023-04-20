all:
	mkdir -p lua/config
	cargo build --release
	cp target/release/libinit.so lua/init.so
	cp target/release/liboptions.so lua/config/options.so

clean:
	rm -rf lua/init.so
	rm -rf lua/conifg/options.so
