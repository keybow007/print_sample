class CardSize {
  final String name;
  final double width;
  final double height;

  const CardSize({
    required this.name,
    required this.width,
    required this.height,
  });
}

/*
* カードサイズのアスペクト比
*   名刺: 55x91
*   遊戯王: 59x86
*   デュエマ：63x88
*
* */

final cardSizes = [
  CardSize(name: "名刺", width: 55, height: 91),
  CardSize(name: "遊戯王", width: 59, height: 86),
  CardSize(name: "デュエマ", width: 63, height: 88),
];
