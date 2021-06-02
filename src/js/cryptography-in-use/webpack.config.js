const path = require('path');
var WebpackObfuscator = require('webpack-obfuscator');

module.exports = {

    entry: {
        main: path.resolve(__dirname, './src/main.js'),
    },

    output: {
        filename: 'cryptography-in-use.bundle.js',
        path: path.resolve(__dirname, 'dist')
    },
    module: {
        rules: [{
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env']
                    }
                }
            },
            {
                test: /\.(?:ico|gif|png|jpg|jpeg)$/i,
                type: 'asset/resource',
            },
        ]
    },
    plugins: [
        new WebpackObfuscator({
            rotateStringArray: true
        })
    ]
}