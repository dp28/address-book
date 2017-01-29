install:
	cd address-book-api && bundle install
	cd address-book-client && npm install

server:
	cd address-book-api && bundle exec rails s

serve-client:
	cd address-book-client && npm run start
