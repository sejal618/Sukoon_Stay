const mongoose = require('mongoose');

const URHSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,

    },
    email: {
        type: String,
        required: true,
        unique: true,  
        match: [/^\S+@\S+\.\S+$/, 'Please use a valid email address']  
    },
    phone: {
        type: String,
        required: true,
        unique: true,  
        match: [/^\d{10}$/, 'Please enter a valid 10-digit phone number']  
    },
    username: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    }
});
const collection2 = new mongoose.model('hosts', URHSchema);
module.exports =  collection2;


