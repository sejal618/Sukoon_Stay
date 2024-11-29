const mongoose = require('mongoose')
const express = require('express')
const app = express()
app.use(express.json())
const bcrypt = require('bcryptjs')
const path = require("path");
const jwt = require('jsonwebtoken')


const SECRET_KEY = "wnwfwnejnewf23842.[]ka!dmqddm2121.;;[2;'/1/212[/n2hl3;"



const mongoUrl ='mongodb://127.0.0.1:27017/mydatabase?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.3.3'
// const mongoUrl ='mongodb+srv://moulighosh2882003:QHULSo3xWXaZCYl7@cluster0.9ypjq.mongodb.net/'
 
mongoose
  .connect(mongoUrl, 
    {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => 
    {
    console.log('Database Connected Successfully')
    })
  .catch((e) => {
    console.log(e)
  })

  app.listen(5000, () => {
    console.log('server started')
  })

require('./models/client');
require('./models/Host');
require('./models/Hotellisting');
require('./models/PGlistings');
require('./models/Rentallisting');
require('./models/booking');


const Client = mongoose.model('clients')
const Host = mongoose.model('hosts')
const Hotel = mongoose.model('Hotel')
const PG = mongoose.model('PG')
const Rental = mongoose.model('Rental')
const Booking = mongoose.model('Booking')

app.post('/register-client', async (req, res) => {
    const { name, email, phone, username, password } = req.body;

    try {
        // Check if email or phone already exists
        const existingUser = await Client.findOne({ $or: [{ email }, { phone }] });
        if (existingUser) {
            if (existingUser.email === email) {
                return res.status(400).send({ status: 'error', message: 'Email is already registered' });
            }
            if (existingUser.phone === phone) {
                return res.status(400).send({ status: 'error', message: 'Phone number is already registered' });
            }
        }

        const encryptedPassword = await bcrypt.hash(password, 10);

        // Save the new client document
        const newClient = new Client({
            name,
            email,
            phone,
            username,
            password: encryptedPassword,
        });

        await newClient.save();
        res.send({ status: 'success', message: 'User registered successfully' });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).send({ status: 'error', message: 'An error occurred during registration' });
    }
});
  // app.post('/register-host', async (req, res) => {
  //   const { name, email, phone, username, password } = req.body
  //   const encryptedPassword = await bcrypt.hash(password, 10)
  //   console.log(encryptedPassword)
  //   try {
  //     const oldUser = await Host.findOne({ email })
  //     if (oldUser) {
  //       return res.send({ status: 'User already registered as Host' })
  //     }
  //     const newHost= Host({
  //       name, email, phone, username, password:encryptedPassword, 
  //     });
  //     await newHost.save();
  //     res.send({ status: 'registered' })
  //   } catch (error) {
  //     res.send({ status: 'error' })
  //   }
  // })
  app.post('/register-host', async (req, res) => {
    const { name, email, phone, username, password } = req.body;

    // Hash password
    const encryptedPassword = await bcrypt.hash(password, 10);
    
    try {
        // Check if user exists by email or phone
        const oldUser = await Host.findOne({ email });
        const oldPhoneUser = await Host.findOne({ phone });

        if (oldUser) {
            return res.send({ status: 'User already registered as Host' });
        }

        if (oldPhoneUser) {
            return res.send({ status: 'Phone number already registered' });
        }

        // Create new host
        const newHost = new Host({
            name,
            email,
            phone,
            username,
            password: encryptedPassword,
        });

        // Save new host to database
        await newHost.save();
        res.send({ status: 'registered' });

    } catch (error) {
        console.log(error);
        res.send({ status: 'error', message: error.message });
    }
});


  app.post('/login-user-client', async (req, res) => {
    const { username, password } = req.body
    const user = await Client.findOne({ username })
    if (!user) {
      return res.send({ error: 'User not registered as Client' })
    }
    if (await bcrypt.compare(password, user.password)) {
      const token = jwt.sign({ id: user.id, username: user.username,email: user.email }, SECRET_KEY, { expiresIn: '1m' });
      console.log("hihihihihi");
      console.log(token);
      return res.json({ status: 'Logged in', token: token })

    } else {
      return res.json({ status: 'error', error: 'invalid password' })
    }
  })

  app.post('/login-user-host', async (req, res) => {
    const { username, password } = req.body
    const user = await Host.findOne({ username })
    if (!user) {
      return res.send({ error: 'User not registered as Host' })
    }
    if (await bcrypt.compare(password, user.password)) {
      // const token = jwt.sign({ email: user.email }, JWT_SECRET)
      const token = jwt.sign({ id: user.id, username: user.username, email: user.email }, SECRET_KEY, { expiresIn: '5m' });
      // console.log("hihihihihi");
      console.log(token);
      return res.json({ status: 'Logged in', token: token })
      
    } else {
      return res.json({ status: 'error', error: 'invalid password' })
    }
  })


app.post('/HotelRegister', async (req, res) => {
  const {
    name,
    address,
    state,
    city,
    pincode,
    Landmark,
    price,
    phno,
    images,
    description,
    amenities,
    email // Assuming email is passed in the request body
  } = req.body;

  try {
    // Step 1: Check if the user is registered as a host with the provided email
    const host = await Host.findOne({ email });
    if (!host) {
      return res.status(403).send({ status: 'User is not a registered host' });
    }

    // Step 2: Register the hotel if the user is a host
    await Hotel.create({
      name,
      address,
      state,
      city,
      pincode,
      Landmark,
      price,
      phno,
      images,
      description,
      amenities,
      email
    });

    res.send({ status: 'Hotel listed successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).send({ status: 'Error in hotel registration' });
  }
}); // make sure the pin code is of 6 digits

app.post('/PGRegister', async (req, res) => {
  const {
    name,
    address,
    state,
    city,
    pincode,
    Landmark,
    price,
    phno,
    images,
    description,
    amenities,
    email // Assuming email is passed in the request body
  } = req.body;

  try {
    // Step 1: Check if the user is registered as a host with the provided email
    const host = await Host.findOne({ email });
    if (!host) {
      return res.status(403).send({ status: 'User is not a registered host' });
    }

    // Step 2: Register the hotel if the user is a host
    await PG.create({
      name,
              address,
              state,
              city,
              pincode,
              Landmark,
              price,
              phno,
              images,
              description,
              
              amenities,
              email
    });

    res.send({ status: 'PG listed successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).send({ status: 'Error in PG registration' });
  }
}); 


app.post('/RentalRegister', async (req, res) => {
  const {
    name,
    address,
    state,
    city,
    pincode,
    Landmark,
    price,
    phno,
    images,
    description,
    amenities,
    email // Assuming email is passed in the request body
  } = req.body;

  try {
    // Step 1: Check if the user is registered as a host with the provided email
    const host = await Host.findOne({ email });
    if (!host) {
      return res.status(403).send({ status: 'User is not a registered host' });
    }

    // Step 2: Register the hotel if the user is a host
    await Rental.create({
      name,
              address,
              state,
              city,
              pincode,
              Landmark,
              price,
              phno,
              images,
              description,
              amenities,
              email
    });

    res.send({ status: 'Rental listed successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).send({ status: 'Error in Rental registration' });
  }
}); 


app.post('/create-booking', async (req, res) => {
  const { propertyId, propertyType, Name, phone, dates, adults, children, rooms,price, email } = req.body;  // send the email from front end by decoding the jwt web token

  // Validate incoming data
  if (!propertyId || !propertyType  || !Name || !phone || !dates || !adults || !price || !rooms) {
    return res.status(400).json({ error: 'All required fields must be provided' });
  }
  if (!mongoose.Types.ObjectId.isValid(propertyId)) {
    return res.status(400).json({ error: 'Invalid propertyId' });
}

// Check dates validity
if (new Date(dates.to) <= new Date(dates.from)) {
    return res.status(400).json({ error: 'Check-out date must be after check-in date' });
}
  try {
    
    const newBooking = new Booking({
      propertyId: mongoose.Types.ObjectId(propertyId), // Ensure propertyId is valid ObjectId
      propertyType,
      Name,
      phone,
      dates,
      adults,
      children,
      rooms,
      price,
      email,
    });

    
    const booking = await newBooking.save();
    res.status(201).json({ message: 'Booking Successful', booking });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});



// app.get('/allListings', async (req, res) => {
//   let query = {};
//   const location = req.query.location;
//   const name = req.query.name; // Added line to get the name query parameter
  
//   if (location || name) { // Modified condition to include name
//     query = {
//       $or: [
//         ...(location ? [
//           { city: { $regex: location, $options: "i" } },
//           { state: { $regex: location, $options: "i" } },
//           { Landmark: { $regex: location, $options: "i" } }
//         ] : []), // Added dynamic inclusion of location conditions
//         ...(name ? [
//           { name: { $regex: name, $options: "i" } } // Added condition for searching by name
//         ] : []) // Added dynamic inclusion of name condition
//       ]
//     };
//   }

//   try {
//     const hotels = await Hotel.find(query);
//     const pgs = await PG.find(query);
//     const rentals = await Rental.find(query);

//     const listings = [...hotels, ...pgs, ...rentals];

//     res.send({ status: "accommodation list", data: listings });
//   } catch (error) {
//     res.send({ status: "error", error: error.message });
//   }
// });

// app.get('/allListings', async (req, res) => {
//   try {
//     // Fetch all hotels, PGs, and rentals without any location filter
//     const hotels = await Hotel.find({});
//     const pgs = await PG.find({});
//     const rentals = await Rental.find({});

//     // Combine all listings into one array
//     const listings = [...hotels, ...pgs, ...rentals];

//     // Return the listings in the response
//     res.send({ status: "accommodation list", data: listings });
//   } catch (error) {
//     // Handle errors and send a failure response
//     console.error(error);
//     res.status(500).send({ status: "error", error: error.message });
//   }
// });
app.get('/hotels', async (req, res) => {
  try {
    const hotels = await Hotel.find({});
    res.send({ status: "success", data: hotels });
  } catch (error) {
    console.error('Error fetching hotels:', error);
    res.status(500).send({ status: "error", error: error.message });
  }
});

app.get('/pgs', async (req, res) => {
  try {
    const pgs = await PG.find({});
    res.send({ status: "success", data: pgs });
  } catch (error) {
    console.error('Error fetching PGs:', error);
    res.status(500).send({ status: "error", error: error.message });
  }
});

app.get('/rentals', async (req, res) => {
  try {
    const rentals = await Rental.find({});
    res.send({ status: "success", data: rentals });
  } catch (error) {
    console.error('Error fetching rentals:', error);
    res.status(500).send({ status: "error", error: error.message });
  }
});

  
  app.get('/userListings',async (req,res)=>{   //email being sent from front end by decoding the jwt token
    const Email=req.query.email
    try{
      const hotels =await Hotel.find({email: Email});
      const pg =await PG.find({email: Email});
      const rentals =await Rental.find({email: Email});


      const listings = [...hotels, ...pg, ...rentals];
      res.send({status:"ok",data: listings})
    }
    catch(error){
      res.send({status:"error"})
    }
    })


    app.get('/client-bookings', async (req, res) => {
      const { email } = req.query; // Email will be sent as a query parameter
      
      
      if (!email) {
        return res.status(400).json({ error: 'Email is required to fetch bookings' });
      }
    
      try {
        
        const bookings = await Booking.find({ email })  // 
          .populate('propertyId', 'name address state city pincode Landmark price phno images description amenities')

          .exec();
    
        if (!bookings || bookings.length === 0) {
          return res.status(404).json({ error: 'No bookings found ' });
        }
    
        res.status(200).json({ status: 'success', bookings });
      } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
      }
    });
    
    app.get('/hostBookings', async (req, res) => {
      const { email } = req.query; // Get the email from query parameters
    
      if (!email) {
        return res.status(400).json({ status: "error", message: "Email query parameter is required" });
      }
    
      try {
       
        const bookings = await Booking.find()
          .populate({
            path: 'propertyId', 
            match: { email }, 
            select: 'name address state city pincode Landmark price phno images description amenities', // Specify the fields to include in the response
          })
          .exec();
    
        // Filter out bookings where propertyId is not populated (i.e., not matching the host's email)
        const hostBookings = bookings.filter(booking => booking.propertyId);
    
        if (hostBookings.length === 0) {
          return res.status(404).json({ status: "error", message: "No bookings found for the host" });
        }
    
        res.status(200).json({ status: "success", bookings: hostBookings });
      } catch (error) {
        console.error(error);
        res.status(500).json({ status: "error", message: "Internal server error" });
      }
    });
    







    app.post('/deleteItem', async (req, res) => {
      const { itemid } = req.body;  
    
      try {
       
        const hotelDeleteResult = await Hotel.deleteOne({ _id: itemid });
        const pgDeleteResult = await PG.deleteOne({ _id: itemid });
        const rentalDeleteResult = await Rental.deleteOne({ _id: itemid });
    
        
        if (hotelDeleteResult.deletedCount > 0 || pgDeleteResult.deletedCount > 0 || rentalDeleteResult.deletedCount > 0) {
          return res.send({ status: "success", message: "Listing deleted" });
        }
    
        
        return res.status(404).send({ status: "error", message: "Item not found" });
      } catch (error) {
       
        console.log(error);
        res.status(500).send({ status: "error", message: "Some error occurred" });
      }
    });