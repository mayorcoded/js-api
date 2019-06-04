const express = require('express');
const config  = require('./config');

async function startServer() {
    const app = express();

    //load up all key middlewares
    const loaders = require('./loaders');
    await loaders(app);

    app.listen(config.port, err => {
        if (err) {
            console.log('################################################')
            console.log(' 🚫🚫 Error occured while trying to start server 🚫🚫', err)
            console.log('################################################')
            process.exit(1);
            return;
        }
        console.log('################################################')
        console.log(' 🛡️  Server listening on port: ', config.port, ' 🛡️ ')
        console.log('################################################')
    })

    return app;
}

startServer();

