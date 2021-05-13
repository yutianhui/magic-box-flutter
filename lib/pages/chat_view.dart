import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_test/pages/video_play.dart';
import 'package:flutter_app_test/util.dart';

class Chat_View extends StatefulWidget{
  @override
  _Chat_ViewState createState() => _Chat_ViewState();
}

class _Chat_ViewState extends State<Chat_View> {

  // 初始的页数
  int page = 1;
  // 定义动画的状态
  String animState = "loading";
  // 定义文本的控制器
  TextEditingController sendInput = TextEditingController();
  // 实例化工具类
  MyUtil myUtil = MyUtil();
  double screen_width,screen_height;
  // 实例化
  List<dynamic> resps ;
  // 请求数据并赋值更新界面
  Future<Map<String, dynamic>> futureMap;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureMap = myUtil.getVideos(page);
    futureMap.then((value){
      if(value["code"] == 200){
        setState(() {
          this.resps = value["result"];
        });
        return;
      }
      resps = [];
    }).catchError((error){
      resps = [];
      myUtil.showBottomSheet(context,child: Center(child: Text("接口调用失败",style: TextStyle(fontSize: 30))));
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(screen_height == null){
      print('获取值');
      Size size = MediaQuery.of(context).size;
      screen_width = size.width;
      screen_height = size.height;
    }

    return Material(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/elephant.jpg"),
              fit: BoxFit.cover
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0.07 * screen_height,
              left: 15,
              child: myUtil.getClip(50, 150, Container(
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
            Positioned(
              top: 0.07 * screen_height,
              right: 15,
              child: myUtil.getClip(50, 150, Container(
                width: 60,
                height: 60,
                child: IconButton(
                  onPressed: (){
                    myUtil.showBottomSheet(context,child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("使用说明",style: TextStyle(fontSize: 25)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: RichText(
                            text: TextSpan(
                                text: "使用的实时段子的接口,提供视频播放的服务,",
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: "注意:接口的稳定性不是我能保证的,视频播放页面单击可以暂停",
                                      style: TextStyle(fontWeight: FontWeight.w600)
                                  )
                                ]
                            ),
                          ),
                        ),
                      ],
                    ));
                  },
                  icon: Icon(Icons.format_list_bulleted,color: Colors.white,),
                ),
              )),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(height: 0.07 * screen_height,),
                  Container(
                    width: 0.4 * screen_width,
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: myUtil.getClip(50, 150, Container(

                                child: IconButton(
                                  onPressed: (){
                                    if(page != 1){
                                      page--;
                                      // 请求数据更新视图
                                      futureMap = myUtil.getVideos(page);
                                      // 赋值数据更新视图
                                      futureMap.then((value){
                                        if(value["code"] == 200){
                                          setState(() {
                                            this.resps = value["result"];
                                          });
                                          return;
                                        }
                                        myUtil.showBottomSheet(context,child: Center(child: Text("接口调用失败,请重试!",style: TextStyle(fontSize: 30),)));
                                      }).catchError((error){
                                        resps = [];
                                        myUtil.showBottomSheet(context,child: Center(child: Text("接口调用失败,请重试!",style: TextStyle(fontSize: 30),)));
                                      });
                                      return;
                                    }
                                    myUtil.showBottomSheet(context,child: Center(child: Text("已经是第一页了!",style: TextStyle(fontSize: 30),)));

                                  },
                                  icon: Icon(Icons.arrow_left,size: 40,color: Colors.white,),
                                ),
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: myUtil.getClip(50, 150, Container(
                                child: IconButton(
                                  onPressed: (){
                                    page++;
                                    // 请求数据更新视图
                                    futureMap = myUtil.getVideos(page);
                                    // 赋值数据更新视图
                                    futureMap.then((value){
                                      if(value["code"] == 200){
                                        setState(() {
                                          this.resps = value["result"];
                                        });
                                        return;
                                      }
                                      myUtil.showBottomSheet(context,child: Center(child: Text("接口调用失败",style: TextStyle(fontSize: 30),)));
                                    }).catchError((error){
                                      resps = [];
                                      myUtil.showBottomSheet(context,child: Center(child: Text("接口调用失败",style: TextStyle(fontSize: 30),)));
                                    });
                                  },
                                  icon: Icon(Icons.arrow_right,size: 40,color: Colors.white,),
                                ),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              child: Container(
                width: screen_width,
                height: 0.81 * screen_height,
                decoration: BoxDecoration(
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    width: double.infinity,
                    child: GridView.builder(
                      padding: EdgeInsets.all(2),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        crossAxisCount: 2,
                        childAspectRatio: 3/5
                      ),
                      itemCount: resps != null? resps.length : 0,
                      itemBuilder: _getItem,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }

  Widget _getItem(context,index){
    // print("图片:${resps[index]["thumbnail"]},标题:${resps[index]["text"]}");
    return InkWell(
      onTap: (){
        print("播放视频");
        // 跳转页面
        Navigator.push(context, CupertinoPageRoute(builder: (ctx) => Video_Play(resps[index]["video"])));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                resps[index]["thumbnail"],
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 5,
              left: 2,
              child: Container(
                width: 150,
                child: myUtil.getClip(50, 50, Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(resps[index]["text"],style: TextStyle(fontSize: 13,color: Colors.white),),
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }


}