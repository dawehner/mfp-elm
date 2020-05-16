const webpack = require('webpack')
const path = require('path')
const CopyPlugin = require('copy-webpack-plugin');


module.exports = {
  module: {
    rules: [
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file-loader?name=[name].[ext]'
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          { loader: 'elm-hot-webpack-loader' },
          {
            loader: 'elm-webpack-loader',
            options: {
              cwd: __dirname,
              debug: false
            }
          }
        ]
      }]
  },

  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new CopyPlugin({
      patterns: [
        { from: 'public/music.json', to: 'music.json' },
      ],
    }),
  ],

  devServer: {
    inline: true,
    hot: true,
    stats: 'errors-only',
    contentBase: path.join(__dirname, 'public')
  }
};