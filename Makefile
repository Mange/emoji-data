.PHONY: setup check-ruby check-jq nokogiri all dist
.DEFAULT: all

DATA_FILES := $(patsubst views/%.jq,data/%,$(wildcard views/*.jq)) data/all.json

all: $(DATA_FILES)

setup: | check-ruby nokogiri check-jq

dist: data/release.tar.bz2

data:
	@mkdir -p data

cldr:
	@git submodule update --init cldr

data/all.json: compile.rb $(wildcard lib/*.rb) | cldr data check-ruby nokogiri
	@ruby compile.rb > "$@"

data/%.txt: views/%.txt.jq data/all.json | data check-jq
	@jq -r -f "$<" < data/all.json > "$@"

data/%.json: views/%.json.jq data/all.json | data check-jq
	@jq -f "$<" < data/all.json > "$@"

data/release.tar.bz2: $(DATA_FILES) unicode-license.txt README.md
	rm -rf "$@"
	tar -cjf "$@" $^

check-ruby:
	@hash ruby >/dev/null || (echo "You need to install Ruby!"; false)

check-jq:
	@hash jq >/dev/null || (echo "You need to install jq!"; false)

nokogiri:
	@[ $$(gem list --installed nokogiri) = "true" ] || gem install nokogiri
