const { environment } = require('@rails/webpacker');

environment.loaders.append('gql', {
  test: /\.(graphql|gql)$/,
  exclude: /node_modules/,
  loader: 'graphql-tag/loader'
})
module.exports = environment
