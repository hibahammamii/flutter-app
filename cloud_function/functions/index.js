const functions = require("firebase-functions");
const admin =require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
 exports.helloWorld = functions.https.onRequest((request, response) => {
   functions.logger.info("Hello logs!", {structuredData: true});
   response.send("Hello from Firebase!");
 });
  exports.sendToDevice = functions.firestore.document('orders/{id}').onCreate(async snapshot => {

     const querySnapshot = await db.collection('adminTokens').get();

     const tokens = new Array();

     querySnapshot.forEach(async tokenDoc => {
         tokens.push(tokenDoc.data().token);
     });

     const payload = admin.messaging.MessagingPayload = {

                       "data":
                           {
                           type : "admin"
                           },
         notification : {
             title : ' New Order ',
             body : 'Please Check Your Orders list',
            // click_action : 'FLUTTER_NOTIFICATION_CLICK'
         }
     };

     return fcm.sendToDevice(tokens , payload);

 });
  exports.sendToUser = functions.firestore.document('orders/{Id}').onUpdate((change, context) => {

      //const querySnapshot = await db.collection('adminTokens').get();

        const newValue = change.after.data();

            // ...or the previous value before this update
            const previousValue = change.before.data();

            // access a particular field as you would any JS property
           // const name = newValue.name;
             const tokens = newValue.token;

      //const token = await db.collection('orders').whereEqualTo('token', tokenUser)

//      querySnapshot.forEach(async tokenDoc => {
//          tokens.push(tokenDoc.data().token);
//      });


      const payload = admin.messaging.MessagingPayload = {
                 "data":
                      {
                      type : "user"
                      },
          notification : {
              title : " papa's receive your order " ,
              body : 'are you ready !',
             // click_action : 'FLUTTER_NOTIFICATION_CLICK'
          }
      };

      const payload1 = admin.messaging.MessagingPayload = {
                "data":
                {
                type : "user"
                },
                notification : {
                    title : "your order done " ,
                    body : 'are you ready !',
                   // click_action : 'FLUTTER_NOTIFICATION_CLICK'
                }
            };

       if(newValue.orderStatus == 1){ return fcm.sendToDevice(tokens , payload);}
       if (newValue.orderStatus == 2){ return fcm.sendToDevice(tokens , payload1);}

  });

