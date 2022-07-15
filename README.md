# Scrapbook

Scrapbook allows you to create a heirarchal set of view templates that can run code from
your Rails application without the need to create a route or controller for each template.
All you need to do is install and configure Scrapbook, and then you can add folders and
template files to your heart's content.

Scrapbook started life wanting to be able to test out Rails helper methods and showcase
their behavior. These helper methods called more complex Ruby classes to create a set of
rich components, and we needed a way to showcase these components and their capabilites.
I decided to create a more general application that could allow us to generate and organize
any view templates that our Rails application knew how to process. Scrapbook is the result.
Along the way, we discovered that not only was it a great place to document our components,
but it was also great for doing the initial development as well.


## Installation

Add `scrapbook` to the `:development` group of your application's Gemfile:

```ruby
group :development do
  gem 'scrapbook'
end
```

And then execute:

```bash
$> bundle install
$> bundle exec rails generate scrapbook:install
```

This will install the gem and setup the default Scrapbook route and create the default
scrapbook directory structure at the root of your Rails application.

## Usage

A scrapbook folder needs to contain a "pages" sub-folder. Any files and folders created in
that "pages" folder will be exposed as part of the scrapbook unless their name begins with a
period. These files and folders will show up as navigatable in Scrapbook's file browser, and
if the file is a template file whose engine your main Rails application has installed, it
will be properly processed to generate the HTML for you to view. These templates have access
to all the helper methods defined in your main Rails application.

When a folder is selected in Scrapbook's file browser, by default a small message appears in
the main display area describing how to customize what is displayed when a folder is
selected. In short, you need to create a template file with the same base name as the folder
in the same directory as the folder. So if you had a folder at "scrapbook/pages/scratch",
then you would need to create a file named something like "scrapbook/pages/scratch.html.erb"
with the custom display you want to see when you click on the "scratch" folder in the file
browser. This also works for the main screen you see at the base scrapbook URL. You can
customize that screen by creating a "pages.html" template file in the root scrapbook folder.
(The default installation creates a "pages.html.erb" template file for the basic welcome
message.)

To view a scrapbook, navigate to its base URL. The default scarpbook can always be accessed
at the mountpoint setup in the routes file (this is "/scrapbook" by default). The base URL
for other scrapbooks is that path followed by the name of the scrapbook's root folder (the
folder that contains the "pages" folder). By default, only one scrapbook is configured and
it's name is "scrapbook" which means that both "/scrapbook" and "/scrapbook/scrapbook" point
to the same scrapbook root page.

## Configuration

You can configure the path that Scrapbook runs on in your "config/routes.rb" file. The
default configuration is to mount Scrapbook on "/scrapbook", but you can use whatever
path you want: `mount Scrapbook::Engine => "/scrappy"`.

You can configure one or more folders to be separate root scrapbooks via the
`config.scrapbook.paths` option. This option defaults to an empty array which allows for
using the shovel operator to add your paths:
    ```ruby
    Rails.application.configure do
      config.scrapbook.paths << Rails.root.join("scrapbooks/main")
      config.scrapbook.paths << Rails.root.join("scrapbooks/scratch")
    end
    ```
If no paths have been added, Scrapbook will use `Rails.root.join('scrapbook')` as the
location it expects the scrapbook to be at. The first folder path in the array is considered
the default scrapbook and will be available at the root mount point configured in the routes
file.

We recommend only running Scrapbook in development / non-production Rails environments.
However, if you find yourself needing to be able to run it in an environment precompiles its
assets, you will need to configure Scrapbook to be part of the precompilation. You can do
this by setting `config.scrapbook.precompile_assets` to "true":
    ```ruby
    Rails.application.configure do
      config.scrapbook.precompile_assets = true
    end
    ```


## Contributing

If you have a question about Scrapbook, feel free to ask in [the repository's Discussions]
[Discussions]. Before starting any work or creating any issues, please read [the
contribution guidelines](CONTRIBUTING.md).

## Development Setup

### Install TailwindCSS CLI

If you need to submit updates to the theme or are using new Tailwind classes, you'll need to
follow [the instructions to install the CLI](https://tailwindcss.com/docs/installation).
After that you'll need to run the following commands to install the plugins:

```
$> npm install -D @tailwindcss/forms
$> npm install -D @tailwindcss/aspect-ratio
$> npm install -D @tailwindcss/typography
```

Once Tailwind's CLI has been installed, you can run it using the command below to update
Scrapbook's CSS:

```
$> npx tailwindcss -i app/assets/stylesheets/scrapbook/application.tailwind.css -o app/assets/builds/scrapbook/tailwind.css --minify --watch
```

(Note, the "tailwindcss-rails" gem currently doesn't support Rails engines, so we have to
install and run Tailwind manually.)

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


[Discussion]: https://github.com/bfad/scrapbook/discussions
