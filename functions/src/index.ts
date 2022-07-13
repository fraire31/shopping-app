import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const auth = admin.auth();

exports.setRole = functions.https.onCall(async (data, context) => {
    var roles = {user: true};
    var uid = data.uid;

    try {
        await admin.firestore()
        .collection("users")
        .where("id", "==" , uid)
        .get()
        .then(result => {
            result.forEach((doc) => {
                var data = doc.data();
                roles = data['roles'];
            });
        });
    } catch(e){
        console.log(e);
    }


    return auth.setCustomUserClaims(uid, {roles: roles});
})







