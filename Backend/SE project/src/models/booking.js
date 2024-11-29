const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
    propertyId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        refPath: 'propertyType', // Dynamically references the correct model based on propertyType
      },
      propertyType: {
        type: String,
        required: true,
        enum: ['Hotel', 'PG', 'Rental'], // This defines the possible property types
      },
  Name: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: true,
     
    match: [/^\d{10}$/, 'Please enter a valid 10-digit phone number']  
},
  dates: {
    from: {
      type: Date,
      required: true,
    },
    to: {
      type: Date,
      required: true,
      validate: {
        validator: function (v) {
          return v > this.dates.from; // Ensure the 'to' date is after the 'from' date
        },
        message: 'Check-out date must be after check-in date.',
      },
    },
  },
  adults: {
    type: Number,
    required: true,
    min: 1, 
  },
  children: {
    type: Number,
    default: 0, 
    min: 0,
  },
  rooms: {
    type: Number,
    required: true,
    min: 1, 
  },
  price: {
    type: Number,
    required: true,
    min: 0, 
  },
  email: {
    type: String,
    required: true,
     
   
}
}, { timestamps: true });

module.exports = mongoose.model('Booking', bookingSchema);