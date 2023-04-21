all:
	mkdir -p lua/config
	cargo build --workspace --release
	cp target/release/libinit.so lua/init.so
	cp target/release/liboptions.so lua/config/options.so
	cp target/release/libkeymaps.so lua/config/keymaps.so

clean:
	rm -rf lua/init.so
	rm -rf lua/config/options.so
	rm -rf lua/config/keymaps.so
