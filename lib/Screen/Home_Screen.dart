import 'package:chat_app3/model/MessageModel.dart';
import 'package:chat_app3/shared/components.dart';
import 'package:chat_app3/shared/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollection);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt ,descending:false ).snapshots(),
      builder: (context, snapshot) {
      if (snapshot.hasData) {
          List<MessageModel> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(
              MessageModel.fromJson(snapshot.data!.docs[i]),
            );
          }
          return Scaffold(
            appBar: CustomAppBar(context,
                tittle: 'Samona Chat', centerTittle: true),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messageList.length,
                    itemBuilder: (context, index) => CustomChatContainer(
                      bottomRight: 5,
                      color: kPrimaryColor,
                      message: messageList[index],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      suffixIcon: Icon(
                        Icons.send,
                        color: kPrimaryColor,
                      ),
                      label: Text('Send Message'),
                      labelStyle: TextStyle(color: kPrimaryColor),
                    ),
                    onSubmitted: (vlue) {
                      if (vlue.isNotEmpty) {
                        messages.add({
                          kMessage: vlue,
                          kCreatedAt : DateTime.now()
                          });
                        controller.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text('error happened');
        }
      },
    );
  }
}
