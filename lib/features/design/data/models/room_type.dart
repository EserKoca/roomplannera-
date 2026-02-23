import 'package:flutter/material.dart';

class RoomType {
  final String id;
  final String name;
  final String nameEn;
  final String nameTr;
  final IconData icon;
  final String promptKeyword;

  const RoomType({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameTr,
    required this.icon,
    required this.promptKeyword,
  });

  static const List<RoomType> allTypes = [
    RoomType(
      id: 'living_room',
      name: 'Living Room',
      nameEn: 'Living Room',
      nameTr: 'Salon',
      icon: Icons.weekend_rounded,
      promptKeyword: 'living room',
    ),
    RoomType(
      id: 'bedroom',
      name: 'Bedroom',
      nameEn: 'Bedroom',
      nameTr: 'Yatak Odası',
      icon: Icons.bed_rounded,
      promptKeyword: 'bedroom',
    ),
    RoomType(
      id: 'kitchen',
      name: 'Kitchen',
      nameEn: 'Kitchen',
      nameTr: 'Mutfak',
      icon: Icons.kitchen_rounded,
      promptKeyword: 'kitchen',
    ),
    RoomType(
      id: 'bathroom',
      name: 'Bathroom',
      nameEn: 'Bathroom',
      nameTr: 'Banyo',
      icon: Icons.bathtub_rounded,
      promptKeyword: 'bathroom',
    ),
    RoomType(
      id: 'garden',
      name: 'Garden',
      nameEn: 'Garden',
      nameTr: 'Bahçe',
      icon: Icons.yard_rounded,
      promptKeyword: 'garden outdoor',
    ),
    RoomType(
      id: 'office',
      name: 'Office',
      nameEn: 'Office',
      nameTr: 'Ofis',
      icon: Icons.desktop_windows_rounded,
      promptKeyword: 'home office',
    ),
    RoomType(
      id: 'kids_room',
      name: 'Kids Room',
      nameEn: 'Kids Room',
      nameTr: 'Çocuk Odası',
      icon: Icons.child_care_rounded,
      promptKeyword: 'kids room children bedroom',
    ),
    RoomType(
      id: 'dining_room',
      name: 'Dining Room',
      nameEn: 'Dining Room',
      nameTr: 'Yemek Odası',
      icon: Icons.dining_rounded,
      promptKeyword: 'dining room',
    ),
  ];
}
