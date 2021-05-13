import 'dart:ui' as ui show Image, ImageFilter, TextHeightBehavior;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/pages/tts_convert_page.dart';
import 'package:flutter_app_test/util.dart';
import 'chat_view.dart';
import 'gain_joke.dart';
import 'translator.dart';

class Home_Screen extends StatelessWidget {

  // 资源的列表
  static const List<String> sourceList = ["assets/images/translator.jpg","assets/images/speach.jpg","assets/images/aichat.jpg","assets/images/viewchat.jpg"];
  List<TextSpan> textSpanList ;
  static const List<String> infos = [
    "结合了神经网络机器翻译和统计机器翻译的优点，对源语言文本进行深入理解，使翻译效果更为准确,大大减轻传统文本翻译的读写成本，翻译更轻松。",
    "为使用者提供优质的文字转语音服务。合成语音自然流畅。可为智能助手、智能机器人、文学阅读等领域提供语音合成解决方案，让您摆脱纯文字的阅读。",
    "实时段子基于免费的接口服务提供段视频播放服务,由于本接口是网络接口,不保证接口服务稳定长期可用,偶尔调用失败也很正常,",
    "笑话是一个汉语词汇，拼音是xiào hua，意思是引人发笑的话或事情。笑话具有篇幅短小，往往出人意料，给人突然之间笑神来了的奇妙感觉的特点。",
  ];
  // 需要的页面组件
  List<Widget> pages = [Translator(),TTS_Covert(),Chat_View(),Gain_Joke()];

  // 创建PageCOntroller
  PageController pageController = PageController(viewportFraction: 0.8);
  // 代表的是当前的页面
  int page_index = 0;
  double screen_width,screen_height;
  // 实例化工具类
  MyUtil myUtil = MyUtil();

  // 创建组件的主要方法
  @override
  Widget build(BuildContext context) {

    this.textSpanList = [
      _getTextSpan("智能","翻译"),
      _getTextSpan("合成","语音"),
      _getTextSpan("实时","段子"),
      _getTextSpan("获取","笑话"),
    ];

    Size size = MediaQuery.of(context).size;
    screen_width = size.width;
    screen_height = size.height;

    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/elephant.jpg"),
                fit: BoxFit.cover
            )
        ),
        child: Stack(
          children: [
            jianjie(context),
            cardFactory(context),
            Positioned(
              top: 100,
              right: 10,
              child: _getClip(50, 50, Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  child: RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      text: "欢迎!\n",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2
                      ),
                      children: [
                        TextSpan(
                            text: "Welcome to here!",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300)
                        )
                      ],
                    ),
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }

  // 返回模糊化的组件
  Widget _getClip(double sigmaX, double sigmaY,Widget child){
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: sigmaX,
            sigmaY: sigmaY
        ),
        child: child,
      ),
    );
  }
  // 制造卡片的factory
  Widget cardFactory(context){
    return Positioned(
      bottom: 0.03 * screen_height,
      child: Container(
        width: screen_width,
        height: 0.55 * screen_height,
        child: PageView.builder(
          itemCount: 4,
          controller: pageController,
          itemBuilder: (BuildContext context, int index) => _getCard(sourceList[index], textSpanList[index], infos[index],pages[index],context),
        ),
      ),
    );
  }
  // 简介按钮
  Widget jianjie(context){
    return Positioned(
      top: 40,
      right: 20,
      child: _getClip(50, 150, Container(
        width: 50,
        height: 50,
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
                        text: "本软件基于免费的接口服务进行开发,资源和服务来自于网络,本地不存储任何您的个人信息,可以放心使用,",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: "注意:免费的接口服务不保证永久有效",
                              style: TextStyle(fontWeight: FontWeight.w600)
                          )
                        ]
                    ),
                  ),
                ),
              ],
            ));
          },
          icon: Icon(Icons.menu,size: 28,color: Colors.white),
        ),
      )),
    );
  }
  // 卡片组件
  Widget _getCard(String source,TextSpan textSpan,String info,Widget page,context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Transform.scale(
      scale: 0.9,
      child: _getClip(50, 150, Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => page));
            },
            child: Container(
              height: 0.25 * screen_height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(source),
                      fit: BoxFit.cover
                  )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                    text: textSpan
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    info,
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2
                    ),
                  ),
                ),

                SizedBox(height: 10),

                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => page));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Text("立即使用",style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    ),
  );
  // 文字组件
  TextSpan _getTextSpan(String first,String second) => TextSpan(
    text: first,
    style: TextStyle(
      fontSize: 25,
      color: Colors.white70
    ),
    children: [
      TextSpan(
        text: second,
        style: TextStyle(
          fontSize: 25,
          color: Colors.white
        )
      )
    ]
  );
}