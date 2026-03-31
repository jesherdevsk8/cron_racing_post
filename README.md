### Synchronizing Galgo Data
---

Sinatra ActiveRecord Extension - [github/sinatra-activerecod](https://github.com/sinatra-activerecord/sinatra-activerecord)

- **The Rails console equivalent for Sinatra:**

```ruby
bundle exec irb -I. -r server.rb
require 'sinatra/activerecord'
require './app/models/dogs'
```

- **Running the Server**
To start the server in development mode, use the following command:

```ruby
RACK_ENV=development ruby server.rb
```

- **Accessing the Application**
Once the server is running, you can access the application in your web browser at

```ruby
http://localhost:4567
http://localhost:4567/health
http://localhost:4567/dogs
http://localhost:4567/dogs?page=2
http://localhost:4567/next_racings
http://localhost:4567/next_racings?page=2
```

Paginated lists return **30 items per page**; add `?page=N` (optional, default `1`).
