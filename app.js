const express = require("express");
const https = require("https");
const fs = require("fs");
const path = require("path");
const { executeFirstScript, readOvpnFile } = require("./services.js");
const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.post("/getConfig", async (req, res) => {
  const { clientName } = req.body;
  try {
    if (!clientName) {
      return res.status(400).json({ message: "Client name is required" });
    }
    await executeFirstScript(clientName);
    const configFile = readOvpnFile(clientName);
    if (configFile) {
      res
        .status(200)
        .json({ message: "successfull generated", config: configFile });
    }
  } catch (err) {
    res.status(500).json({ message: "Internal server error" });
  }
});

app.get("/readConfig", (req, res) => {
  const { clientName } = req.query;
  try {
    if (!clientName) {
      return res.status(400).json({ message: "Client name is required" });
    }
    const configFile = readOvpnFile(clientName);
    if (configFile) {
      res.status(200).json({ message: "successfull Read", config: configFile });
    }
  } catch (err) {
    res.status(500).json({ message: "Internal server error" });
  }
});

// Serve application over HTTPS
//provide cert using certbot
const options = {
  key: fs.readFileSync(
    "/etc/letsencrypt/live/www.magicconchxhell.xyz/privkey.pem"
  ),
  cert: fs.readFileSync(
    "/etc/letsencrypt/live/www.magicconchxhell.xyz/fullchain.pem"
  ),
};

// Example route
app.get("/", (req, res) => {
  res.send("Hello");
});

// Create HTTPS server
https.createServer(options, app).listen(443, () => {
  console.log("Secure server running on https://your-domain.com");
});

// Optional: Redirect HTTP to HTTPS
const http = require("http");

const httpApp = express();
httpApp.use((req, res, next) => {
  if (req.secure) {
    return next();
  }
  res.redirect(`https://${req.headers.host}${req.url}`);
});

http.createServer(httpApp).listen(80, () => {
  console.log("Redirecting HTTP to HTTPS");
});
