const axios = require("axios");
var ping = require("ping");
const VPNConfig = require("../models/vpn.js");

const getPing = async (ip) => {
  try {
    const res = await ping.promise.probe(ip);
    if (res.alive) {
      return res.time;
    } else {
      return null;
    }
  } catch (error) {
    return null;
  }
};

const requestConfig = async (url, clientName) => {
  console.log(url, clientName);
  try {
    const response = await axios.post(`https://${url}/getConfig`, {
      clientName: `${clientName}`,
    });
    console.log(response.data.config);
    return response.data.config;
  } catch (error) {
    return null;
  }
};

async function storeConfig(email, country, config) {
  try {
    const doc = new VPNConfig({
      user: email,
      country: country,
      config: config,
    });

    const result = await doc.save();
    console.log(`A document was inserted with the _id: ${result._id}`);
  } catch (error) {
    console.error("Error inserting5:", error);
  }
}

async function retrieveConfig(email, country) {
  try {
    const config = await VPNConfig.findOne({ user: email, country: country });
    if (!config) {
      return null;
    }
    return config.config;
  } catch (err) {
    return null;
  }
}

module.exports = { getPing, requestConfig, storeConfig, retrieveConfig };
