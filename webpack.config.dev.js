var path = require('path');
var webpack = require('webpack');

module.exports = {
  devtool: 'cheap-module-eval-source-map',
  entry: [
    'webpack-hot-middleware/client',
    './src/index'
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/build/'
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  ],
  module: {
    loaders: [{
      test: /\.js$/,
      loaders: ['babel'],
      include: [path.join(__dirname, 'src')]
    }, {
      test: /\.css$/,
      loader: "style-loader!css-loader!postcss-loader?parser=postcss-scss",
    }, {
      test: /\.scm$/,
      loader: "raw-loader",
    }]
  },
  node: {
    fs: "empty",
    net: "empty",
    // fsevents: "empty"
  }
};
