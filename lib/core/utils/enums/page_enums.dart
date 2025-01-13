import '../func/dekhao.dart';

enum PageType {
  none,
  institute,
  ;

  /// Handles null with [none] type.
  /// 
  /// If no meaningful name matches, [none] type is returned.
  factory PageType.fromMap(String type) {
    PageType pageType = PageType.none;

    for (var val in PageType.values) {
      if (val.name == type) return pageType;
    }
    return pageType;
  }
}

enum ChannelType {
  none,
  news,
  //help,
  complaint,
  //questionAns
  ;

  factory ChannelType.fromMap(String type){
    dekhao("Channel type string is $type");
    ChannelType channelType = ChannelType.none;

    for (final val in ChannelType.values) {
      if(val.name == type) {
        return val;
      } else {
        dekhao(" Did not match ChannelType.${val.name}");
      }
    }
    return channelType;
  }
}


enum PostType {
  none,
  news,
  complaint,
  //questionAns
  ;

  factory PostType.fromMap(String type){
    dekhao("Post type string is $type");
    PostType postType = PostType.none;

    for (final val in PostType.values) {
      if(val.name == type) {
        return val;
      } else {
        dekhao(" Did not match PostType.${val.name}");
      }
    }
    return postType;
  }
}


enum ThreadType {
  none,
  news,
  complaint,
  //questionAns
  ;

  factory ThreadType.fromMap(String type){
    dekhao("Post type string is $type");
    ThreadType threadType = ThreadType.none;

    for (final val in ThreadType.values) {
      if(val.name == type) {
        return val;
      } else {
        dekhao(" Did not match PostType.${val.name}");
      }
    }
    return threadType;
  }
}


enum ComplaintTag {
  none,
  opened,
  received,
  working,
  solved,
  reopened
  ;

  factory ComplaintTag.fromMap(String tag){
    dekhao("ComplaintTag type string is $tag");
    ComplaintTag complaintTag = ComplaintTag.none;

    for (final val in ComplaintTag.values) {
      if(val.name == tag) {
        return val;
      } else {
        dekhao(" Did not match ComplaintTag.${val.name}");
      }
    }
    return complaintTag;
  }
}
