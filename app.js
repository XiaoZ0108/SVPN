const express = require("express");
const mongoose = require("mongoose");
require("dotenv").config();
const userController = require("./controller/userController");
const vpnController = require("./controller/vpnController");
const uri = "mongodb://127.0.0.1:27017/VPN";
const { authMiddleware } = require("./services/authService.js");

mongoose
  .connect(uri)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.error("MongoDB connection error:", err));

const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

//login//register
app.post("/register", userController.userRegister); //initate otp
app.post("/validate", userController.userRegisValidate); //validate and save user
app.post("/login", userController.userLogin); //login check redential send token
app.get("/check", userController.checktoken);

//vpn
app.get("/vpnStatus", vpnController.getCountryPing); //fetch vpn ping and available country
app.get("/vpnConfig", vpnController.getConfig);

//reset
app.get("/validateM", userController.checkMail); //validate email exist and send otp
app.post("/validateO", userController.checkOtp); //validate otp
app.post("/resetPass", userController.resetPass); //reset password

//resend mail
app.get("/resendO", userController.resendMail);
app.get("/goPremium", userController.goPremium);

app.post("/connect", authMiddleware, async (req, res) => {
  const user = req.user;
  const { disconnectTime } = req.body;

  if (!disconnectTime) {
    return res.status(400).send({ error: "Disconnect time is required" });
  }

  const disconnectDate = new Date(parseInt(disconnectTime));
  console.log(disconnectDate.toLocaleString());

  const oneHourInSeconds = 30;
  let remainingTime = oneHourInSeconds;

  if (!user.ConnectTime) {
    user.ConnectTime = new Date();
    user.dailyUsageSeconds = 0;
  } else if (disconnectDate > user.DisconnectTime) {
    const sessionDuration = Math.floor(
      (disconnectDate - user.ConnectTime) / 1000
    );
    console.log(sessionDuration);
    user.dailyUsageSeconds += sessionDuration;
    console.log(user.dailyUsageSeconds);
    if (user.dailyUsageSeconds < oneHourInSeconds) {
      remainingTime = Math.max(oneHourInSeconds - user.dailyUsageSeconds, 0);
      user.ConnectTime = new Date();
      user.DisconnectTime = disconnectDate;
    } else {
      remainingTime = 0;
    }
  } else {
    //same disconnect time
    remainingTime = 0;
  }
  await user.save();
  console.log(remainingTime);
  if (user.premium) {
    return res.status(200).send({ allowed: true, allowedTime: -1 });
  }
  if (remainingTime <= 0) {
    return res.status(200).send({ allowed: false, allowedTime: 0 });
  }

  return res.status(200).send({ allowed: true, allowedTime: remainingTime });
});

app.get("/", (req, res) => {
  res.json({ user: "hi" });
});

const port = process.env.PORT;
app.listen(port, () => {
  console.log(`port ${port}`);
});
