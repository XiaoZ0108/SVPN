const { generateOtp } = require("../services/otpService.js");
const { sendMail } = require("../services/mailService.js");
const {
  saveRegisOTP,
  validateEmailOTP,
  getUserFromTemp,
  removeUserFromTemp,
  removeOtpFromTemp,
} = require("../services/regisOtpService.js");
const {
  storeUser,
  retrieveUser,
  checkExist,
  resetPass,
} = require("../services/userService.js");
const { generateToken, validateToken } = require("../services/authService.js");

exports.userRegister = async (req, res) => {
  const { email, password } = req.body;
  try {
    const isExist = await checkExist(email);
    if (isExist) {
      return res.status(409).json({
        message: "Email have been registered",
      });
    }

    await Promise.all([removeOtpFromTemp(email), removeUserFromTemp(email)]);

    let otp = generateOtp();
    await saveRegisOTP(email, otp, password); //store 2 temp db

    sendMail(email, otp);
    res.status(200).json({
      message: "Registration initiated, please check your email for OTP",
    });
  } catch (error) {
    console.error("Error during registration:", error);
    res.status(500).json({
      message: "An error occurred during registration. Please try again.",
    });
  }
};

exports.userRegisValidate = async (req, res) => {
  const { email, otp } = req.body;
  try {
    const isValid = await validateEmailOTP(email, otp);
    if (isValid) {
      const user = await getUserFromTemp(email);
      if (user) {
        await storeUser(user._id, user.pass);
        await Promise.all([
          removeUserFromTemp(email),
          removeOtpFromTemp(email),
        ]);
        return res.status(200).json({ message: "Registration successful" });
      }
    }
    res.status(400).json({ message: "Invalid OTP" });
  } catch (error) {
    console.error("Error during OTP validation:", error);
    res.status(500).json({
      message: "An error occurred during OTP validation. Please try again.",
    });
  }
};

exports.userLogin = async (req, res) => {
  const { email, password } = req.body;
  const user = await retrieveUser(email, password);

  if (user) {
    //send jwt
    const token = generateToken(user._id, user.premium);
    return res.status(200).json({ message: "Login Success", token });
  } else if (user == false) {
    return res.status(401).json({ message: "Password Error" }); //invalid wrong password or email
  }
  //if null
  return res.status(404).json({ message: "Email Not registred" }); //not registere before
};

exports.checktoken = (req, res) => {
  const token = req.headers.authorization?.split(" ")[1];
  return res.json(validateToken(token));
};

exports.resendMail = async (req, res) => {
  const { email } = req.query;
  try {
    await removeOtpFromTemp(email);
    let otp = generateOtp();
    await saveRegisOTP(email, otp);
    sendMail(email, otp);
    return res.status(200).json({
      message: `Resended to ${email}`,
    });
  } catch (err) {
    return res.status(500).json({
      message: "An error occurred during resend. Please try again.",
    });
  }
};

//reset pass //inuput email ,check exist,send otp,validate otp ,input password //reset password

exports.checkMail = async (req, res) => {
  const { email } = req.query;
  try {
    const isExist = await checkExist(email);
    if (isExist) {
      await Promise.all([removeUserFromTemp(email), removeOtpFromTemp(email)]);
      let otp = generateOtp();
      await saveRegisOTP(email, otp);
      sendMail(email, otp);
      return res.status(200).json({
        message: "ok",
      });
    } else {
      return res.status(409).json({
        message: "Email not registered",
      });
    }
  } catch (err) {
    return res.status(500).json({
      message: "An error occurred while checking the email. Please try again.",
    });
  }
};

exports.checkOtp = async (req, res) => {
  const { email, otp } = req.body;
  try {
    const isValid = await validateEmailOTP(email, otp);
    if (isValid) {
      await Promise.all([removeOtpFromTemp(email)]);
      res.status(200).json({
        message: "Validate Successful",
      });
    } else {
      res.status(400).json({
        message: "Invalid OTP",
      });
    }
  } catch (err) {
    res.status(500).json({
      message: "An error occurred during validation. Please try again.",
    });
  }
};
exports.resetPass = async (req, res) => {
  const { email, password } = req.body;
  try {
    const isReset = await resetPass(email, password);
    if (isReset) {
      return res.status(200).json({
        message: `Reset Successful`,
      });
    } else {
      return res.status(400).json({
        message: "An error occurred during reset. Please try again.",
      });
    }
  } catch (err) {
    return res.status(500).json({
      message: "An error occurred during reset. Please try again.",
    });
  }
};

exports.goPremium = async (req, res) => {
  const token = req.headers.authorization?.split(" ")[1];
  try {
    const user = await validateToken(token);
    if (!user) {
      return res.status(401).json({ message: "invalid Token" });
    }
    user.premium = true;
    user.save();
    const newtoken = generateToken(user._id, user.premium);
    res.status(200).json({ message: "Upgrade Successfull", newtoken });
  } catch (err) {
    return res.status(500).json({
      message: "An error occurred during Upgrade. Please try again.",
    });
  }
};
