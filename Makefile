all:
	mkdir -p lua/config
	cargo build --release
	cp target/release/libinit.so lua/init.so

clean:
	rm -rf lua/init.so
