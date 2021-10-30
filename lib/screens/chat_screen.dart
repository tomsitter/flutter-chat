import 'package:flash_chat_flutter/utils/scaffold_snackbar.dart';
import 'package:flash_chat_flutter/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
    .collection('messages')
    .orderBy('ts', descending: true)
    .snapshots();
User? user;

class ChatScreen extends StatefulWidget {
  static String id = 'chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  String? text;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      _auth.authStateChanges().listen(
            (event) => setState(() => user = event),
          );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text("Chat"),
        backgroundColor: AppTheme.darkYellow,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(),
            Container(
              decoration: AppTheme.messageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) => text = value,
                      decoration: AppTheme.messageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (text != null && user != null) {
                        messages.add({
                          'text': text,
                          'sender': user!.email,
                          'ts': Timestamp.now(),
                        }).then((value) {
                          //ScaffoldSnackbar.of(context).show('Sent message');
                          messageTextController.clear();
                        }).catchError(
                          (error) {
                            print(error);
                            ScaffoldSnackbar.of(context).show('Failed: $error');
                          },
                        );
                      }
                    },
                    child: Text('Send', style: AppTheme.sendButtonTextStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _messageStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ));
          }
          return Expanded(
            child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: snapshot.data!.docs
                    .map<Widget>((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return MessageBubble(
                      sender: data['sender'],
                      text: data['text'],
                      isMe: user!.email == data['sender']);
                }).toList()),
          );
        });
  }
}
