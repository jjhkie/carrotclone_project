import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrotclone_project/components/manner_temperature_widget.dart';
import 'package:carrotclone_project/repository/contents_repository.dart';
import 'package:carrotclone_project/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailContentView extends StatefulWidget {
  Map<String, dynamic> data;

  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ContentRepository contentRepository;
  late Size size;
  late List<Map<String, dynamic>> imgList;
  late int _current;
  double scrollpositionToAlpha = 0;
  ScrollController _controller = ScrollController();
  late AnimationController _animationController;
  late Animation _colorTween;
  late bool isMyFavoriteContent;

  @override
  void initState() {
    super.initState();
    isMyFavoriteContent = false;
    contentRepository = ContentRepository();
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    _controller.addListener(() {
      setState(() {
        if (_controller.offset > 255) {
          scrollpositionToAlpha = 255;
        } else {
          scrollpositionToAlpha = _controller.offset;
        }
        _animationController.value = scrollpositionToAlpha / 255;
      });
    });
    _loadMyFavoriteContentState();
  }

  _loadMyFavoriteContentState() async {
    contentRepository.isMyFavoritecontent(widget.data["cid"]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    imgList = [
      {"id": "0", "url": widget.data['image']},
      {"id": "1", "url": widget.data['image']},
      {"id": "2", "url": widget.data['image']},
      {"id": "3", "url": widget.data['image']},
      {"id": "4", "url": widget.data['image']},
    ];
    _current = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: _appBarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Icon(icon, color: _colorTween.value),
    );
  }

  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollpositionToAlpha.toInt()),
      //????????? ?????? ???????????? - ??????
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: _makeIcon(Icons.arrow_back)),
      actions: [
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.more_vert))
      ],
    );
  }

  //??????
  Widget _line() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            widget.data["title"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            "?????????/?????? - 22?????? ???",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            "????????????(Daangn Market)???\n ??????????????? ?????? ??????, ???????????? ?????? ??? ???????????? ?????????????????????.\n ????????????, ????????????, ????????????, ?????????, ???????????? ??? ?????? ????????? ???????????? ??????????????? ????????????\n ???????????? ??????????????? ????????? ??? ??????.",
            style: TextStyle(height: 1.5, fontSize: 14),
          ),
          SizedBox(height: 15),
          Text(
            "?????? 3 - ?????? 17 - ?????? 295",
            style: TextStyle(height: 1.5, fontSize: 12),
          ),
          SizedBox(height: 15)
        ],
      ),
    );
  }

  Widget _otherCellContent() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("??????????????? ?????? ??????",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Text("?????? ??????",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(controller: _controller, slivers: [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            _makeSliderImage(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            _otherCellContent()
          ],
        ),
      ),
      SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
            delegate: SliverChildListDelegate(List.generate(20, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(height: 120, color: Colors.grey)),
                  Text("?????? ??????", style: TextStyle(fontSize: 14)),
                  Text("??????",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              );
            }).toList()),
          ))
    ]);
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: 55,
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                contentRepository.addMyFavoriteContent(widget.data);
                setState(() {
                  isMyFavoriteContent = !isMyFavoriteContent;
                });
                scaffoldKey.currentState?.showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 1000),
                  content: Text(isMyFavoriteContent
                      ? "??????????????? ?????????????????????."
                      : "?????????????????? ?????????????????????."),
                ));
              },
              child: SvgPicture.asset(
                isMyFavoriteContent
                    ? "assets/svg/heart_on.svg"
                    : "assets/svg/heart_off.svg",
                width: 20,
                height: 20,
                color: Color(0xfff08f4f),
              )),
          Container(
              margin: const EdgeInsets.only(left: 15, right: 10),
              width: 1,
              height: 40,
              color: Colors.grey.withOpacity(0.4)),
          Column(
            children: [
              Text(
                DataUtils.calcStringToWon(widget.data["price"]),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text("??????????????????", style: TextStyle(fontSize: 14, color: Colors.grey))
            ],
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xfff08f4f)),
                child: Text(
                  "???????????? ????????????",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _makeSliderImage() {
    return Container(
      child: Stack(
        children: [
          Hero(
              tag: widget.data['cid'],
              child: CarouselSlider(
                  items: imgList.map((map) {
                    return Image.asset(map["url"],
                        width: size.width, fit: BoxFit.fill);
                  }).toList(),
                  options: CarouselOptions(
                      height: size.width,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      viewportFraction: 1,
                      //?????? ?????? ??????
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }))),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => {},
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(50),
          //     child: Container(
          //       width: 50,
          //       height: 50,
          //       child : Image.asset("assets/images/user.png")
          //     ),
          // )
          //???????????? ?????? ??????
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "?????????1",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("????????? ?????????"),
            ],
          ),
          Expanded(child: MannerTemperature(mannerTemp: 36.7))
        ],
      ),
    );
  }
}
