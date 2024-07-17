// const { MongoClient } = require("mongodb");

// const uri = "mongodb://127.0.0.1:27017/";
// const client = new MongoClient(uri);

// async function createTTLIndex() {
//   try {
//     await client.connect();
//     const database = client.db("userOtp");
//     const collections = database.collection("regisOtp");
//     collections.createIndex({ createdAt: 1 }, { expireAfterSeconds: 300 });
//   } catch (error) {
//     console.error("Error creating TTL index:", error);
//   }
// }
// //save email password and otp//timer
// async function saveRegisOTP(email, pass, otp) {
//   try {
//     await client.connect();
//     const database = client.db("userOtp");
//     const collections = database.collection("regisOtp");

//     const doc = {
//       _id: email,
//       otp: otp,
//       pass: pass,
//       createdAt: new Date(),
//     };

//     const result = await collections.insertOne(doc);
//     console.log(`A document was inserted with the _id: ${result.insertedId}`);
//   } catch (error) {
//     console.error("Error inserting:", error);
//   }
// }
// //validate otp with email //boolean
// async function validateEmailOTP(email, otp) {
//   try {
//     await client.connect();
//     const database = client.db("userOtp");
//     const collections = database.collection("regisOtp");

//     const result = await collections.findOne(email);
//     if (result.otp == otp) {
//       return true;
//     }

//     return false;
//   } catch (error) {
//     console.error("Error finding:", error);
//     console.log("expired");
//   }
// }
// //store user
// async function storeUser(email, password) {
//   try {
//     await client.connect();
//     const database = client.db("userdb");
//     const collections = database.collection("user");

//     const doc = {
//       _id: email,
//       pass: pass,
//       createdAt: new Date(),
//     };

//     const result = await collections.insertOne(doc);
//     console.log(`A document was inserted with the _id: ${result.insertedId}`);
//   } catch (error) {
//     console.error("Error inserting:", error);
//   }
// }
// //find user from otp db
// async function getUserFromTemp(email) {
//   try {
//     await client.connect();
//     const database = client.db("userOtp");
//     const collections = database.collection("regisOtp");

//     const result = await collections.findOne(email);
//     return { email: result._id, pass: result.pass };
//   } catch (error) {
//     console.error("Error finding:", error);
//   }
// }

// async function closeConnection() {
//   await client.close();
// }
// module.exports.closeConnection = closeConnection;
// module.exports.createTTLIndex = createTTLIndex;
// module.exports.saveRegisOTP = saveRegisOTP;
// module.exports.validateEmailOTP = validateEmailOTP;
// module.exports.storeUser = storeUser;
// module.exports.getUserFromTemp = getUserFromTemp;
