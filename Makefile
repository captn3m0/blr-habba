docs/2023.json:
	curl --silent 'https://ec2.unboxingblr.com/get-all-events' -X POST |jq '.events' > docs/2023.json

gems:
	bundle install

docs/2023.ics: gems docs/2023.json
	bundle exec ruby gen.rb

docs/index.html:
	pandoc --metadata title="BLR Habba Calendar" -s -f markdown README.md > docs/index.html

publish: docs/2023.ics docs/index.html

clean:
	rm docs/*