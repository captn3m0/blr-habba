2023.json:
	curl --silent 'https://ec2.unboxingblr.com/get-all-events' -X POST > 2023.json

gems:
	bundle install

2023.ics: gems 2023.json
	bundle exec ruby gen.rb
