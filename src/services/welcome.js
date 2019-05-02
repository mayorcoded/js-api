const {Container} = require('typedi');

class Welcome{
    greetUser() {
        return 'Hey user, welcome to my app';
    }
}

module.exports = Welcome