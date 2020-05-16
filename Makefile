build:
	nix-shell -p elmPackages.elm nodejs-10_x --command "./build.sh"