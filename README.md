# Rack, Opal Sprockets, NPM and Webpack stack tutorial

The goal of this tutorial is to outline the setup steps required to build a Rack + Opal Sprockets stack with all front-end JavaScript assets being brought in through NPM and packaged with Webpack.

## Motivation

+ Fast, modern, development stack for building Opal based code (including Hyperloop)
+ Minimal production application consisting of just three files (index.html, app.js and app.css)

### Development environment

+ Rack as a simple webserver
+ Opal Sprockets for compiling your Opal code
+ OpalHotReloader for live loading and rebuilding CSS and Opal code
+ NPM for JavaScript package management
+ Webpack for packaging and for minifying the production build

### Production environment

The production output consists of just three files which can be hosted on any webserver (or just run locally in a browser)

+ `index.html` - minimal html rendering just one `DIV` where the application is loaded into
+ `app.min.js` - all JavaScript libraries including your code and Opal
+ `app.min.css` - all CSS taken from the JS libraries

## Setup

Please ensure you have NPM installed https://www.npmjs.com/get-npm (if you are using OSX, consider installing with Brew https://www.npmjs.com/package/homebrew as it works very well).

Next we will install a global version of Webpack

```
npm install webpack -g
```
Check that both NPM and Webpack are installed:

```
$ npm -v
5.4.2

$ webpack -v
3.5.6
```

Next we will use NPM to install our JavaScript libraries:

```
npm install react react-dom ruby-hyperloop --save
```

After a considerable amount of downloading, you will find you now have a `node_modules` folder which contains all the JS libraries that Webpack will use. Note that this folder is Git ignored and downloaded when needed.

> This project has a package.json file so we could have just typed `npm install` to install the libraries detailed there. To create a package.json file just type `npm init` and follow the prompts.

Now we will have Webpack to package our JavaScript libraries. The details of how this works will follow later in this tutorial.

```
webpack
```

Finally we will install the Gems:

```
bundle install
```

All done. Everything should be installed and we should be ready to standup the development environment.

## Development environment

### Usage

We are using Foreman to start Rack and the OpalHotReloader process.

```
foreman start
```

Navigate to:

```
localhost:5000
```

### How it works

#### Summary

+ You write your code and add Gems and JavaScript libraries to your project
+ Opal compiles the Ruby code found in `app.js.rb` and generates `build/application.js`
+ Webpack packages the NPM libraries required in `index.js` and builds `build/package.js`
+ Our development version of `index.html` loads both of these JS libraries and launches our application

#### Details

##### Installing Gems and JavaScript libraries

Your Gemfile and package.json are synonymous:

Ruby Gems:

`Gemfile` - specify all the Gems you want installed
`bundle install` - gets all the Gems you have specified in your Gemfile

Gems are downloaded from Ruby Gems: https://rubygems.org/

JavaScript libraries:

`package.json` - specify all the JS libraries you want installed
`npm install` - gets all the JS libraries you have specified in your package.json

Node modles are downloaded from NPM https://www.npmjs.com/

> To add a new NPM module, you can type `npm add LIB-NAME --save` or simply modify your package.json.

The steps above simply download the source of the Gem or JS library to your computer. To include them in the build process you will need to also follow the steps below.

##### Ruby code
