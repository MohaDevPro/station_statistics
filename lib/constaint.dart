import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomDialog extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Function confirmButton;
  final bool cancelButton;
  final String? cancelButtonTitle;
  final String? confirmButtonTitle;
  final String? description;
  final Color color;
  final List<Widget>? widgets;

  const CustomDialog({
    Key? key,
    required this.message,
    this.icon,
    required this.confirmButton,
    this.cancelButton = true,
    this.confirmButtonTitle,
    this.cancelButtonTitle,
    this.description,
    this.widgets,
    this.color = Colors.amberAccent,
  }) : super(key: key);
  // f(AnimationController controller){
  //   return controller;
  // }
  // AnimationController controller = AnimationController(vsync: this);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    color: color),
                child: Icon(
                  icon ?? Icons.warning_amber_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                height: 100,
                width: Get.width,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.normal),
                  ),
                ),
              if (description != null)
                SizedBox(
                  height: 15,
                ),
              if (widgets != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: widgets!,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
              if (widgets != null)
                SizedBox(
                  height: 15,
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    if (cancelButton)
                      TextButton(
                        onPressed: () async {
                          Get.back();
                        },
                        // style: ButtonStyle(
                        //     shape: MaterialStateProperty.all(
                        //         RoundedRectangleBorder(
                        //             borderRadius:
                        //                 BorderRadius
                        //                     .circular(
                        //                         5),
                        //             side: BorderSide(
                        //                 color: Colors
                        //                     .deepblue)))),
                        child: Text(cancelButtonTitle ?? 'لا'),
                      ),
                    TextButton(
                      onPressed: confirmButton as void Function()?,
                      child: Text(confirmButtonTitle ?? 'نعم'),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  final bool half;
  bool small;
  bool scaff;
  final String? message;
  LoadingScreen({
    Key? key,
    this.half = false,
    this.message,
    this.small = false,
    this.scaff = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    small = true;
    return scaff
        ? Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    width: small
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width,
                    height: small
                        ? MediaQuery.of(context).size.width / 3
                        : MediaQuery.of(context).size.height,
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 2,
                          maxHeight: MediaQuery.of(context).size.width / 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: small
                          ? EdgeInsets.all(20)
                          : half
                              ? EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 3,
                                  vertical:
                                      MediaQuery.of(context).size.width / 3)
                              : EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 4.5,
                                  vertical:
                                      MediaQuery.of(context).size.width / 1.7),
                      width: small
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width / 2,
                      height: small
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: darkColor,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            message != null ? message! : "...Loading",
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.normal),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Center(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2,
                      maxHeight: MediaQuery.of(context).size.width / 2),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black54,width: 3),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black,
                    //     blurRadius: 1,
                    //     spreadRadius: 1,
                    //     // offset: Offset(2, 0.6),
                    //   )
                    // ],
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  width: small
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width,
                  height: small
                      ? MediaQuery.of(context).size.width / 3
                      : MediaQuery.of(context).size.height,
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black54,width: 3),
                      borderRadius: BorderRadius.circular(15),
                      // color: Colors.black,
                    ),
                    margin: small
                        ? EdgeInsets.all(20)
                        : half
                            ? EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 3,
                                vertical: MediaQuery.of(context).size.width / 3)
                            : EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 4.5,
                                vertical:
                                    MediaQuery.of(context).size.width / 1.7),
                    width: small
                        ? MediaQuery.of(context).size.width / 3
                        : MediaQuery.of(context).size.width / 2,
                    height: small
                        ? MediaQuery.of(context).size.width / 3
                        : MediaQuery.of(context).size.width / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: darkColor,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          message != null ? message! : "Loading...",
                          style: facilityTitle.copyWith(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

const darkColor = Color(0xFF391847);
var facilityTitle = TextStyle(
  color: Colors.black,
  fontSize: 14,
  // fontFamily: 'Cairo',
  fontWeight: FontWeight.w600,
  height: 1.5,
);
