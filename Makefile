_site/2023.json:
	curl --silent 'https://ec2.unboxingblr.com/get-all-events' -X POST > _site/2023.json

gems:
	bundle install

_site/2023.ics: gems _site/2023.json
	bundle exec ruby gen.rb

_site/index.html:
	pandoc -f markdown README.md > _site/index.html

publish: _site/2023.ics _site/index.html