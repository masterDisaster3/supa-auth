

import 'package:auth/utilities/supagreen.dart';
import 'package:flutter/material.dart';

SnackBar snacks( String content){
  return SnackBar(
          content: Text(content,
              style: TextStyle(fontSize: 14, color: supaGreenColor)),
          backgroundColor: Colors.transparent,
        );
}