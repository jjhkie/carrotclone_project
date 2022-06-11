import 'package:flutter/material.dart';

class DetailContentView extends StatefulWidget {
  Map<String, dynamic> data;

  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  late Size size;
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }

  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent, //부모의 색을 따라간다 - 투명
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.share),
          color: Colors.black,
        ),
        IconButton(
            onPressed: () {}, icon: Icon(Icons.more_vert), color: Colors.black)
      ],
    );
  }

  Widget _bodyWidget() {
    return Container(
      child: Hero(
        tag: widget.data['cid'],
        child: Image.asset(widget.data['image'],
            width: size.width,
            fit: BoxFit.fill),
      ),
    );
  }
}
