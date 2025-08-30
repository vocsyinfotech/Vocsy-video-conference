import 'package:video_conforance/utilitis/common_import.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final user = FirebaseAuth.instance.currentUser;

  // GOOGLE LOG IN
   Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Filed to Google Login $e');
      return null;
    }
  }
  /*Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }*/

  // Sign up with email and password
  Future<User?> signUpWithEmail(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user1 = result.user;
      await addUserData(name, user1!);
      return result.user;
    } catch (e) {
      customSnackBar('Alert', '$e');
      print('Sign Up Error: $e');
      return null;
    }
  }

  // Login with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print('Sign In  Error: $e');
      if(isLoadingDialogOpen){
        print('DIALOG OPEN');
        Get.back();
        Future.delayed(Duration(milliseconds: 200), () {
          customSnackBar('Alert', 'Login failed. invalid-credential');
        });
      }
      customSnackBar('Alert', 'Login failed. invalid-credential');
      return null;
    }
  }

  // CHANGE THE PASSWORD
  Future<void> changePasswordWithCurrentUser({required String oldPassword, required String newPassword}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      // Use current user's email automatically
      final email = user.email;
      if (email == null) throw Exception("User email not available");

      final credential = EmailAuthProvider.credential(email: email, password: oldPassword);

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      final newCredential = EmailAuthProvider.credential(email: email, password: newPassword);

      await user.reauthenticateWithCredential(newCredential);

      customSnackBar('Success', 'Password changed successfully');
      print("✅ Password updated successfully");
    } on FirebaseAuthException catch (e) {
      // Handle errors as shown above
      customSnackBar('Error', '${e.message}');
      print("❌ Firebase Auth Error: ${e.code} - ${e.message}");
      rethrow;
    }
  }

  // GOOGLE SIGN OUT
  Future<void> signOut() async {
    removeToken();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// USER COLLECTION

  // ADD DATA ON USER
  Future<void> addUserData(String username, User user) async {
    print('ADD USR DATA ');
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': username,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 0,
      'isShowNotification': false,
      'personalMeetingID': generateMeetingId(),
      'isOnline': true,
      'lastActive': FieldValue.serverTimestamp(),
      'pushToken': CommonVariable.pushToken.value,
    });
  }

  // GET THE CURRENT USER DATA
  Future<Map<String, dynamic>?> getCurrentUserData({bool retry = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    print('USER IS EMPTY OR NOT: ${user?.uid}');

    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          print('✅ Document exists');
          return doc.data();
        } else {
          print('❌ No document found for this user');

          if (!retry) {
            // Create and retry once
            print('🔄 Retrying fetch after creating document...');
            return await getCurrentUserData(retry: true);
          } else {
            print('⚠️ Already retried, no more attempts');
          }
        }
      } catch (e) {
        print('🔥 Error fetching user data: $e');
      }
    } else {
      print('❌ No logged in user');
    }

    return null;
  }

  // GET THE USER DATA BY ID
  Future<UserModel> getUserDataById(String id) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(id).get();
    final data = UserModel.fromJson(doc.data()!, doc.id);
    return data;
  }

  // GET THE USER DATA BY ID
  Future<List<UserModel>> getDataUsersDataBuyId(List members) async {
    List<UserModel> list = [];
    for (var id in members) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(id).get();
      final data = UserModel.fromJson(doc.data()!, doc.id);
      list.add(data);
    }

    return list;
  }

  // GET THE CURRENT USER DATA
  Future<void> addOtherUserData({String? name, String? mobile, String? location, String? jobTitle, String? image}) async {
    // final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'mobile': mobile,
        'username': name,
        'location': location,
        'jobTitle': jobTitle,
        'image': image,
      });
    }
  }

  // SET USER STATUS
  Future<void> setStatus({required int status}) async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'status': status});
      customSnackBar('Success', 'Successfully change status');
    }
  }

  // UPDATE KEY VALUE STATUS

  Future<void> setKeyValue({required String key, required dynamic value}) async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({key: value});
    }
  }

  // REMOVE TOKEN
  void removeToken() {
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'pushToken': ''});
    print('REMOVE TOKEN ${CommonVariable.pushToken.value}');
  }

  /// MEETING

  // SCHEDULE MEETING
  Future<void> scheduleMeeting({
    required String name,
    required String meetingID,
    required DateTime startDate,
    required String passcode,
    required DateTime endDate,
    required String ownerName,
    required String duration,
  }) async {
    await FirebaseFirestore.instance.collection('meetings').add({
      'meetingName': name,
      'startTime': Timestamp.fromDate(startDate),
      'endTime': Timestamp.fromDate(endDate),
      'createdBy': FirebaseAuth.instance.currentUser!.uid,
      "passcode": passcode,
      'meetingID': meetingID,
      'owner': ownerName,
      'duration': duration,
      'participants': [FirebaseAuth.instance.currentUser!.uid],
    });

    await MessageService().generateGroup(name);
  }

  // UPDATE THIS MEETING DATA
  Future<void> updateMeeting({
    required String documentId, // Firestore document ID of the meeting
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required String duration,
  }) async {
    await FirebaseFirestore.instance.collection('meetings').doc(documentId).update({
      'meetingName': name,
      'startTime': Timestamp.fromDate(startDate),
      'endTime': Timestamp.fromDate(endDate),
      'duration': duration,
      // 'participants': [] // Uncomment only if you're resetting participants
    });
  }

  // DELETE THE MEETING
  Future<void> deleteMeeting(String documentId, {int i = 0}) async {
    await FirebaseFirestore.instance.collection('meetings').doc(documentId).delete();
  }

  // ADD PARTICIPANT
  Future<void> addParticipant({required String meetingId}) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('meetings').where('meetingID', isEqualTo: meetingId).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final docRef = querySnapshot.docs.first.reference;

        await docRef.update({
          'participants': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });

        print('✅ Participant added successfully.');
      } else {
        print('❌ Meeting not found.');
      }
    } catch (e) {
      print('❌ Error adding participant: $e');
    }
  }

  // UPDATE THE ONLINE STATUS
  void updateActiveStatus(bool isOnline) {
    print("this is call 1234546");
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'isOnline': isOnline, 'lastActive': FieldValue.serverTimestamp()});
  }


  // CHECK MEETING COLLECTION EXIST
  Future<bool> doesCollectionExist(String collectionName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .limit(1) // only check first document
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

}
