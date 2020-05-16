dist/music.json:
	cp src/music.json dist/music.json

build: dist/music.json
	nix-shell -p elmPackages.elm nodejs-10_x --command "./build.sh"