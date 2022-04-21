# Scrapbook
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "scrapbook"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install scrapbook
```

## Contributing
Contribution directions go here.

### Install TailwindCSS CLI
If you need to submit updates to the theme
Follow [the instructions to install the CLI](https://tailwindcss.com/docs/installation).

$> npm install -D @tailwindcss/forms
$> npm install -D @tailwindcss/aspect-ratio
$> npm install -D @tailwindcss/typography

npx tailwindcss -i app/assets/stylesheets/scrapbook/application.tailwind.css -o app/assets/builds/scrapbook/tailwind.css --minify --watch

Why not use the "tailwindcss-rails" gem? Not supported for engines.

### Notes
Don't include Tailwind's preflight CSS with their reset so that we can separate the reset from our class styles. (This allows us to do the reset first, user styles second, and our styles last.)
To generate just the reset, run:
npx tailwindcss -c tailwind-preflight-reset.config.js -i app/assets/stylesheets/scrapbook/application.tailwind_preflight_reset.css -o app/assets/builds/scrapbook/tailwind_preflight_reset.css --minify

## License

Copyright 2022 Brad Lindsay

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
