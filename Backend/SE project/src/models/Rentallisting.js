const mongoose = require('mongoose');
const RentalDetailSchema = new mongoose.Schema(
    { 
      name: {type:String, required: true},
      address: {type:String, required: true},
      state: {type:String, required: true},
      city: {type:String, required: true},
      pincode: {
        type: String,
        required: true,
        match: [/^\d{6}$/, 'Please use a valid pincode']
          },
      Landmark: {type:String,required: true},
      price: {type:Number,required: true},
      phno: {type:Number,required: true},
      images: {type:[String], required: true},
      description: String,
    
      
        // Basic Amenities
        amenities: { type: [String]},
        email: {
          type: String,
          required: true,}
      },
      
  
    {
      collection: 'Rental',
    }
  )
  
  module.exports = mongoose.model('Rental', RentalDetailSchema) ////
  