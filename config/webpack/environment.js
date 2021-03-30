const { environment } = require('@rails/webpacker')
const typescript =  require('./loaders/typescript')

environment.loaders.append('html', {
    test: /\.html$/,
    exclude: /node_modules/,
    loaders: ['html-loader']
})


environment.loaders.prepend('typescript', typescript)
module.exports = environment
