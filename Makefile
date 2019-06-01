.PHONY: setup check-ruby check-jq nokogiri
.DEFAULT: setup

setup: | check-ruby nokogiri check-jq

check-ruby:
	@hash ruby >/dev/null || (echo "You need to install Ruby!"; false)

check-jq:
	@hash jq >/dev/null || (echo "You need to install jq!"; false)

nokogiri:
	@[ $$(gem list --installed nokogiri) = "true" ] || gem install nokogiri
