import 'package:flutter/material.dart';
import 'package:game_lovers_app/core/config/api_config.dart';
import 'package:game_lovers_app/core/values/colors_game_lovers.dart';
import 'package:game_lovers_app/core/values/images_game_lovers.dart';
import 'package:game_lovers_app/core/values/styles_game_lovers.dart';
import 'package:game_lovers_app/core/values/texts_game_lovers.dart';
import 'package:game_lovers_app/features/games/domain/entities/game.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.game}) : super(key: key);

  final Game game;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.of(context).size.width;
    final double sizeHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: ColorsGameLovers.theme,
            iconTheme: const IconThemeData(
              color: ColorsGameLovers.black, //change your color here
            )),
        body: sizeWidth < 600
            ? _bodyCell(sizeWidth, sizeHeight)
            : _bodyMoreLarger(sizeWidth, sizeHeight),
      ),
    );
  }

  Widget _bodyCell(double sizeWidth, double sizeHeight) {
    return SingleChildScrollView(
      child: SizedBox(
        width: sizeWidth,
        height: sizeHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            image(sizeWidth, sizeHeight),
            Center(
              child: Text(
                widget.game.name,
                style: StylesGameLovers.bodyBlack16
                    .copyWith(color: Theme.of(context).secondaryHeaderColor),
              ),
            ),
            Column(
              children: [
                list(
                  height: sizeHeight,
                  width: sizeWidth,
                  title: TextsGameLovers.genres,
                  widget: widget.game.genres != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.game.genres?.length,
                          itemBuilder: (context, index) {
                            return Text(
                              '${widget.game.genres?[index]}${widget.game.genres!.length - 1 == index ? '' : ', '}',
                              style: StylesGameLovers.bodyBlack.copyWith(
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            );
                          },
                        )
                      : Text(
                          TextsGameLovers.undefined,
                          style: StylesGameLovers.bodyBlack.copyWith(
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                ),
                list(
                    height: sizeHeight,
                    width: sizeWidth,
                    widget: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.game.platform.length,
                      itemBuilder: (context, index) {
                        return Text(
                          '${widget.game.platform[index]}${widget.game.platform.length - 1 == index ? '' : ', '}',
                          style: StylesGameLovers.bodyBlack.copyWith(
                              color: Theme.of(context).secondaryHeaderColor),
                        );
                      },
                    ),
                    title: TextsGameLovers.platform),
              ],
            ),
            const Divider(
              color: ColorsGameLovers.greyLight,
              thickness: 1,
              indent: 8,
              endIndent: 8,
            ),
            widget.game.description != null
                ? _textGame(
                    textTitle: TextsGameLovers.description,
                    text: widget.game.description!)
                : _textGame(
                    textTitle: TextsGameLovers.description,
                    text: TextsGameLovers.undefined)
          ],
        ),
      ),
    );
  }

  SizedBox image(double sizeWidth, double sizeHeight) {
    return SizedBox(
      width: sizeHeight * .35,
      height: sizeHeight * .35,
      child: Image.network(
        baseHttp + widget.game.imageUrl!,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Image.asset(ImagesGameLovers.imageGeral);
        },
        fit: BoxFit.fill,
      ),
    );
  }

  Padding list({
    required Widget widget,
    required String title,
    required double height,
    required double width,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: StylesGameLovers.bodyBlack16
                .copyWith(color: Theme.of(context).secondaryHeaderColor),
          ),
          Flexible(
            child: SizedBox(
                height: height * .03, width: width * .5, child: widget),
          ),
        ],
      ),
    );
  }

  Padding _textGame({required String textTitle, required String text}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textTitle,
            style: StylesGameLovers.bodyBlack16
                .copyWith(color: Theme.of(context).secondaryHeaderColor),
          ),
          Flexible(
              child: Text(
            text,
            textAlign: TextAlign.justify,
            style: StylesGameLovers.bodyBlack
                .copyWith(color: Theme.of(context).secondaryHeaderColor),
          )),
        ],
      ),
    );
  }

  _bodyMoreLarger(double sizeWidth, double sizeHeight) {
    return Center(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            image(sizeWidth, sizeHeight),
            SizedBox(
              width: sizeWidth * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      widget.game.name,
                      style: StylesGameLovers.bodyBlack16.copyWith(
                          color: Theme.of(context).secondaryHeaderColor),
                    ),
                  ),
                  list(
                    height: sizeHeight,
                    width: sizeWidth,
                    title: TextsGameLovers.genres,
                    widget: widget.game.genres != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.game.genres?.length,
                            itemBuilder: (context, index) {
                              return Text(
                                '${widget.game.genres?[index]}${widget.game.genres!.length - 1 == index ? '' : ', '}',
                                style: StylesGameLovers.bodyBlack.copyWith(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              );
                            },
                          )
                        : Text(
                            TextsGameLovers.undefined,
                            style: StylesGameLovers.bodyBlack.copyWith(
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                  ),
                  list(
                      height: sizeHeight,
                      width: sizeWidth,
                      widget: ListView.builder(
                        itemCount: widget.game.platform.length,
                        itemBuilder: (context, index) {
                          return Text(
                            '${widget.game.platform[index]}${widget.game.platform.length - 1 == index ? '' : ', '}',
                            style: StylesGameLovers.bodyBlack.copyWith(
                                color: Theme.of(context).secondaryHeaderColor),
                          );
                        },
                      ),
                      title: TextsGameLovers.platform),
                  const Divider(
                    color: ColorsGameLovers.greyLight,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                  ),
                  widget.game.description != null
                      ? _textGame(
                          textTitle: TextsGameLovers.description,
                          text: widget.game.description!)
                      : _textGame(
                          textTitle: TextsGameLovers.description,
                          text: TextsGameLovers.undefined)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
