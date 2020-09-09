const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNewChangesNotification = functions.firestore
  .document('lists/{listId}/sections/{sectionId}/items/{itemId}')
  .onCreate((snapshot, context) => {

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
                body: data.firstName + ' added ' + data.name.toLowerCase() + ' to your grocery list'
            }
        };
    } else if (language === "nl") {
        message = {
            tokens: tokensI,
            notification: {
                body: data.firstName + ' heeft ' + data.name.toLowerCase() + ' aan je boodschappenlijst toegevoegd'
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

exports.removeChecked = functions.firestore
    .document('lists/{listId}/sections/{sectionNumber}/items/{itemId}')
    .onUpdate(async (change, context) => {
    
//    const db = admin.firestore()
    const newValue = change.after.data()
    const listId = context.params.listId
    const sectionNumber = context.params.sectionNumber
    const itemId = context.params.itemId
    var db = admin.firestore();
    
    
    setTimeout(function() {
        if(newValue.isChecked === true) {
            db.collection('lists').doc(listId).collection('sections').doc(sectionNumber).collection('items').doc(itemId).delete();
        }
    }, 300000);
    
});

