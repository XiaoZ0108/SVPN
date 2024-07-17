const mongoose = require("mongoose");

const tempUserSchema = new mongoose.Schema({
  _id: { type: String, required: true },
  pass: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("TempUser", tempUserSchema);
