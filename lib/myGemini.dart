import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class MyGemini extends StatefulWidget {
  const MyGemini({super.key});

  @override
  State<MyGemini> createState() => _MyGeminiState();
}

class _MyGeminiState extends State<MyGemini> {

  ChatUser myself = ChatUser(id: '1',firstName: 'Shruti');
  ChatUser MyGemini = ChatUser(id: '2',firstName: 'Gemini');

  List<ChatMessage> allMessages=[];
  List<ChatUser> typing = [];

  final ourUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDHS2qYYqeGzCKg3ud9cn8APe5fzznR1pg';
  final header = {
    'Content-Type': 'application/json'
  };

  getData(ChatMessage m)async{
    var data = {"contents":[{"parts":[{"text":m.text}]}]};
    typing.add(MyGemini);
    allMessages.insert(0, m);
    setState(() {
    });

    await http.post(Uri.parse(ourUrl),headers: header,body: jsonEncode(data))
        .then((value){
          if(value.statusCode==200){
            var result = jsonDecode(value.body);
            print(result['candidates'][0]['content']['parts'][0]['text']);

            ChatMessage m1 = ChatMessage(
                text:  result['candidates'][0]['content']['parts'][0]['text'],
                user: MyGemini,
                createdAt: DateTime.now());
            allMessages.insert(0, m1);

          }else{
            print("Error Occured!!");
          }
    }).catchError((e){});
    typing.remove(MyGemini);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: DashChat(
              typingUsers: typing,
              currentUser: myself,
              onSend: (ChatMessage m){
            getData(m);
          }, messages: allMessages),
    );
  }
}
