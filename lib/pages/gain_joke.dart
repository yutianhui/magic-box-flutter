import 'package:flutter/material.dart';

import '../util.dart';

class Gain_Joke extends StatefulWidget{

  @override
  _Gain_Joke createState() => _Gain_Joke();

}

class _Gain_Joke extends State<Gain_Joke> {

  String mp3Path = ""; // 记录mp3文件的路径
  // 实例化一个工具类
  MyUtil myUtil = MyUtil();
  // 文本框的控制器
  TextEditingController _sourceInput = TextEditingController();

  double screen_width,screen_height;

  @override
  void dispose() {
    print("将会销毁页面!");
    // TODO: implement dispose
    super.dispose();
    this._sourceInput.dispose();

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    Size size = MediaQuery.of(context).size;
    screen_width = size.width;
    screen_height = size.height;

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
                                text: "从网络上获取的冷笑话,",
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: "注意:不好笑不要怪我",
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
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 0.25*screen_height,
                      child: myUtil.getClip(150, 50, Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.0)
                          ),
                          child: TextField(
                              enabled: true,
                              autofocus: true,
                              controller: _sourceInput,
                              style: TextStyle(fontSize: 18,color: Colors.white),
                              maxLines: 8,
                              decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.white),
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none
                              )
                          ),
                        ),
                      )),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 0.15*screen_height,
                      height: 0.15*screen_height,
                      child: myUtil.getCriClip(50, 50, GestureDetector(
                        onTap: () async {
                          // 请求数据
                          Map<String,dynamic> resultMap = await myUtil.getJoke();
                          // 判断是否需要显式数据
                          if(resultMap["ret"] == 0){
                            // 请求成功,展示数据
                            _sourceInput.text = resultMap["data"]["answer"];
                            return;
                          }
                          myUtil.showBottomSheet(context,child: Center(child: Text("接口调用失败,请重试!",style: TextStyle(fontSize: 30,color: Colors.white))));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.0)
                            ),
                            child: Icon(Icons.cloud_download,size: 55,color: Colors.white,),
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 底部的弹出框


}