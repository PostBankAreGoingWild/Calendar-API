mongoose = require 'mongoose'

eventSchema = mongoose.Schema
    name: String
    start: Date
    end: Date
    repeatingPeriod: Date
    descritption: String
    type: Number
    userId: String

exports.type = mongoose.model 'events', eventSchema
