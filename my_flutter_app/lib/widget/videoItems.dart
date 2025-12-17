import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';


class VideoItems extends StatefulWidget{
  const VideoItems({
    required this.videoPlayerController,
    required this.looping, required this.autoplay,
    Key? key,
  }) : super(key: key);
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;


  @override 
  _VideoItemsState createState() =>_VideoItemsState();

}
class _VideoItemsState extends State<VideoItems> {
  ChewieController? _chewieController;
  @override
  void initState(){
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        );
      },


    );

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController!,
        ),


    );
  }





  @override
  void dispose(){
    super.dispose(); 
    _chewieController?.dispose();
  }
}