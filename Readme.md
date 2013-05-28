Here is a [CC0][] api for storing and searching for similar images using [pHash][].

Please submit all questions, bugs and feature requests to [the issue page][].

#### Setup
  
  The API requires [node.js][], [redis][], and supports [dtrace][].

  Node comes with npm, so `npm install` to grab all the dependencies, and `sudo npm start` to start the server. Make sure all the tests pass with `npm test`. Try not to ignore the console errors, please report them to [the bugtracker][].

#### Usage

  Visit [localhost][] to browse the api, pretty UI courtesy of [swagger][].

  The [restify][] framework has first-class support for [DTrace][], so enjoy the performance analysation tools.

#### Guidelines

  The code is [CC0][], but if you do anything interesting, it would be nice to give attribution and contribute back any modifications or improvements. I'd also love to see how people are using it.

#### Deployment

  To spin up a heroku instance, just `heroku apps:create --addons redistogo`, `git remote add heroku YOUR_HEROKU_GIT_URI`, and `git push heroku master`.

  To deliver anywhere else, install [deliver][], edit `.deliver/config`, and run `deliver`. This has been tested on Ubuntu 12.04 and OSX 10.8.

[CC0]: http://creativecommons.org/publicdomain/zero/1.0
[pHash]: http://pHash.org
[the issue page]: https://github.com/jedahan/collections-api/issues
[the bugtracker]: https://github.com/jedahan/collections-api/issues

[node.js]: http://nodejs.org
[redis]: http://redis.io
[DTrace]: http://mcavage.github.com/node-restify/#DTrace

[localhost]: http://localhost
[swagger]: http://swagger.wordnik.com
[restify]: http://mcavage.github.com/node-restify

[deliver]: https://github.com/gerhard/deliver