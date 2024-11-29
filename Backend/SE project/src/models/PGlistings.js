const mongoose = require('mongoose');
const PGDetailSchema = new mongoose.Schema(
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
    
      amenities: { type: [String]},
      email: {
        type: String,
        required: true,}
      },
     
    
  
    {
      collection: 'PG',
    }
  )
  
 module.exports = mongoose.model('PG', PGDetailSchema) ////
  