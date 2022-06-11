import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrotclone_project/components/manner_temperature_widget.dart';
import 'package:flutter/material.dart';

class DetailContentView extends StatefulWidget {
  Map<String, dynamic> data;

  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  late Size size;
  late List<Map<String, dynamic>> imgList;
  late int _current;

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
      extendBodyBehindAppBar: true,
      appBar: _appBarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }

  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent, //부모의 색을 따라간다 - 투명
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
      ],
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        _makeSliderImage(),
        _sellerSimpleInfo(),
      ],
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      width: size.width,
      height: 55,
      color: Colors.blueAccent,
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
                      //화면 사용 비율
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
          //가독성이 좋은 방법
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          SizedBox(width:10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "등록자1",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("경기도 부천시"),
            ],
          ),
          Expanded(child: MannerTemperature(mannerTemp: 36.7))
        ],
      ),
    );
  }
}
