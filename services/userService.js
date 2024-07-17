const User = require("../models/user.js");
const cron = require("node-cron");
async function storeUser(email, password) {
  try {
    const doc = new User({
      _id: email,
      pass: password,
    });

    const result = await doc.save();
    console.log(`A document was inserted with the _id: ${result._id}`);
  } catch (error) {
    console.error("Error inserting:", error);
  }
}

async function retrieveUser(email, password) {
  try {
    const user = await User.findOne({ _id: email });
    if (!user) {
      return null;
    }
    const isPasswordValid = password == user.pass ? true : false;
    return isPasswordValid ? user : false;
  } catch (err) {
    console.log("err");
    return null;
  }
}

async function checkExist(email) {
  try {
    const user = await User.findOne({ _id: email });
    if (!user) {
      return false;
    } else {
      return true;
    }
  } catch (err) {
    return null;
  }
}

async function resetPass(email, pass) {
  try {
    const user = await User.findOne({ _id: email });
    if (!user) {
      return false;
    } else {
      user.pass = pass;
      user.save();
      return true;
    }
  } catch (err) {
    return null;
  }
}

cron.schedule("21 17 * * *", async () => {
  try {
    await User.updateMany({}, { ConnectTime: null });
    console.log("Daily usage seconds reset for all users");
  } catch (error) {
    console.error("Error resetting daily usage seconds:", error);
  }
});
module.exports = { storeUser, retrieveUser, checkExist, resetPass };
