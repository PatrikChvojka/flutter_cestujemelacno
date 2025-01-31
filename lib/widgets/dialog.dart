import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:photo_view/photo_view.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, type, mainIcon;

  const CustomDialogBox({required this.title, required this.descriptions, required this.type, required this.mainIcon});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 15),
          margin: EdgeInsets.only(top: 35),
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
            BoxShadow(color: Colors.black12, offset: Offset(10, 10), blurRadius: 10),
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "X",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromRGBO(22, 97, 174, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              widget.type == "text"
                  ? Container(
                      height: 400,
                      child: SingleChildScrollView(
                        child: Html(
                          data: widget.descriptions,
                          style: {
                            "body": Style(
                              margin: Margins.all(0),
                            ),
                            "p": Style(
                              padding: HtmlPaddings.all(0),
                              fontSize: FontSize(14),
                              lineHeight: LineHeight(1.6),
                              fontWeight: FontWeight.w400,
                            )
                          },
                        ),
                      ),
                    )
                  : Container(
                      // height: MediaQuery.of(context).size.height - 400,
                      height: 400,
                      child: ClipRect(
                        child: PhotoView(
                          initialScale: PhotoViewComputedScale.contained,
                          basePosition: Alignment.center,
                          backgroundDecoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          imageProvider: NetworkImage(
                            widget.descriptions,
                          ),
                        ),
                      )),
              SizedBox(
                height: 22,
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35,
            child: ClipRRect(
                child: widget.mainIcon != "" ? Image.asset(height: 25.0, "lib/assets/images/" + widget.mainIcon + ".png") : Image.asset(height: 35.0, "lib/assets/images/info.png")),
          ),
        ),
      ],
    );
  }
}
