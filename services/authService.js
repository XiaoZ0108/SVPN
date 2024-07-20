const jwt = require("jsonwebtoken");
require("dotenv").config();
const User = require("../models/user.js");

const generateToken = (userId, userPremium) => {
  const token = jwt.sign(
    { userId: userId, premium: userPremium },
    process.env.JWTSECRET,
    {
      algorithm: "HS256",
      expiresIn: "7D",
    }
  );

  return token;
};

const validateToken = async (token) => {
  try {
    const decoded = jwt.verify(token, process.env.JWTSECRET);
    const user = await User.findById(decoded.userId);
    return user;
  } catch (err) {
    return null;
  }
};

const authMiddleware = async (req, res, next) => {
  const token = req.header("Authorization").replace("Bearer ", "");
  if (!token) {
    return res.status(401).send("Access denied. No token provided.");
  }

  try {
    const decoded = jwt.verify(token, process.env.JWTSECRET);
    req.user = await User.findById(decoded.userId);
    if (!req.user) {
      return res.status(401).send("Invalid token.");
    }

    next();
  } catch (ex) {
    res.status(400).send("Invalid token.");
  }
};

module.exports = { generateToken, validateToken, authMiddleware };
