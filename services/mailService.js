const nodemailer = require("nodemailer");
require("dotenv").config();

const transporter = nodemailer.createTransport({
  host: "smtp.zoho.com",
  port: 465,
  secure: true, // Use `true` for port 465, `false` for all other ports
  auth: {
    user: process.env.ZOHO_USER,
    pass: process.env.ZOHO_PASS,
  },
});

const sendMail = (email, otp) => {
  var mail = {
    from: '"SecureNet VPN" <securenetvpn@zohomail.com>',
    to: email,
    subject: "One Time Password Verification",
    text: `Your one time password is ${otp}
          傻逼`,
  };

  transporter.sendMail(mail, function (error, info) {
    if (error) {
      console.log(error);
    } else {
      console.log("Email sent: " + info.response);
    }
  });
};

module.exports.sendMail = sendMail;
