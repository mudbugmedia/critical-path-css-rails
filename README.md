# critical-path-css-rails [![Code Climate](https://codeclimate.com/github/mudbugmedia/critical-path-css-rails/badges/gpa.svg)](https://codeclimate.com/github/mudbugmedia/critical-path-css-rails)

Only load the CSS you need for the initial viewport in Rails!

This gem gives you the ability to load only the CSS you *need* on an initial page view. This gives you blazin' fast rending as there's no initial network call to grab your application's CSS.

This gem assumes that you'll load the rest of the CSS asyncronously. At the moment, the suggested way is to use the [loadcss-rails](https://github.com/michael-misshore/loadcss-rails) gem.

This gem uses [Penthouse](https://github.com/pocketjoso/penthouse) to generate the critical CSS.

## Dependency Requirements for / Upgrading to the Latest Release

### For 1.0.0 or later
To maintain the latest version of Penthouse, this gem depends on NodeJS and NVM to be installed on the system.

### For 2.0.0 or later
This gem may require additional packages to be installed to run Chrome headless. Per the Penthouse documentation, this may be all you need:

```
sudo apt-get install libnss3
```

However, more packages may need to be installed depending on your OS distribution which can be found via [this answer](https://github.com/GoogleChrome/puppeteer/issues/404#issuecomment-323555784)

## Installation

After reviewing the dependency requirements, add `critical-path-css-rails` to your Gemfile:

```
gem 'critical-path-css-rails', '~> 2.10.0'
```

Download and install by running:

```
bundle install
```

Run the generator to install the rake task and configuration file:

```
rails generate critical_path_css:install
```

The generator adds the following files:

* `config/critical_path_css.yml` **Note:** This file supports ERB.
* `lib/tasks/critical_path_css.rake`


## Usage

First, you'll need to configue a few things in the YAML file: `config/critical_path_css.yml`

* `manifest_name`: If you're using the asset pipeline, add the manifest name.
* `css_path`: If you're not using the asset pipeline, you'll need to define the path to the application's main CSS. The gem assumes your CSS lives in `RAILS_ROOT/public`. If your main CSS file is in `RAILS_ROOT/public/assets/main.css`, you would set the variable to `/assets/main.css`.
* `routes`: List the routes that you would like to generate the critical CSS for. (i.e. /resources, /resources/show/1, etc.)
* `base_url`: Add your application's URL for the necessary environments.


Before generating the CSS, ensure that your application is running (viewable from a browser) and the main CSS file exists. Then in a separate tab, run the rake task to generate the critical CSS.

If you are using the Asset Pipeline, precompiling the assets will generate the critical CSS after the assets are precompiled.
```
rake assets:precompile
```
Else you can generate the critical CSS manually using the below task:
```
rake critical_path_css:generate
```


To load the generated critical CSS into your layout, in the head tag, insert:

```HTML+ERB
<style>
    <%= CriticalPathCss.fetch(request.path) %>
</style>
```

A simple example using [loadcss-rails](https://github.com/michael-misshore/loadcss-rails) looks like:

```HTML+ERB
<style>
  <%= CriticalPathCss.fetch(request.path) %>
</style>
<script>
    loadCSS("<%= stylesheet_path('application') %>");
</script>
<link rel="preload" href="<%= stylesheet_path('application') %>" as="style" onload="this.rel='stylesheet'">
<noscript>
    <link rel="stylesheet" href="<%= stylesheet_path('application') %>">
</noscript>
```

### Route-level Control of CSS Generation and Removal

CriticalPathCss exposes some methods to give the user more control over the generation of Critical CSS and managment of the CSS cache:

``` ruby
CriticalPathCss.generate route         # Generates the critical path CSS for the given route (relative path)

CriticalPathCss.generate_all           # Generates critical CSS for all routes in critical_path_css.yml

CriticalPathCss.clear route            # Removes the CSS for the given route from the cache

CriticalPathCss.clear_matched routes   # Removes the CSS for the matched routes from the cache
```

NOTE: The `clear_matched` method will not work with Memcached due to the latter's incompatibility with Rails' `delete_matched` method.  We recommend using an alternative cache such as [Redis](https://github.com/redis-store/redis-rails).

In addition to the `critical_path_css:generate` rake task described above, you also have access to task which clears the CSS cache:

```
rake critical_path_css:clear_all
```
NOTE: The `critical_path_css:clear_all` rake task may need to be customized to suit your particular cache implementation.

Careful use of these methods allows the developer to generate critical path CSS dynamically within the app.  The user should strongly consider using a [background job](http://edgeguides.rubyonrails.org/active_job_basics.html) when generating CSS in order to avoid tying up a rails thread.  The `generate` method will send a GET request to your server which could cause infinite recursion if the developer is not careful.

A user can use these methods to [dynamically generate critical path CSS](https://gist.github.com/taranda/1597e97ccf24c978b59aef9249666c77) without using the `rake critical_path_css:generate` rake task and without hardcoding the application's routes into `config/critical_path_css.yml`.  See [this Gist](https://gist.github.com/taranda/1597e97ccf24c978b59aef9249666c77) for an example of such an implementation.

## Upgrading from a version earlier than 0.3.0

The latest version of Critcal Path CSS Rails changes the functionality of the `generate` method.  In past versions,
`generate` would produce CSS for all of the routes listed in `config/critical_path_css.yml`.  This functionality has been replaced by the `generate_all` method, and `generate` will only produce CSS for one route.

Developers upgrading from versions prior to 0.3.0 will need to replace `CriticalPathCss:generate` with `CriticalPathCss:generate_all` throughout their codebase.  One file that will need updating is `lib/tasks/critical_path_css.rake`.  Users can upgrade this file automatically by running:

``` prompt
rails generate critical_path_css:install
```

Answer 'Y' when prompted to overwrite `critical_path_css.rake`.  However, overwriting `critical_path_css.yml` is not recommended nor necessary.


## Testing / Development

This gem is to be tested inside of docker/docker-compose. [Combustion](https://github.com/pat/combustion), alongside rspec-rails and capybara, are the primary components for testing. To run the test, you'll need to have [Docker](https://docs.docker.com/engine/installation) installed. Once installed, run the following commands in the gem's root to build, run, and shell into the docker container.

```Bash
  docker-compose build
  docker-compose up -d
  docker exec -it $(cat app_container_name) /bin/bash
```

Once shell'd in, run `bundle exec rspec spec` to run the test. The test rails app lives in `spec/internal`, and it can be viewed locally at `http://localhost:9292/`


## Versions

The critical-path-css-rails gem follows these version guidelines:

```
patch version bump = updates to critical-path-css-rails and patch-level updates to Penthouse
minor version bump = minor-level updates to critical-path-css-rails and Penthouse
major version bump = major-level updates to critical-path-css-rails, Penthouse, and updates to Rails which may be backwards-incompatible
```

## Contributing

Feel free to open an issue ticket if you find something that could be improved.

Copyright Mudbug Media and Michael Misshore, released under the MIT License.
