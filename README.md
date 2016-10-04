# critical-path-css-rails [![Code Climate](https://codeclimate.com/github/mudbugmedia/critical-path-css-rails/badges/gpa.svg)](https://codeclimate.com/github/mudbugmedia/critical-path-css-rails)

Only load the CSS you need for the initial viewport in Rails!

This gem give you the ability to load only the CSS you *need* on an initial page view. This gives you blazin' fast rending as there's no initial network call to grab your application's CSS.

This gem assumes that you'll load the rest of the CSS asyncronously. At the moment, the suggested way is to use the [loadcss-rails](https://github.com/michael-misshore/loadcss-rails) gem.

This gem uses [PhantomJS](https://github.com/colszowka/phantomjs-gem) and [Penthouse](https://github.com/pocketjoso/penthouse) to generate the critical CSS.


## Installation

Add `critical-path-css-rails` to your Gemfile:

```
gem 'critical-path-css-rails', '~> 0.2.0'
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

* `config/critical_path_css.yml`
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

A simple example using loadcss-rails looks like:

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


## Versions

The critical-path-css-rails gem follows these version guidelines:

```
patch version bump = updates to critical-path-css-rails and patch-level updates to Penthouse and PhantomJS
minor version bump = minor-level updates to critical-path-css-rails, Penthouse, and PhantomJS
major version bump = major-level updates to critical-path-css-rails, Penthouse, PhantomJS, and updates to Rails which may be backwards-incompatible
```

## Contributing

Feel free to open an issue ticket if you find something that could be improved. A couple notes:

* If the Penthouse.js script is outdated (i.e. maybe a new version of Penthouse.js was released yesterday), feel free to open an issue and prod us to get that thing updated. However, for security reasons, we won't be accepting pull requests with updated Penthouse.js script.

Copyright Mudbug Media and Michael Misshore, released under the MIT License.