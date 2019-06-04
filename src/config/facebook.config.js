'use strict';
const config = require('.');
const passport = require('passport');
const FacebookTokenStrategy = require('passport-facebook-token');
const { Container } =  require('typedi');


const configure = () => { 
    passport.use('facebook-token', new FacebookTokenStrategy({
        clientID: config.facebook.client_id,
        clientSecret: config.facebook.client_secret,
        fbGraphVersion: 'v3.0',
      },
      async function (accessToken, refreshToken, profile, done) {
        try {
            const customer = {
                'facebook_id': profile.id,
                'name': profile.displayName,
                'email': profile.emails[0].value
            };
            const customerService = Container.get('customerService');
            const result = await customerService.loginCustomerViaFacebook(customer);
            
            return done(null, result); 
        } catch (error) {
            return done(error, null)
        }       
    }));
}

module.exports = configure;