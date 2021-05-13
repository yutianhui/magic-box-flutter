import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_test/util.dart';

class Translator extends StatefulWidget{
  @override
  _TranslatorState createState() => _TranslatorState();
}

class _TranslatorState extends State<Translator> {
  // 实例化工具类
  MyUtil myUtil = MyUtil();
  // 文本框的控制器
  TextEditingController _targetInput = TextEditingController();
  TextEditingController _sourceInput = TextEditingController();
  // 源语言的选择
  String sourceEncoding = "auto";
  String sourceText = "自动识别";
  // 目标语言的选择
  String targetEncoding = "en";
  String targetText = "英文";
  double screen_width,screen_height;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this._targetInput.dispose();
    this._sourceInput.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(screen_height == null){
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
            menu(),
            mainWidget()
          ],
        ),
      ),
    );
  }

  Widget menu(){
    return Positioned(
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
                        text: "结合了神经网络机器翻译和统计机器翻译的优点，对源语言文本进行深入理解，使翻译效果更为准确,",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: "注意:选择中文的时候尽量不要加空格",
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
    );
  }

  Widget mainWidget(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputText(),
            SizedBox(height: 15),
            choose(),
            SizedBox(height: 15),
            outputText()
          ],
        ),
      ),
    );
  }
  // 拆分的模块
  Widget inputText(){
    return Container(
      width: double.infinity,
      height: 0.25*screen_height,
      decoration: BoxDecoration(

      ),
      child: myUtil.getClip(150, 50, Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0)
          ),
          child: TextField(
              autofocus: false,
              controller: _sourceInput,
              style: TextStyle(fontSize: 22,color: Colors.white),
              maxLines: 8,
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  hintText: "请输入...",
                  hintStyle: TextStyle(color: Colors.white),
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none
              )
          ),
        ),
      )),
    );
  }

  Widget outputText(){
    return Container(
      width: double.infinity,
      height: 0.28*screen_height,
      decoration: BoxDecoration(

      ),
      child: myUtil.getClip(50, 50, Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0)
          ),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: double.infinity,
                  height: 0.2 * screen_height,
                  child: TextField(
                      controller: _targetInput,
                      style: TextStyle(fontSize: 22,color: Colors.white),
                      maxLines: 8,
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none
                      )
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: InkWell(
                  onTap: (){
                    Clipboard.setData(ClipboardData(text: _targetInput.text));
                    myUtil.showBottomSheet(context,child: Center(child: Text("文本已经复制!",style: TextStyle(fontSize: 30))));
                  },
                  child: Container(
                    width: 0.07 * screen_height,
                    height: 0.07 * screen_height,
                    child: Icon(Icons.content_copy,color: Colors.white,),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget choose(){
    return Container(
      width: double.infinity,
      height: 0.1*screen_height,
      decoration: BoxDecoration(
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: myUtil.getClip(50, 150, Container(
              margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
              child: DropdownButton(
                icon: Icon(Icons.arrow_drop_down,color: Colors.white70,),
                underline: Text(""),
                onChanged: (val){
                  sourceEncoding = val;
                  String temp = "";
                  switch(val){
                    case "auto":
                      temp = "自动识别";
                      break;
                    case "zh":
                      temp = "中文";
                      break;
                    case "en":
                      temp = "英文";
                      break;
                    case "fr":
                      temp = "法文";
                      break;
                  }
                  // 设置状态
                  setState(() {
                    sourceText = temp;
                  });
                },
                hint: Text(sourceText,style: TextStyle(color: Colors.white70),),
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                    value: "auto",
                    child: Text("自动识别"),
                  ),
                  DropdownMenuItem(
                    value: "zh",
                    child: Text("中文"),
                  ),
                  DropdownMenuItem(
                    value: "en",
                    child: Text("英文"),
                  ),
                  DropdownMenuItem(
                    value: "fr",
                    child: Text("法文"),
                  ),

                ],
              ),
            )),
          ),
          Container(
            child: myUtil.getCriClip(150, 80, Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(

              ),
              child: InkWell(
                onTap:  () async {
                  if(_sourceInput.text == ""){
                    myUtil.showBottomSheet(context,child: Center(child: Text("输入内容为空!",style: TextStyle(fontSize: 30))));
                    return ;
                  }
                  print(DateTime.now().millisecondsSinceEpoch);
                  Future<Map<String,dynamic>> resSign = myUtil.getTranslate(_sourceInput.text, sourceEncoding, targetEncoding);
                  // 发送请求
                  resSign.then((value){
                    if(value["ret"] == 0){
                      _targetInput.text = value["data"]["target_text"];
                    }else{
                      myUtil.showBottomSheet(context,child: Center(child: Text("接口调用出现问题,请重试!",style: TextStyle(fontSize: 30))));
                      _targetInput.text = "";
                    }
                  }).catchError((ero){
                    myUtil.showBottomSheet(context,child: Center(child: Text("接口调用出现问题,请重试!",style: TextStyle(fontSize: 30))));
                    _targetInput.text = "";
                  });
                },
                child: Icon(Icons.swap_horiz,size: 45,color: Colors.white,),
              ),
            )),
          ),
          Container(
            child: myUtil.getClip(50, 150, Container(
              margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
              child: DropdownButton(
                icon: Icon(Icons.arrow_drop_down,color: Colors.white70,),
                underline: Text(""),
                onChanged: (val){
                  String temp = "";
                  targetEncoding = val;
                  switch(val){
                    case "zh":
                      temp = "中文";
                      break;
                    case "en":
                      temp = "英文";
                      break;
                    case "fr":
                      temp = "法文";
                      break;

                  }
                  // 设置状态
                  setState(() {
                    targetText = temp;
                  });
                },
                hint: Text(targetText,style: TextStyle(color: Colors.white70),),
                items: <DropdownMenuItem<String>>[

                  DropdownMenuItem(
                    value: "zh",
                    child: Text("中文"),
                  ),
                  DropdownMenuItem(
                    value: "en",
                    child: Text("英文"),
                  ),
                  DropdownMenuItem(
                    value: "fr",
                    child: Text("法文"),
                  ),

                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

}