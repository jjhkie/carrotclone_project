import 'package:carrotclone_project/page/detail.dart';
import 'package:carrotclone_project/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContentRepository contentRepository = ContentRepository();
  late String currentLocation;
  final Map<String, String> locationTypeToString = {
    "ara" : "아라동",
    "ora" : "오라동",
    "donam" : "도남동"
  };

  @override
  void initState() {
    super.initState();
    currentLocation = "ara";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }

  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print('click');
        },
        child: PopupMenuButton<String>(
          offset: Offset(0,20),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular((10.0))),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular((10.0))),
            1),
          onSelected: (String where){
            print(where);
            setState((){
              currentLocation = where;
            });
          },
          itemBuilder: (context){
            return [
              PopupMenuItem(value:"ara", child: Text("아라동")),
              PopupMenuItem(value:"ora", child: Text("오라동")),
              PopupMenuItem(value:"donam", child: Text("도남동")),
            ];
          },
          child: Row(
            children: [Text(locationTypeToString[currentLocation]??""), Icon(Icons.arrow_drop_down)],
          ),
        ),
      ),
      elevation: 1,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: Icon(Icons.tune)),
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset("assets/svg/bell.svg", width: 22)),
      ],
    );
  }
  _loadContent(){
    return contentRepository.loadContentsFromLocation(currentLocation);
  }
  _makeDataList(data){
    List<Map<String, dynamic>>? datas = data as List<Map<String, dynamic>>?;
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder:(BuildContext context){
                return DetailContentView(data: datas![index]);
              }));
              print(data![index]['title']);
            },
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Hero(
                        tag: datas![index]['cid'],
                        child: Image.asset(datas[index]['image']!,
                            width: 100, height: 100),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              datas[index]['title']!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 5),
                            Text(
                              datas[index]['location']!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.3)),
                            ),
                            SizedBox(height: 5),
                            Text(calcStringToWon(datas[index]['price']!),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500)),
                            Expanded(
                              child: Container(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .end,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .end,
                                    children: [
                                      SvgPicture.asset(
                                          "assets/svg/heart_off.svg",
                                          width: 13, height: 13),
                                      SizedBox(width: 5),
                                      Text(datas[index]['likes']!)
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          );
        }, //item Widget
        separatorBuilder: (context, index) {
          return Container(
              height: 1, color: Colors.black.withOpacity(0.4));
        }, //item 사이에 있는 구분선
        itemCount: data!.length);
  }
  Widget _bodyWidget() {
    return FutureBuilder(
      future: _loadContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('데이터 오류'));
        }
        if (snapshot.hasData) {
          return _makeDataList(snapshot.data);
        }

        return Center(child: Text("데이터가 없습니다."));
      }
    );
    /**
     *
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Image.asset(datas[index]['image']!,
                        width: 100, height: 100),
                    /**
                     *
                        Image.asset(datas[index]["image"]
                        여기서 The argument type 'String?' can't be assigned to the parameter type 'String'.오류
                        해당 부분이 null이 올 수 있는 데이터이기 때문에 !를 넣어 강제추출을 해준다.
                     **/
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            datas[index]['title']!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 5),
                          Text(
                            datas[index]['location']!,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.3)),
                          ),
                          SizedBox(height: 5),
                          Text(calcStringToWon(datas[index]['price']!),
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset("assets/svg/heart_off.svg",
                                        width: 13, height: 13),
                                    SizedBox(width: 5),
                                    Text(datas[index]['likes']!)
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
        }, //item Widget
        separatorBuilder: (context, index) {
          return Container(height: 1, color: Colors.black.withOpacity(0.4));
        }, //item 사이에 있는 구분선
        itemCount: 10);
     */
  }
  final oCcy = new NumberFormat("#,###", "ko_KR");

  String calcStringToWon(String priceString) {
    if(priceString == "무료나눔") return priceString;
    return "${oCcy.format(int.parse(priceString))}원";
  }

}
