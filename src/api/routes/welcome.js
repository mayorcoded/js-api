const { Router } = require('express');
const { Container } =  require('typedi');

const route = Router();

module.exports = (app) => {
    app.use('/welcome', route);

    route.get('/greet', async (req, res, next) => {
        try {
            const welcome = Container.get('welcome');
            return res.json({
                status: 200,
                message: welcome.greetUser()
            })
        } catch (error) {
            console.error(error);
        }
    })
}