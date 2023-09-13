import 'package:flutter/material.dart';
import 'package:print_sample/data/paper_sIze.dart';
import 'package:print_sample/main.dart';
import 'package:print_sample/pdf_screen.dart';
import 'package:screenshot/screenshot.dart';

import 'data/card_sIze.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _screenWidth = 0.0;
  double _screenHeight = 0.0;
  double _spaceBetweenCards = 0.0;

  /*
  * TODO Widgetで実装すると面倒なのでカードサイズはここで設定
  *  => 実際のアプリではユーザーが画面から選べるように実装する必要あり
  * */
  CardSize _selectedCardSize = cardSizes[1]; //0:名刺, 1:遊戯王, 2:デュエマ
  PaperSize _selectedPaperSize = paperSizes[1];

  //カード間の余白(mm）
  int _cardPaddingMm = 2;

  //用紙に並べされるカードの行数（ヨコ）
  int _numOfRows = 0;

  //用紙に並べられるカードの列数（タテ）
  int _numOfColumns = 0;

  //画面上のカードサイズ
  double _cardWidthOnScreen = 0.0;
  double _cardHeightOnScreen = 0.0;

  final _screenShotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _calcGridMatrix(_selectedPaperSize, _selectedCardSize);
  }

  @override
  Widget build(BuildContext context) {
    //これはinitStateでやるとエラーになる
    _calcScreenSize();
    _calcGridMatrix(_selectedPaperSize, _selectedCardSize);

    return Scaffold(
      appBar: AppBar(
        title: Text("${_selectedCardSize.name} / ${_selectedPaperSize.name}"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (paperSize) {
              _selectedPaperSize = paperSize;
              _calcGridMatrix(_selectedPaperSize, _selectedCardSize);
            },
            icon: Icon(Icons.select_all),
            itemBuilder: (context) => List.generate(
              paperSizes.length,
              (int index) {
                final size = paperSizes[index];
                return PopupMenuItem(
                  value: size,
                  child: Text(size.name),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Screenshot(
          controller: _screenShotController,
          child: AspectRatio(
            aspectRatio: _selectedPaperSize.width / _selectedPaperSize.height,
            /*
                * GridViewの中でSizedBoxの大きさが設定した値より大きくなってしまっている
                * => GridView.countではなく、GridView.builderを使うと固定値で設定できるみたい
                *   https://github.com/flutter/flutter/issues/55290#issuecomment-846331300
                *
                * + SizedBoxで大きさを指定しているはずなのになぜか横幅がstretchしてしまう問題発生
                * => SizedBoxをColumnでくるんでやるとうまくいくみたい
                *   https://stackoverflow.com/a/57364704/7300575
                * */
            //GridViewをCenter寄せにして上に余白をつけないと印刷時に１行目の上の部分がカットアウトされて大きさが変わってしまう
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: _numOfRows * _numOfColumns,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _numOfRows,
                  //mainAxisExtentでGridView1つ分の枠の高さを固定値で設定
                  mainAxisExtent: _cardHeightOnScreen,
                  childAspectRatio:
                      _selectedCardSize.width / _selectedCardSize.height,
                  mainAxisSpacing: _spaceBetweenCards,
                  crossAxisSpacing: _spaceBetweenCards,
                ),
                itemBuilder: (context, int index) {
                  //GridView内でSizedBoxを設定した大きさにしたい場合はColumnでくるんでやる必要あり
                  //https://stackoverflow.com/a/57364704/7300575
                  return Column(
                    //Columnの縦幅をSizedBox分だけにしたいので（MainAxisSize.minに）
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: _cardWidthOnScreen,
                        height: _cardHeightOnScreen,
                        child: Image.asset(
                          "assets/images/back001.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // child: GridView.count(
            //   crossAxisCount: _numOfRows,
            //   crossAxisSpacing: _spaceBetweenCards,
            //   //mainAxisSpacing: _spaceBetweenCards,
            //   childAspectRatio:
            //       _selectedCardSize.width / _selectedCardSize.height,
            //   children: List<Widget>.generate(_numOfRows * _numOfColumns,
            //       (int index) {
            //
            //     return SizedBox(
            //       width: _cardWidthOnScreen,
            //       height: _cardHeightOnScreen,
            //       child: Image.asset(
            //         "assets/images/back001.jpg",
            //         fit: BoxFit.cover,
            //       ),
            //     );
            //   }),
            // ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.picture_as_pdf),
        onPressed: () => _createPdf(),
      ),
    );
  }

  void _calcScreenSize() {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    /*
    * TODO スマホタテ固定の場合は用紙のヨコサイズ＝画面サイズの想定が可能
    * （But Webに拡張する場合は、タテ固定ができないので、この想定はできない）
    * */

    _spaceBetweenCards =
        (_cardPaddingMm / _selectedPaperSize.width) * _screenWidth;
    _cardWidthOnScreen =
        _selectedCardSize.width * (_screenWidth / _selectedPaperSize.width);
    _cardHeightOnScreen = _cardWidthOnScreen *
        (_selectedCardSize.height / _selectedCardSize.width);
    print(
        "screenWidth: $_screenWidth / paperWidth: ${_selectedPaperSize.width} / cardWidth: $_cardWidthOnScreen / cardHeight: $_cardHeightOnScreen");
  }

  void _calcGridMatrix(PaperSize paperSize, CardSize cardSize) {
    _numOfRows = (paperSize.width) ~/ (cardSize.width + _cardPaddingMm);
    _numOfColumns = (paperSize.height) ~/ (cardSize.height + _cardPaddingMm);

    setState(() {});
  }

  _createPdf() async {
    final capturedImageByteData = await _screenShotController.capture();
    if (capturedImageByteData == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfScreen(
          paperSize: _selectedPaperSize,
          cardSize: _selectedCardSize,
          capturedImageByteData: capturedImageByteData,
        ),
      ),
    );
  }
}
