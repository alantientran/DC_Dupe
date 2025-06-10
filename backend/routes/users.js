const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const { User, validateUser } = require("../models/user");
const auth = require("../middleware/auth");
const jwt = require("jsonwebtoken");
const Joi = require("joi");
const _ = require("lodash");

// Create a new user
router.post("/create-account", async (req, res) => {
  // Validate the request body
  const { error } = validateUser(req.body);
  if (error) return res.status(400).send(error.details[0].message); // Bad request

  // Check if the user already exists
  let user = await User.findOne({ email: req.body.email });
  if (user) return res.status(400).send("User already registered.");

  // Create a new user
  user = new User({
    firstName: req.body.firstName,
    lastName: req.body.lastName,
    phoneNumber: req.body.phoneNumber,
    email: req.body.email,
    location: req.body.location,
    password: req.body.password,
    role: req.body.role,
  });

  // Hash the password
  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(user.password, salt);

  // Generate an auth token
  const token = user.generateAuthToken();

  // Save the user to the database
  user.save();

  // Send the token in the response header
  res.send({ token: token, email: user.email });
});

// Sign in
function validateSignIn(credentials) {
  const schema = Joi.object({
    email: Joi.string().required(),
    password: Joi.string().required(),
  });
  return schema.validate(credentials);
}

router.post("/sign-in", async (req, res) => {
  // Validate the request body
  const { error } = validateSignIn(req.body);
  if (error) return res.status(400).send(error.details[0].message); // Bad request

  // same message for email and pwd error to prevent attempts of brute force
  // Check if the user exists
  let user = await User.findOne({ email: req.body.email });
  if (!user) return res.status(400).send("Invalid email or password.");

  // Check if the password is correct
  const validPassword = await bcrypt.compare(req.body.password, user.password);
  if (!validPassword) return res.status(400).send("Invalid email or password.");

  // Generate an auth token
  const token = user.generateAuthToken();

  // Send the token in the response header
  response = { token: token, email: user.email, role: user.role };
  return res.send(response);
});

// export
module.exports = router;
