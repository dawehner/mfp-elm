dist/music.json:
	cp src/music.json dist/music.json

build: dist/music.json
	nix-shell -p elmPackages.elm --command 'elm make src/Main.elm --output=src/index.html'

