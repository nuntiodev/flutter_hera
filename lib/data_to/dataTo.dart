import 'dart:convert';

import 'package:nuntio_blocks/block_user.pb.dart';

void dataTo(User user, dynamic dest){
    if(user.metadata != ""){
      dest = jsonDecode(user.metadata);
    }
}