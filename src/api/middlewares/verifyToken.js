"use strict";

const jwt = require("jsonwebtoken");
const fs = require("fs");
const privateKEY  = fs.readFileSync('./private.key', 'utf8');


const verifyToken = (req, res, next) => {
  const header = req.headers["authorization"];

  if (typeof header !== "undefined") {
    const bearer = header.split(" ");
    const token = bearer[1];

    req.token = token;
    jwt.verify(token, privateKEY, function(err, decoded) {
      if (err) {
        return res
          .status(500)
          .json({ 
              error: {
                status: 500,
                code: "AUTH_02",
                message: err.message,
                field: "bearer token header"
              }
            });
      }
      req.decoded = decoded;
      next();
    });
  } else {
    //If header is undefined return Forbidden (403)
    res.status(403).json({
      error: {
            status: 403,
            code: "AUTH_01",
            message: "Unauthorized Access, undefined hearder. Please log in.",
            field: "bearer token header"
        }
    });
  }
};

module.exports = verifyToken;
