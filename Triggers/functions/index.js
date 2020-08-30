const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNewChangesNotification = functions.firestore
  .document('lists/{listId}/sections/{sectionId}/items/{itemId}')
  .onCreate((snapshot, context) => {

    var topic = "Serenity";
    const data = snapshot.data()
    const listId = context.params.listId
    const tokensI = snapshot.data()['tokens']
    
    console.log(tokensI)
    console.log(data.tokens)
		
    // A message that contains the notification that devices will receive	
    var message = {
        tokens: tokensI,
        notification: {
            body: data.firstName + ' added ' + data.name + ' to your grocery list'
        }
    };
            
    return admin.messaging().sendMulticast(message).then(function (response) {
        console.log('Successfully sent message to:', listId, response, data.name + ' was added to your grocery list');
        return null;
    }).catch(function (error) {
        throw new Error("Error sending message:", error, listId);
    });
});
