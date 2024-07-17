const mongoose = require("mongoose");

const regisOtpSchema = new mongoose.Schema({
  _id: { type: String, required: true },
  otp: { type: String, required: true },
  createdAt: { type: Date, default: Date.now, expires: "5m" }, // TTL index
});

module.exports = mongoose.model("RegisOtp", regisOtpSchema);
