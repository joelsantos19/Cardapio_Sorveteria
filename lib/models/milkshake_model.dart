import 'package:flutter/material.dart';

class MilkshakeModel {
  final String name;
  final String image;
  final String price;
  final String description;
  final List<Color> gradientColors;

  MilkshakeModel({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.gradientColors,
  });
}

final List<MilkshakeModel> milkshakes = [
  MilkshakeModel(
    name: 'Sheik de Morango',
    image: 'images/strawberry_isolated.png',
    price: '25',
    description: 'Morangos frescos selecionados com um toque de creme suíço.',
    gradientColors: [const Color(0xFF300808), const Color(0xFF6B0000)],
  ),
  MilkshakeModel(
    name: 'Chocolate Premium',
    image: 'images/chocolate_isolated.png',
    price: '28',
    description: 'Blend de chocolates belgas 70% cacau e chantilly artesanal.',
    gradientColors: [const Color(0xFF1B0F0B), const Color(0xFF2B1B17)],
  ),
  MilkshakeModel(
    name: 'Menta Refresh',
    image: 'images/mint_isolated.png',
    price: '26',
    description: 'Explosão de refrescância com menta natural e pedaços de chocolate.',
    gradientColors: [const Color(0xFF061F17), const Color(0xFF0F3628)],
  ),
  MilkshakeModel(
    name: 'Açaí Tradicional',
    image: 'images/acai_isolated.png',
    price: '22',
    description: 'O puro açaí do Pará, batido na hora com xarope de guaraná.',
    gradientColors: [const Color(0xFF1A0B2E), const Color(0xFF2D0A4E)],
  ),
  MilkshakeModel(
    name: 'Açaí com Cupuaçu',
    image: 'images/acai_cupuacu_isolated.png',
    price: '24',
    description: 'Equilíbrio perfeito entre a energia do açaí e o sabor do cupuaçu.',
    gradientColors: [const Color(0xFF2D0A4E), const Color(0xFFF5DEB3)],
  ),
];
