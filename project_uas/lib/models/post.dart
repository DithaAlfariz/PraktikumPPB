import 'package:flutter/material.dart';

class PostModel {
  final String type;        // Bisa ngajarin / Butuh bantuan
  final Color typeColor;    // Warna badge type
  final String title;       // Judul posting
  final String desc;        // Deskripsi
  final String category;    // Kategori (Pemrograman, Desain, dll.)
  final String name;        // Nama pembuat posting

  PostModel({
    required this.type,
    required this.typeColor,
    required this.title,
    required this.desc,
    required this.category,
    required this.name,
  });

  // Convert PostModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'typeColor': typeColor.value,
      'title': title,
      'desc': desc,
      'category': category,
      'name': name,
    };
  }

  // Create PostModel from JSON
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      type: json['type'] as String,
      typeColor: Color(json['typeColor'] as int),
      title: json['title'] as String,
      desc: json['desc'] as String,
      category: json['category'] as String,
      name: json['name'] as String,
    );
  }
}