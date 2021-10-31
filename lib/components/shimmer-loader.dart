import 'package:flutter/material.dart';
import 'package:fumzy/utils/size-config.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {

  const ShimmerLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> containers = [];
    for(int i = 0; i < 20; i++){
      containers.add(
          Container(
              width: SizeConfig.screenWidth,
              height: 40,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: Color(0xFFF6F6F6)
              )
          )
      );
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(children: containers)
      ),
    );
  }

}
