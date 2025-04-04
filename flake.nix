{
  description = "emoji-data";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }: 
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = (
          pkgs.mkShell {
            name = "emoji-data";
            nativeBuildInputs = with pkgs; [
              ruby
              gnumake
              jq
            ];

            shellHook = ''
              export RUBY_VERSION="$(ruby -e 'puts RUBY_VERSION.gsub(/\d+$/, "0")')"
              export GEM_HOME="$(pwd)/vendor/bundle/ruby/$RUBY_VERSION"
              export BUNDLE_PATH="$(pwd)/vendor/bundle"
              export PATH="$GEM_HOME/bin:$PATH"
            '';
          }
        );
      }
    );
}
