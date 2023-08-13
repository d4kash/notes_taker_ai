// import 'package:uuid/uuid.dart';

// const uuid = Uuid();
// class Note {
//   String? idd;
//   String? titlee;
//   String? desc;
//   String? datee;
//   int? priorityy, colorr;

//   Note({String? idd ,this.titlee, this.datee, this.priorityy, this.colorr,
//       });

//   Note.withId(this.idd, this.titlee, this.datee, this.priorityy, this.colorr,
//       [this.desc='']);

//   String get id => idd!;

//   String get title => titlee!;

//   String get description => desc = '';

//   int get priority => priorityy!;
//   int get color => colorr!;
//   String get date => datee!;

//   set title(String newTitle) {
//     if (newTitle.length <= 255) {
//       titlee = newTitle;
//     }
//   }

//   set description(String newDescription) {
//     if (newDescription.length <= 255) {
//       desc = newDescription;
//     }
//   }

//   set priority(int newPriority) {
//     if (newPriority >= 1 && newPriority <= 3) {
//       priorityy = newPriority;
//     }
//   }

//   set color(int newColor) {
//     if (newColor >= 0 && newColor <= 9) {
//       colorr = newColor;
//     }
//   }

//   set date(String newDate) {
//     datee = newDate;
//   }

//   // Convert a Note object into a Map object
//   Map<String, dynamic> toMap() {
//     var map = <String, dynamic>{};
//     map['id'] = idd;
//     map['title'] = titlee;
//     map['description'] = desc;
//     map['priority'] = priorityy;
//     map['color'] = colorr;
//     map['date'] = datee;

//     return map;
//   }

//   // Extract a Note object from a Map object
//   Note.fromMapObject(Map<String, dynamic> map) {
//     idd = map['id'];
//     titlee = map['title'];
//     desc = map['description'];
//     priorityy = map['priority'];
//     colorr = map['color'];
//     datee = map['date'];
//   }
// }

class Note {
  int? _id;
  String? _title;
  String? _description;
  String? _date;
  int? _priority, _color;

  Note(this._title, this._date, this._priority, this._color,
      [this._description='']);

  Note.withId(this._id, this._title, this._date, this._priority, this._color,
      [this._description='']);

  int get id => _id??0;

  String get title => _title!;

  String get description => _description!;

  int get priority => _priority!;
  int get color => _color!;
  String get date => _date!;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 3) {
      _priority = newPriority;
    }
  }

  set color(int newColor) {
    if (newColor >= 0 && newColor <= 9) {
      _color = newColor;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['color'] = _color;
    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _priority = map['priority'];
    _color = map['color'];
    _date = map['date'];
  }
}
