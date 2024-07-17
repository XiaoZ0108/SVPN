const mongoose = require("mongoose");
const vpnSchema = new mongoose.Schema({
  user: { type: String, required: true },
  country: { type: String, required: true },
  config: { type: String, required: true },
  createdAt: { type: Date, default: Date.now }, // TTL index
});
module.exports = mongoose.model("VPNConfig", vpnSchema);
