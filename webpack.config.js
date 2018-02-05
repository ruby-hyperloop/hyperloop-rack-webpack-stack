// when run webpack command, will search this file as default config.

var webpack = require('webpack');
var path = require('path');

var config = {
    entry: ['./client.js'],
    output: {
        path: path.resolve(__dirname, 'build'),
        filename: 'bundle.js'
    },
    module: {
        loaders: [
            {
                test: /\.css$/,
                loader: 'style-loader!css-loader'
            }
        ]
    }
};

module.exports = config;
