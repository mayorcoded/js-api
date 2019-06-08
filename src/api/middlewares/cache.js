"use strict";
const { Container } =  require('typedi');

let cacheMiddleware = (req, res, next) => {
  const cache = Container.get('cache'); 
  let key = "__express__" + req.originalUrl || req.url;
  let cacheContent = cache.getKey(key);

  if (cacheContent) {
    res.send(cacheContent);
  } else {
    res.sendResponse = res.send;
    res.send = body => {
      cache.setKey(key, body);
      cache.save();
      res.sendResponse(body);
    };
    next();
  }
};

module.exports = cacheMiddleware;
