import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? parseDateTime(dynamic dateData) {
  return dateData == null ? DateTime.now() 
    : dateData.runtimeType == Timestamp 
    ? (dateData as Timestamp).toDate() 
    : dateData.runtimeType == int 
    ? DateTime.fromMillisecondsSinceEpoch(dateData)
    : dateData.runtimeType == String
    ? DateTime.parse(dateData)
    : null;
}