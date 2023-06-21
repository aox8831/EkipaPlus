import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekipa_plus/models/user2.dart';
import 'package:ekipa_plus/utils/utils2.dart';

import '../data.dart';
import '../models/message.dart';

class FirebaseApi {
  static Stream<List<User2>> getUsers() => FirebaseFirestore.instance
      .collection('users')
      .orderBy(UserField2.lastMessageTime, descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => User2.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  static Future uploadMessage(String idUser, String message) async {
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');

    final newMessage = Message(
      idUser: myId,
      urlAvatar: myUrlAvatar,
      username: myUsername,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('users');
    await refUsers
        .doc(idUser)
        .update({UserField2.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
              .toList());

  static Future addRandomUsers(List<User2> users) async {
    final refUsers = FirebaseFirestore.instance.collection('users');

    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(uid: userDoc.id);

        await userDoc.set(newUser.toJson());
      }
    }
  }
}