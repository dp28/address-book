# AddressBookClient

A simple address book web app allowing the storage of people and organisations
for a single user.

## Installation & Usage

```bash
make install

# To run the server
make server

# To serve the client from a development web server (webpack)
make serve-client
```

Navigate to `http://localhost:4200` to see the client. The server runs at
`http://localhost:3000`.

## Server

This requires Ruby 2.3 and is built with Rails 5. It provides a JSON API to a 
SQLite database. 

### Tests

These are written in RSpec. Run them with `cd address-book-api && rspec`.

## Client

This requires Node.js and npm. It is written in ES2015 and built with Angular 2
using the ng-cli tool.
