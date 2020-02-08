module.exports = {
  devServer: {
    host: 'localhost'
  },
  chainWebpack: config => {
    // GraphQL Loader
    config.module
      .rule('coffee')
      .test(/\.coffee$/)
      // Add another loader
      .use('babel-loader')
      .loader('babel-loader')
      .end()
      .use('cofee-loader')
      .loader('coffee-loader')
      .end()
  }
}