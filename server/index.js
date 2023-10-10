const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const cors=require('cors');


const PORT = process.env.PORT | 3001;
const app = express();

app.use(cors());  
app.use(express.json());
app.use(authRouter);

const DB = "mongodb+srv://ragul:ragul@cluster0.0lwqdeh.mongodb.net/?retryWrites=true&w=majority";



mongoose.connect(DB).then(() => { 
    console.log('connected Successfully');
}).catch((e) => {
    console.log(e);
});

app.listen(PORT, "0.0.0.0", () => { 
    console.log(`connected at port ${PORT}`);
});