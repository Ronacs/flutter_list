
//FOR ANDROID
import 'package:flutter/material.dart';

//FOR PLATFORM
import 'package:flutter/foundation.dart';

//FOR IOS
import 'package:flutter/cupertino.dart';                      


//THIS IS RESPONSIBLE FOR RUNNING YOUR APP - void main runApp()
//void main() {
//
//  runApp(
//    new MaterialApp(
//
//      //Title of the App
//      title: "FriendlyChat",
//
//      theme: new ThemeData(primarySwatch: Colors.pink),
//      //create a new xml - home with child contents by new Scaffold
//      /*
//      * To specify the default screen that users see in your app, set the home argument
//      * in your MaterialApp definition.
//       * The home argument references a widget that defines the main UI for this app.
//      * */
//      home: new Scaffold(
//        appBar: new AppBar(
//
//          //APPBAR TITLE TEXT
//          title: new Text("FriendlyChat"),
//        ),
//      ),
//    ),
//  );
//
//} //end main

/*
* To lay the groundwork for interactive components,
* you'll break the simple app into two different subclasses of widget:
* a root-level FriendlychatApp widget that never changes, and a child
* ChatScreen widget that can rebuild when messages are sent
* and internal state changes.
* */

void main() {
  runApp(new FriendlyChatApp());
}

//THIS IS JUST WRITING XML but through code
//NEED ONE ROOT LVL STATELESS - OR ROOT CONTAINER
class FriendlyChatApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(

      //this serves as the title
      title: "FriendlyChat",

      //this will set the home / main activity contents of the app
      home: new ChatScreen(),

      //the theme
      theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOS : kAndroid

    );
  }
}

//IOS THEME
final ThemeData kIOS = new ThemeData(
  primarySwatch: Colors.indigo,
  primaryColor: Colors.blueAccent,
  accentColor: Colors.blueGrey
);

//ANDROID THEME
final ThemeData kAndroid = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[800],
  accentColor: Colors.lightBlue[600],
);

//Chat Screen
class ChatScreen extends StatefulWidget{

  @override
  State createState() => new ChatScreenState();

//  @override
//  State<StatefulWidget> createState() {
//    return new ChatScreenState();
//  }

}

//STATE OF CHAT SCREEN State -  INPUT FIELDS
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{

  final List<ChatMessage> _chatMessages = <ChatMessage>[];

  //NEW COMPONENT EDIT TEXT INPUT LAYOUT
  final TextEditingController _textController = new TextEditingController();

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      //Toolbar Appbar
      appBar: new AppBar(title: new Text("FriendlyChat"), 
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0: 0.4),

      //Body of xml layout with list view
      body: new Container(
          child: new Column(
          children: <Widget>[

            new Flexible(child: new ListView.builder(itemBuilder: (_, int index) => _chatMessages[index],
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemCount: _chatMessages.length)
            ),

            new Divider( height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              //INCLUDED THE created WIDGET from Widget method
              child: _buildTextComposer(),
            ),
          ],
          ),

          decoration: Theme.of(context).platform == TargetPlatform.iOS ? new BoxDecoration(
            border: new Border(top: new BorderSide(color: Colors.grey[200]))) : null,
      )
    );
  }

  //WIDGET METHOD for compose = text field and icon button
  Widget _buildTextComposer() {

    /*
    Icons inherit their color, opacity, and size from an IconTheme widget, which uses an IconThemeData
    object to define these characteristics. Wrap all the widgets in the _buildTextComposer() method in
    an IconTheme widget, and use its data property to specify the ThemeData object of the current theme.
    */

    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),

      child: new Container(

        //THIS IS FOR THE MARGINS
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),

        //THIS WILL CREATE A ROW
        child: new Row(

          //ROW CHILDREN
          children: <Widget>[

            //FLEXIBLE - wrap the TextField widget in a Flexible widget.
            // This tells the Row to automatically size the text field to
            // use the remaining space that isn't used by the button.
            new Flexible(child: new TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              onChanged: (String text){
                setState(() {
                  _isComposing = text.length > 0;
                });
              },
              decoration: new InputDecoration.collapsed(hintText: "Send a message."),
            ),
            ),

            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS?

              new CupertinoButton(child: new Text("Send"),
                                  onPressed: _isComposing ?()=> _handleSubmitted(_textController.text) : null)
              :
              new IconButton(icon: new Icon(Icons.send),

                  //IF COMPOSE is true, can submit
                  onPressed: _isComposing ?()=> _handleSubmitted(_textController.text) : null

              ),
            )
          ],
        ),
      ),
    );
  }

  //METHOD FOR CLEARING and adding messages
  void _handleSubmitted(String text){

    //clear after submitting
    _textController.clear();

    setState(() {
      _isComposing = false;
    });

    ChatMessage chatMessage = new ChatMessage(
      text: text,
      animationController: new AnimationController(vsync: this,
                                                   duration: new Duration(milliseconds: 400))

    );

    setState(() {
      _chatMessages.insert(0, chatMessage);
    });

    chatMessage.animationController.forward();
  }

  @override
  void dispose() {
    for(ChatMessage message in _chatMessages){
      message.animationController.dispose();
    }
    super.dispose();
  }
  
}

//Chat Message CARD LAYOUT
class ChatMessage extends StatelessWidget{

  final AnimationController animationController;

  final String text;

  ChatMessage({this.text, this.animationController});

  static const String _name = "RoCk";

  @override
  Widget build(BuildContext context) {

    return new SizeTransition(sizeFactor:  new CurvedAnimation(parent: animationController,
                                                               curve: Curves.easeOut),axisAlignment: 0.0,

      child: new Container(
        //margin for all sides of container
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),

        //row with a container for avatar
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(
              //letter inside the avatar
              backgroundColor: Theme.of(context).primaryColor,
              child: new Text(_name[0]),
            ),
          ),

          //
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //name of user
                new Text(_name, style: Theme.of(context).textTheme.subhead),
                //message text
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                )

              ],
            ),
          ),
        ],
        ),

      ),
    );
  }

}










