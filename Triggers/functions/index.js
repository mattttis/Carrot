const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNewChangesNotification = functions.firestore
  .document('lists/{listId}/sections/{sectionId}/items/{itemId}')
  .onWrite((change, context) => {

    var topic = "Serenity";
    const listId = context.params.listId
		
    // A message that contains the notification that devices will receive	
    var message = {
      notification: {
        body: change.after.data().firstName + ' added ' + change.after.data().name + ' to your grocery list.'
      }
    };

    // Using Cloud Messaging to create notification
    
    return admin.messaging().sendToTopic(listId, message).then(function (response) {
        console.log('Successfully sent message to:', listId, response, change.after.data().name + ' was added to your grocery list.');
        return null;
    }).catch(function (error) {
        throw new Error("Error sending message:", error, listId);
    });
})
