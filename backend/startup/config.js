require('dotenv').config();

// checks if jwt private key is set
module.exports = function () {
  if (!process.env.JWT_PRIVATE_KEY) {
    console.error("FATAL ERROR: JWT_PRIVATE_KEY is not defined.");
    process.exit(1);
  }
}