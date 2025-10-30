import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:easywrt/database/storage.dart';

part 'custom.g.dart';

@HiveType(typeId: HiveDB.customBoxTypeId)
class Middleware {
  @HiveField(0)
  List<Middleware> middlewares;
  @HiveField(1)
  List<Page> pages;
  @HiveField(2)
  String fatherPath;
  @HiveField(3)
  String name;
  @HiveField(4)
  String path;
  @HiveField(5)
  String icon;
  Middleware({
    this.middlewares = const [],
    this.pages = const [],
    required this.icon,
    required this.fatherPath,
    required this.name,
    required this.path,
  });
}

@HiveType(typeId: HiveDB.customBoxTypeId + 1)
class Page {
  @HiveField(0)
  String name;
  @HiveField(1)
  String path;
  @HiveField(2)
  String fatherPath;
  @HiveField(3)
  IconData icon;
  Page({
    required this.name,
    required this.path,
    required this.fatherPath,
    required this.icon
  });
}