import 'dart:convert';

import 'package:hera_client/hera.pb.dart';

void dataTo(User user, dynamic dest){
    if(user.metadata != ""){
      dest = jsonDecode(user.metadata);
    }
}