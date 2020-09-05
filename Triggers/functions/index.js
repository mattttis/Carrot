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
    const language = snapshot.data()['language']
    
    var message
		
    // A message that contains the notification that devices will receive

    if (language === "en") {
        message = {
            tokens: tokensI,
            notification: {
                body: data.firstName + ' added ' + data.name + ' to your grocery list'
            }
        };
    } else if (language === "nl") {
        message = {
            tokens: tokensI,
            notification: {
                body: data.firstName + ' heeft ' + data.name + ' aan je boodschappenlijst toegevoegd'
            }
        };
    }
            
    return admin.messaging().sendMulticast(message).then(function (response) {
        console.log('Successfully sent message to:', listId, response, data.name + ' was added to your grocery list');
        return null;
    }).catch(function (error) {
        throw new Error("Error sending message:", error, listId);
    });
});
