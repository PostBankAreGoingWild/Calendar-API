mongoose = require 'mongoose'

userSchema = mongoose.Schema
    email: String
    password: String
    passwordsha256: String

exports.type = mongoose.model 'users', userSchema
