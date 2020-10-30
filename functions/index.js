const functions = require('firebase-functions');


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const admin = require('firebase-admin');

admin.initializeApp();
  const database = admin.firestore();
exports.timerUpdate = functions.https.onRequest(async (req,res)=>{

   var sn=await  database.collection('msg').get();

   sn.docs.forEach(async (value)=>
   {
       var data = value.data();
       if(data['time'].toDate()> new Date.now())
       {
           console.log(data['time'].toDate());
           data['status']=null;
        await value.ref.update(data);
       }
       return null;
   });
   return null;
}
   
);