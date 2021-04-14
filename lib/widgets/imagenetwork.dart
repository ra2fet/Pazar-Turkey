import 'package:flutter/material.dart';

class ImageNetwork extends StatelessWidget {

  final url;
  final double height,width;
  const ImageNetwork({Key key, this.url, this.height= double.infinity, this.width= double.infinity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Image.network(
          url,width: width,height: height,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Center(child:CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes
                : null,),);
            // You can use LinearProgressIndicator or CircularProgressIndicator instead
          },
          errorBuilder: (context, error, stackTrace) =>
              Container(width: width,height: height, color: Colors.grey.withOpacity(0.75),child: Center(child: Text('لا يوجد صورة',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)))),
      
          );
  }
}