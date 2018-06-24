mongoose = require 'mongoose'

sessionSchema = mongoose.Schema
    id: String
    uId: String
    isAdmin: Boolean
    username: String

exports.type = mongoose.model 'sessions', sessionSchema
