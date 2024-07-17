const axios = require("axios");
const test = async () => {
  const response = await axios.post(
    `https://www.magicconchxhell.xyz/getConfig`,
    {
      clientName: `limxx`,
    }
  );

  console.log(response.data.config);
};
test();
