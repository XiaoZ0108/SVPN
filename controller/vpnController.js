require("dotenv").config();
const {
  getPing,
  requestConfig,
  storeConfig,
  retrieveConfig,
} = require("../services/vpnService.js");
const { validateToken } = require("../services/authService.js");
const countries = {
  Singapore: process.env.Singapore,
  Australia: process.env.Australia,
};

exports.getCountryPing = async (req, res) => {
  // const token = req.headers.authorization?.split(" ")[1];
  // const user = validateToken(token);
  // if (!user) {
  //   return res.json({ message: "invalid Token" });
  // }
  const results = { Default: "" };
  const keys = Object.keys(countries);
  for (const key of keys) {
    const url = countries[key];
    const latency = await getPing(url);
    if (latency !== null) {
      results[key] = `${latency} ms`;
      console.log(latency);
    }
  }
  return res.status(200).json(results);
};

//received country and token
exports.getConfig = async (req, res) => {
  const { country } = req.query;
  const token = req.headers.authorization?.split(" ")[1];
  const user = await validateToken(token);
  if (!user) {
    return res.status(401).json({ message: "invalid Token" });
  }
  const result = await retrieveConfig(user.userId, country);

  if (!result) {
    console.log("go");
    const config = await requestConfig(
      countries[country],
      getUsernameFromEmail(user.userId)
    );
    console.log(config);
    await storeConfig(user.userId, country, config);
    return res.status(200).json({ config: config });
  } else {
    console.log(result);
    return res.status(200).json({ config: result });
  }
};
function getUsernameFromEmail(email) {
  const parts = email.split("@");

  return parts.length > 0 ? parts[0] : null;
}
