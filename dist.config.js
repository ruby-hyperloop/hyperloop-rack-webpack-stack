var webpack = require('webpack');
var path = require('path');

var BUILD_DIR = path.resolve(__dirname, 'dist');

var config = {
  entry: ['./client.js', './build/application.js'],
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify('production')
      }
    })
  ],
  output: {
    path: BUILD_DIR,
    filename: 'app.min.js'
  },
  module: {

    loaders: [
          { test: /\.css$/,
            loader: "style-loader!css-loader"
          }
    ]

  }
};

module.exports = config;
