.PHONY: setup check-ruby check-jq nokogiri all
.DEFAULT: all

DATA_FILES := $(patsubst views/%.jq,data/%,$(wildcard views/*.jq))

all: $(DATA_FILES)

setup: | check-ruby nokogiri check-jq

data:
	@mkdir -p data

cldr:
	@git submodule update --init cldr

data/all.json: compile.rb $(wildcard lib/*.rb) | cldr data check-ruby nokogiri
	@ruby compile.rb > data/all.json

data/%.txt: views/%.txt.jq data/all.json | data check-jq
	@jq -r -f "$<" < data/all.json > "$@"

data/%.json: views/%.json.jq data/all.json | data check-jq
	@jq -f "$<" < data/all.json > "$@"

check-ruby:
	@hash ruby >/dev/null || (echo "You need to install Ruby!"; false)

check-jq:
	@hash jq >/dev/null || (echo "You need to install jq!"; false)

nokogiri:
	@[ $$(gem list --installed nokogiri) = "true" ] || gem install nokogiri
