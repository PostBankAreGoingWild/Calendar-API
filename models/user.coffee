mongoose = require 'mongoose'

userSchema = mongoose.Schema
    email: String
    password: String
    passwordsha256: String
    admin: Boolean

exports.type = mongoose.model 'users', userSchema
