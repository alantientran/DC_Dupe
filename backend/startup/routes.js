const express = require("express");
const cors = require("cors");
const auth = require("../middleware/auth");
const users = require("../routes/users");

module.exports = function (app) {
  app.use(express.json());
  const cors = require("cors");

  app.use(
    cors({
      origin: "*",
      allowedHeaders: ["Content-Type", "x-auth-token"], // <-- crucial for custom headers
    })
  );
  app.use("/api/users", users);
};
