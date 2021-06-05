import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:selth/models/model.dart';
import 'package:selth/util/flick_multi_manager.dart';
import 'package:selth/util/flick_multi_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selth/providers/provider.dart';
import 'package:selth/theme/colors.dart';
import 'package:selth/util/account_images_json.dart';
import 'package:selth/util/bottom_navigation_bar_json.dart';
import 'package:selth/util/constant.dart';
import 'package:instagram_public_api/instagram_public_api.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'account_page.dart';
part 'new_post_page.dart';
part 'root_app.dart';
part 'post_page.dart';
part 'auth_page.dart';
