import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_test/util.dart';
import 'package:video_player/video_player.dart';

class Video_Play extends StatefulWidget{

  String url = "";

  Video_Play(String url){
    this.url = url;
  }

  @override
  _Video_PlayState createState() => _Video_PlayState(url);
}

class _Video_PlayState extends State<Video_Play> {

  Icon play = Icon(Icons.play_arrow,size: 55,color: Colors.white);
  // 播放视频的连接
  String url = "";
  // 判断标志
  bool isPlay = true;
  // 实例化工具类
  MyUtil myUtil = MyUtil();
  // 定义视频播放控件
  VideoPlayerController _controller;
  double screen_width,screen_height;

  _Video_PlayState(String url){
    this.url = url;
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(this.url)
      ..setLooping(true)
      // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {
           _controller.play();
        });
      });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    screen_width = size.width;
    screen_height = size.height;

    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          GestureDetector(
            onTap: (){
              print("点击触发");
              if(isPlay){
                _controller.pause();
              }else{
                _controller.play();
              }
              setState(() {
                isPlay = !isPlay;
              });
            },
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Positioned(
            top: 0.07 * screen_height,
            left: 15,
            child: myUtil.getClip(20, 50, Container(
              width: 60,
              height: 60,
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back,color: Colors.white,),
              ),
            )),
          ),
          Center(
            child: isPlay? Text("") : Container(
              width: 100,
              height: 100,
              child: myUtil.getClip(20, 20, IconButton(
                icon: play,
              )),
            ) ,
          )
        ],
      ),
    );

  }
}