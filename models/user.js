const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  _id: { type: String, required: true },
  pass: { type: String, required: true },
  premium: { type: Boolean, default: false },
  dailyUsageSeconds: { type: Number, default: 0 },
  ConnectTime: { type: Date, default: null },
  DisconnectTime: { type: Date, default: null },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("User", userSchema);
