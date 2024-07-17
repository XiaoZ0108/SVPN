const RegisOtp = require("../models/regisOtp.js");
const TempUser = require("../models/tempUser.js");
async function saveRegisOTP(email, otp, pass = "") {
  try {
    const tempOtp = new RegisOtp({
      _id: email,
      otp: otp,
    });
    const result1 = await tempOtp.save();
    console.log(`A tempOtp was inserted with the _id: ${result1._id}`);
    if (pass != "") {
      const tempUser = new TempUser({ _id: email, pass: pass });
      const result2 = await tempUser.save();
      console.log(`A tempUser was inserted with the _id: ${result2._id}`);
    }
  } catch (error) {
    console.error("Error inserting:", error);
  }
}

async function validateEmailOTP(email, otp) {
  try {
    const result = await RegisOtp.findById(email);

    if (result && result.otp == otp) {
      return true;
    }
    return false;
  } catch (error) {
    console.error("Error finding:", error);
    return false;
  }
}

async function getUserFromTemp(email) {
  try {
    const result = await TempUser.findById(email);
    if (result) {
      return { _id: result._id, pass: result.pass };
    }
    return null;
  } catch (error) {
    console.error("Error finding:", error);
    return null;
  }
}

async function removeUserFromTemp(email) {
  try {
    const result = await TempUser.findOneAndDelete(email);
    if (result) {
      return true;
    }
    return null;
  } catch (error) {
    return null;
  }
}

async function removeOtpFromTemp(email) {
  try {
    const result = await RegisOtp.findOneAndDelete(email);
    if (result) {
      return true;
    }
    return null;
  } catch (error) {
    return null;
  }
}

module.exports = {
  saveRegisOTP,
  validateEmailOTP,
  getUserFromTemp,
  removeUserFromTemp,
  removeOtpFromTemp,
};
