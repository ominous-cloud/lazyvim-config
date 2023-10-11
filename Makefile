.PHONY: all clean init

all:
	mkdir -p lua/config
	cargo build --release
	cp target/release/libinit.so lua/init.so

clean:
	rm -rf lua/init.so

init:
	cp prebuilt/linux/x86_64/20231011/init.so lua/init.so
