import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Image, ImageFilter, TextHeightBehavior;

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
class MyUtil {

  // appID
  String appId = "xxx";
  // appKey
  String appKey = "xxx";

  // 获取鉴权的方法
  Map<String,dynamic> getResSign(Map<String,dynamic> queryArgs){
    // 进行升序排列
    SplayTreeMap<String,dynamic> splayTreeMap = SplayTreeMap<String,dynamic>();
    splayTreeMap.addAll(queryArgs);
    // 拼接字符串
    StringBuffer strb = StringBuffer();
    splayTreeMap.forEach((key, value) {
      strb.write("${key}=${Uri.encodeFull(value.toString())}&");
    });
    strb.write("app_key=${this.appKey}");
    print("拼接的字符串 == ${strb}");
    // 进行md5运算
    Digest digest = md5.convert(utf8.encode(strb.toString()));
    print("计算的md5值:${digest.toString()}");
    // 将sign放到map中
    queryArgs["sign"] = digest.toString().toUpperCase();
    // 计算sign
    return queryArgs;
  }

  // 调用翻译的接口,返回的是响应对象
  Future<Map<String,dynamic>> getTranslate (String sourceText,String source,String target) async {
    // 如果输入的en或者fr需要空格的将空格转换为-
    if(source != "zh"){
      sourceText = sourceText.replaceAll(" ", "-");
    }
    print("sourceText==> ${sourceText},source ==> ${source},target ==> ${target}");
    // 时间戳
    String millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch.toString().substring(0,10);
    // 请求参数
    Map<String,dynamic> queryArgs = {
      "app_id": this.appId,
      "time_stamp": millisecondsSinceEpoch,
      "nonce_str": "fa44848ce34848578f9fe",
      "text": sourceText,
      "source": source,
      "target": target
    };
    Response resp = await Dio().post("https://api.ai.qq.com/fcgi-bin/nlp/nlp_texttranslate",queryParameters: getResSign(queryArgs));
    Map<String,dynamic> map = json.decode(resp.toString());
    // 获取sign
    return map;
  }

  // 调用文字转语音的接口
  Future<Map<String,dynamic>> getTTS(int speaker,int speed,String text,int aht,int apc) async {
    // 将空格转换为-
    text = text.replaceAll(" ", "-");
    // 时间戳
    String millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch.toString().substring(0,10);
    // 构造请求参数
    Map<String,dynamic> queryArgs = {
      "app_id": this.appId,
      "time_stamp": millisecondsSinceEpoch,
      "nonce_str": "fa8e3448578f9fe",
      /*
      普通话男声	1
      静琪女声	5
      欢馨女声	6
      碧萱女声	7
      */
      "speaker": speaker,  //选择发音人
      "format": 3, //返回语音的格式
      "volume": 10, //声音大小
      "speed": speed, //发音速度[50, 200]
      "text": text, //要转换的文字
      "aht": aht, //声音的音高[-24, 24]
      "apc": apc //声音音色[0, 100]
    };
    // 排序map,获取数据
    Response resp = await Dio().post("https://api.ai.qq.com/fcgi-bin/aai/aai_tts",queryParameters: getResSign(queryArgs));
    // 返回数据
    Map<String,dynamic> map = json.decode(resp.toString());
    // 获取sign
    return map;
  }

  // 调用获取视频的接口
  Future<Map<String, dynamic>> getVideos(int page) async {
    Response resp = await Dio().get("https://api.apiopen.top/getJoke?page=${page}&count=10&type=video");
    Map<String,dynamic> map = json.decode(resp.toString());
    return map;
  }

  // 调用的是获取笑话的接口
  Future<Map<String,dynamic>> getJoke() async {
    // 时间戳
    String millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch.toString().substring(0,10);
    // 构造请求参数
    Map<String,dynamic> queryArgs = {
      "app_id": this.appId,
      "time_stamp": millisecondsSinceEpoch,
      "nonce_str": "fa8e3448578f9fe",
      /*
      普通话男声	1
      静琪女声	5
      欢馨女声	6
      碧萱女声	7
      */
      "session": "1001",
      "question": "讲个笑话"
    };
    // 排序map,获取数据
    Response resp = await Dio().post("https://api.ai.qq.com/fcgi-bin/nlp/nlp_textchat",queryParameters: getResSign(queryArgs));
    // 返回数据
    Map<String,dynamic> map = json.decode(resp.toString());
    // 获取sign
    return map;
  }

  Future<String> createFileFromString(String base64Str) async {
    Uint8List bytes = base64.decode(base64Str);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("${dir}/${DateTime.now().millisecondsSinceEpoch.toString()}.mp3");
    file.writeAsBytes(bytes);
    return file.path;
  }

  // 获取模糊的背景
  Widget getCriClip(double sigmaX, double sigmaY,Widget child){
    return ClipOval(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: sigmaX,
            sigmaY: sigmaY
        ),
        child: child,
      ),
    );
  }

  Widget getClip(double sigmaX, double sigmaY,Widget child){
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

  Widget getRClip(double sigmaX, double sigmaY,Widget child){
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: sigmaX,
            sigmaY: sigmaY
        ),
        child: child,
      ),
    );
  }

  // 底部弹出的封装
  showBottomSheet(context,{Widget child}){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
            ),
            child: child == null? Column(
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
                        text: "为使用者提供优质的文字转语音服务。可为文学阅读等领域提供语音合成解决方案，让您摆脱纯文字的阅读。",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: "注意:输入内容尽量不要添加空格,最大长度限制在150字节内(大约50汉字)",
                              style: TextStyle(fontWeight: FontWeight.w600)
                          )
                        ]
                    ),
                  ),
                ),
              ],
            ) : child,
          );
        }
    );
  }

}