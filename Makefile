.PHONY: setup check-ruby check-jq nokogiri all dist cldr clean
.DEFAULT: all

DATA_FILES := $(patsubst views/%.jq,data/%,$(wildcard views/*.jq)) data/all.json
INPUT_FILES := $(wildcard cldr/common/annotations/*.xml) \
	$(wildcard cldr/common/annotationsDerived/*.xml) \
	cldr/tools/java/org/unicode/cldr/util/data/emoji/emoji-test.txt

all: cldr $(DATA_FILES)

clean:
	rm -f $(DATA_FILES)

setup: | check-ruby nokogiri check-jq

dist: data/release.tar.bz2

data:
	@mkdir -p data

cldr:
	@[ ! -d cldr/.git ] && git submodule update --init cldr

data/all.json: compile.rb $(wildcard lib/*.rb) $(INPUT_FILES) | cldr data check-ruby nokogiri
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
