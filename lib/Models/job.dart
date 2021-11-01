import 'package:flutter/material.dart';

class Jobmodel {
  Jobmodel(
      {@required this.name, @required this.ratePerhour, @required this.id});
  final String name;
  final String id;
  final int ratePerhour;
  factory Jobmodel.fromMap(Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final int ratePerhour = data['ratePerHour'];
    return Jobmodel(
      name: name,
      ratePerhour: ratePerhour,
      id: id,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerhour,
    };
  }

  @override
  int get hashCode => hashValues(id, name, ratePerhour);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Jobmodel otherJob = other;
    return id == otherJob.id &&
        name == otherJob.name &&
        ratePerhour == otherJob.ratePerhour;
  }

  @override
  String toString() => 'id: $id, name: $name, ratePerhour: $ratePerhour';
}
