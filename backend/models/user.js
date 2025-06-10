const mongoose = require("mongoose");
const Joi = require("joi");
const jwt = require("jsonwebtoken");
require("dotenv").config();

const mongoSchema = mongoose.Schema({
  firstName: {
    type: String,
    required: true,
  },
  lastName: {
    type: String,
    required: true,
  },
  phoneNumber: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  location: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  role: {
    type: String,
    required: true,
    enum: ["detail_customer", "detailer"],
  },
});

mongoSchema.methods.generateAuthToken = function () {
  const token = jwt.sign({ _id: this._id }, process.env.JWT_PRIVATE_KEY, {
    expiresIn: "1d",
  });
  return token;
};

// encrypt id
const User = mongoose.model("User", mongoSchema);

// REST Validation
function validateUser(user) {
  const schema = Joi.object({
    firstName: Joi.string().required(),
    lastName: Joi.string().required(),
    phoneNumber: Joi.string().required(),
    email: Joi.string().required(),
    location: Joi.string().required(),
    password: Joi.string().required(),
    role: Joi.string().valid("detail_customer", "detailer").required(),
  });
  return schema.validate(user);
}

// exports
module.exports = {
  User,
  validateUser,
};
