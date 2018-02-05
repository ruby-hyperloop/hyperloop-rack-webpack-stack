# Hyperloop, Rack, Opal Sprockets, NPM and Webpack stack

The goal of this tutorial is to outline the setup steps required to build a **Rack** + **Opal Sprockets** + **Hyperloop** hot-reloading stack with all front-end JavaScript assets installed with **NPM** and packaged with **Webpack**.

This stack is perfect for building a single-page, server-less application or a Website.

## Motivation

A Ruby based development environment which is as good as Node.js and Webpack-dev-server.

+ **Development environment** - a fast, modern, development stack for building Opal based code (including Hyperloop) with a re-build on every page refresh and hot reloading. JavaScript assets via NPM and Webpack.
+ **Production build** - a minimized production application consisting of just two files.

> This tutorial is designed for Ruby-Hyperloop, but will work just as well for any Opal based framework or for a native Opal app. To remove Hyperloop just ignore the Hyperloop specific sections.

### Development environment

Rack + Opal Sprockets == Node.js + Webpack-dev-server

+ Rack as a simple, fast webserver
+ Opal Sprockets for compiling Opal code
+ OpalHotReloader for live loading and rebuilding CSS and Opal code
+ NPM and Webpack for JavaScript modules
+ Hyperloop installed as an NPM module
+ Webpack for packaging and for minifying the production build

### Production build

The production output consists of just two files which can be hosted on any webserver (or just run locally in a browser)

+ `index.html` - minimal html rendering just one `div` where the application is loaded into
+ `app.min.js` - all JavaScript libraries, the compiled application code and all CSS

The final application build (which includes all of Hyperloop, Opal JQuery and Opal Core Extensions) is just **185kb** gzipped.

## Setup

Please ensure you have NPM installed https://www.npmjs.com/get-npm (if you are using OSX, consider installing with Brew https://www.npmjs.com/package/homebrew as it works very well).

Next we will install a global version of Webpack so we can access it from the command line:

```
$ npm install webpack -g
```
Check that both NPM and Webpack are installed:

```
$ npm -v
5.4.2

$ webpack -v
3.5.6
```

Add webpack installed location into `$NODE_PATH`, if you are using OSX or linux, just add global
node_modules directory into $NODE_PATH in your's $HOME/.bashrc, following is a example:

```sh
echo 'export NODE_PATH=$NODE_PATH:/home/zw963/utils/node/lib/node_modules' >> ~/.bashrc
```

Next we will use NPM to install our JavaScript libraries:

```
$ npm install ruby-hyperloop --save
```

After a considerable amount of downloading, you will find you now have a `node_modules` folder which contains all the JS libraries that Webpack will use. This folder is Git ignored. The packages you install are recorded in the package.json file.

Finally we will install the Gems:

```
$ bundle install
```

All done. Everything should be installed and we are ready to start up the development environment.

## Try it out

First we need to build our static assets:

```
$ rake build
```

Then start the webserver:

```
$ foreman start
```

And navigate to `http://localhost:9292/`

To test the hot-reloading, make a change to the sample component in `app/components/hello_world.rb` and you should see your changes live in your browser. If so then everything is working. Hooray!

## Development environment

This next section details all the important aspects of the development environment.

**Summary of how it works:**

+ Webpack packages the NPM modules required in `client.js` and builds `build/bundle.js`
+ When a page is requested from Rack, Opal Sprockets compiles the missing JavaScript files (`application.js`, `opal.js` and `reload.js`)
+ OpalHotReloader watches for changes to the Ruby code and CSS in the `app` folder and recompiles when needed

### Installing Gems and JavaScript libraries

Gems are specified in the `Gemfile` and JavaScript libraries in `package.json`.

The concepts are synonymous:

+ `Gemfile` - specifies all the Gems you want installed and `bundle install` gets all the Gems you have specified in your Gemfile
+ `package.json` - specifies all the JS libraries you want installed and `npm install` gets all the JS libraries you have specified in your package.json

Node modules (JavaScript libraries) are downloaded from https://www.npmjs.com/ and stored in your `node_modules` folder.

This folder should be `gitignore`d and never included in your project. Webpack uses the contents of this folder to package the functions the application requires.

To add a new NPM module, you can type `npm add LIB-NAME --save` or simply modify your package.json.

The steps above simply download the source of the Gem or JS library to your computer. To include them in the build process you will need to also follow the steps below.

### Compiling Ruby code

Any source that you `require` in `application.js.rb` will be compiled into JavaScript by Opal. If you `require` a component that `require`s other components they will be compiled as well. Keep an eye on the size of the output file `build/application.js` as it can become large if you are not careful. Ensure that you only `require` what you need.

Notice how `app/application.js.rb` includes the contents of folders with `require_tree './folder_name'`. This allows you to structure your source code nicely as we have done with `components` and `stores`.

```ruby
# app/application.js.rb
require_tree './components'
require_tree './stores'
```

As we are building a Hyperloop single-page application, we only want this library to render our top-level Component into the div with ID `#site` (found in `index.html`) when the page is fully loaded.

```ruby
# app/application.js.rb
Document.ready? do
  Element['#site'].render{ HelloWorld() }
end
```

See the `build` task in the `Rakefile`. You will notice that we are compiling `application.js` and `reload.js` separately so we can include just the code we need in the final build. You can use this pattern to compile any Opal code into a JavaScript output file.

```ruby
# Rakefile
File.binwrite 'build/application.js', Opal::Builder.build('application').to_s
```

### Requiring JavaScript libraries

Once you have downloaded a JavaScript library via NPM you will need to tell Webpack that you `require` it in your output package. This step is necessary to include the library in your project.

In `webpack.config.js` we specify that there is just one input file `client.js` and one output file `build/bundle.js`:

```javascript
// webpack.config.js
entry: ['./client.js'],
output: {
  path: BUILD_DIR,
  filename: 'bundle.js'
},
```

In `client.js` we `require` the JavaScript libraries we want. For example, to include the Hyperloop code:

```javascript
// client.js
require('ruby-hyperloop/hyperloop');
```

Any library you add through NPM must be required in this way. Keep an eye on the size of `build/bundle.js` as this can quickly become very large indeed. Only `require` what you need.

To package our JavaScript libraries we run `webpack` which will read its configuration from `webpack.config.js` by default.

```
$ webpack
```

Note that this step is preformed in our `build` rake task. (`sh 'webpack --progress'`).

### CSS

CSS will come into your project from two sources: CSS you add in the `app/css` folder and CSS from JavaScript libraries you add through Webpack.

To add a new CSS file:

+ Create the file in `app/css`
+ Add it to `app/index.html.erb` (we only need it gere for development)
+ Require it in `client.js` - this will ensure that Webpack will package it properly for your distribution build

```javascript
// client.js
require('./app/css/application.css');
```

### index.html.erb

In the previous sections, we have seen how we build our Opal code how Webpack packages the NPM modules. All of these files are brought together in `index.html.erb` which is only used for development. In production we have a different `index.html` as all the JavaScript libs are packaged.

Take a look at `index.html.erb`', it's javascript consists of three parts:

1. CDN versions of javascript, the purpose is to keep the final output as small as possible. [link](/app/index.html.erb#L7-L9)
2. Javscripts used only for development and HotLoading working. [link](/app/index.html.erb#L12) [link](/app/index.html.erb#L15) [link](/app/index.html.erb#L20)
3. Javascipts need bundled into final output js for your distribution build. [link](/app/index.html.erb#L17)

 ### OpalHotReloader

OpalHotReloader has a server component which watches for changes and re-compiles code and a client component which dynamically reloads the JavaScript.

The client code comes in through `reload.js` and the server process is started by Foreman.

### Rack

We are using Rack as the webserver which is configured in `config.ru`:

```ruby
# config.ru
run Opal::Server.new { |server|
  server.main = 'application'
  server.append_path 'app'
  server.index_path = './app/index.html.erb'
}
```

When we start Rack we also need to start the `opal-hot-reloader` process so we specify this in `Procfile`

```ruby
# Procfile
rackup: bundle exec rackup
hotloader: bundle exec opal-hot-reloader -p 25222 -d app
```

Foreman reads `Procfile` and allows us to start both processes with:

```
$ foreman start
```

## Production build

The production process differs from the development environment in that we combine the Opal built and Webpack packaged JS libraries and all CSS into one file `app.min.js`.

Additionally we use Webpack to minimise and uglify the output JavaScript.

To build the production version run the Rake task:

```
$ rake dist
```

That's it. Two files - `index.html`, `app.min.js` make up the whole application which includes all of Hyperloop, Opal JQuery and Opal Core Extensions and is just **185kb** gzipped.

### How it works

The `dist` rake task simply runs Webpack with different options:

```ruby
# Rakefile
webpack --config=dist.config.js --progress -p
```

The `-p` flag instructs Webpack we are building the production version so it will automatically optomize our output. The `--config` flag specifies the config file to use.

The key difference with this config over the development config is that we have two input files. These two files will be combined into one output.

```javascript
// dist.config.js
entry: ['./client.js', './build/application.js'],
```

And of course we specify a different output file and folder:

```javascript
// dist.config.js
var BUILD_DIR = path.resolve(__dirname, 'dist');

output: {
  path: BUILD_DIR,
  filename: 'app.min.js'
},
```
