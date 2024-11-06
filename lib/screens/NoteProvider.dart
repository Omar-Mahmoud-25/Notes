// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'globals.dart';

class NoteProvider extends ChangeNotifier{
  List<Note> notes = [];

  dynamic getNotes(Map <dynamic,dynamic> mp) {
    notes.clear();
    for (var item in mp.keys){
      notes.add(
        Note(
          title: item,
          content: mp[item],
        )
      );
    }
    notifyListeners();
    return notes;
  }

}