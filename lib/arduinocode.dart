import 'package:control_arduino/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/github.dart';

class CodeHighlight extends StatefulWidget {
  const CodeHighlight(this.index, this.code,this.language, {super.key});
  final int index;
  final String code;
  final String language;
  

  @override
  State<CodeHighlight> createState() => _CodeHighlightState();
}

class _CodeHighlightState extends State<CodeHighlight> {
  @override
  Widget build(BuildContext context) {
    print('index = ${widget.index}');
   

    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: (widget.index==1)? Text('Arduino Code'):Text('Flutter Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HighlightView(
              // The original code to be highlighted
              widget.code,

              // Specify language
              // It is recommended to give it a value for performance
              language: widget.language,

              // Specify highlight theme
              // All available themes are listed in `themes` folder
              theme: githubTheme,

              // Specify padding
              padding: const EdgeInsets.all(12),

              // Specify text style
              textStyle: const TextStyle(
                // fontFamily: 'My awesome monospace font',
                //color: Colors.amber,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
