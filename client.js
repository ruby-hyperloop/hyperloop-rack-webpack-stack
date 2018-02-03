// Following will ensure that Webpack will package CSS into js properly for your distribution build.
require('./app/css/application.css');

// Any library you add through NPM which want to use in your distribution build must be required in this way.
require('ruby-hyperloop/hyperloop');
