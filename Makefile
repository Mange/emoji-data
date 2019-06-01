.PHONY: setup check-ruby check-jq nokogiri all
.DEFAULT: all

all: data/all.json

setup: | check-ruby nokogiri check-jq

data:
	@mkdir -p data

data/all.json: compile.rb $(wildcard lib/*.rb) | data check-ruby nokogiri
	@ruby compile.rb > data/all.json

check-ruby:
	@hash ruby >/dev/null || (echo "You need to install Ruby!"; false)

check-jq:
	@hash jq >/dev/null || (echo "You need to install jq!"; false)

nokogiri:
	@[ $$(gem list --installed nokogiri) = "true" ] || gem install nokogiri
