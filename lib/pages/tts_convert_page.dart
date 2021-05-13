import 'package:audioplayer/audioplayer.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import '../util.dart';

class TTS_Covert extends StatefulWidget{

  @override
  _TTS_CovertState createState() => _TTS_CovertState();

}

class _TTS_CovertState extends State<TTS_Covert> {

  String mp3Path = ""; // 记录mp3文件的路径

  // 音乐播放控件
  AudioPlayer audioPlayer ;
  // 实例化一个工具类
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
    print("将会销毁页面!");
    // TODO: implement dispose
    super.dispose();
    this._targetInput.dispose();
    this._sourceInput.dispose();
    if(this.audioPlayer != null) {
      audioPlayer.stop();
    }
  }

  // /data/user/0/com.yutianhui.flutter_app_test/app_flutter/1599442479754.mp3

  @override
  void initState() {
    print("初始化界面");
    // TODO: implement initState
    super.initState();
    audioPlayer = AudioPlayer();
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
                    myUtil.showBottomSheet(context);
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
                      decoration: BoxDecoration(

                      ),
                      child: myUtil.getClip(150, 50, Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.0)
                          ),
                          child: TextField(
                              autofocus: true,
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
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 0.15*screen_height,
                      height: 0.15*screen_height,
                      child: myUtil.getCriClip(50, 50, GestureDetector(
                        onTap: () async {
                          // 判断内容是否是空的
                          if(_sourceInput.text == ""){
                            myUtil.showBottomSheet(context,child: Center(
                              child: Text("输入内容为空!",style: TextStyle(fontSize: 30)),
                            ));
                            return;
                          }
                          // 内容不为空调用接口
                          Map<String,dynamic> map = await myUtil.getTTS(6, 100, _sourceInput.text, 6, 52);
                          if(map["ret"] == 0){
                            // 保存文件,获取路径
                            mp3Path = (await myUtil.createFileFromString(map["data"]["speech"]));
                            print("播放文件的路径:${mp3Path}");
                            audioPlayer.stop();
                            // 播放文件
                            audioPlayer.play(mp3Path);
                            return;
                          }
                          myUtil.showBottomSheet(context,child: Center(
                            child: Text("接口调用失败,请重试!",style: TextStyle(fontSize: 30)),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.0)
                            ),
                            child: FlareActor("assets/anim/loading-animation-sun-flare.flr",alignment:Alignment.center, fit:BoxFit.contain, animation:"active"),
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




}