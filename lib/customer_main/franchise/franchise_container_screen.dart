import 'package:chipin/child/screen/child_appbar/ChildDrawerMenu.dart';
import 'package:chipin/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/size_utils.dart';
import '../../child/screen/menu_meals/meals.dart';
import '../../child/screen/menu_thanks/thanks.dart';
import '../client_appbar.dart';
import '../client_drawer_menu.dart';

class FranchiseContainerScreen extends StatefulWidget {
  final String title;
  final String location;
  final String time;
  final String banner;
  final String ownerId;

  const FranchiseContainerScreen({
    Key? key,
    required this.title,
    required this.location,
    required this.time,
    required this.banner,
    required this.ownerId,
  }) : super(key: key);
  // final Set<FranchiseContainerScreenState> _saved = new Set<FranchiseContainerScreenState>();
  @override
  FranchiseContainerScreenState createState() => FranchiseContainerScreenState(
    ownerId: ownerId,
      title: title, location: location, time: time, banner: banner
  );
}
User? getUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final name = user.displayName;
    final email = user.email;
    final photoUrl = user.photoURL;

    final emailVerified = user.emailVerified;
    final uid = user.uid;
  }
  return user;
}
class FranchiseContainerScreenState extends State<FranchiseContainerScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  // final bool alreadySaved = _saved.contains(pair);
  bool _isFavorite = false; // 즐겨찾기 상태
  final List<String> _favoriteItems = []; // 즐겨찾기 리스트
  User? user = FirebaseAuth.instance.currentUser;
  // List<Map<String, dynamic>> menuDataList = []; // 이 부분이 menuDataList 변수 선언입니다.

  late String _title = "";
  late String _location = "";
  late String _time = "";
  late String _banner = "";
  late String _ownerId = "";

  // 생성자를 추가하여 인자로 변수들을 받아옵니다.
  FranchiseContainerScreenState({
    required String ownerId,
    required String title,
    required String location,
    required String time,
    required String banner,
  }) {
    _ownerId = ownerId;
    _title = title;
    _location = location;
    _time = time;
    _banner = banner;
    // 나머지 변수들을 이용하여 원하는 작업 수행
  }
  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
  }
  // 식당 db에 차감 내역을 작성할 때 표기할 전체 포인트를 구하기 위해 필요 - earnlist의 값의 합에서 redeemlist의 값의 합을 뺌
  Future<num> readtotalPoint() async {
    num earnPoint = 0;
    num redeemPoint = 0;


    if (_ownerId != null) {
      final db = FirebaseFirestore.instance
          .collection("Restaurant")
          .doc(_ownerId);

      try {
        final queryEarnSnapshot = await db.collection("EarnList").get();

        if (queryEarnSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in queryEarnSnapshot.docs) {
            print('${docSnapshot.id} => ${docSnapshot.data()}');
            earnPoint += docSnapshot.data()['earnPoint'];
          }
        }
      } catch (e) {
        print("Error completing: $e");
      }

      try {
        final queryEarnSnapshot = await db.collection("RedeemList").get();

        if (queryEarnSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in queryEarnSnapshot.docs) {
            print('${docSnapshot.id} => ${docSnapshot.data()}');
            redeemPoint += docSnapshot.data()['redeemPoint'];
          }
        }
      } catch (e) {
        print("Error completing: $e");
      }
    }
    return earnPoint - redeemPoint;
  }
  // 팝업을 표시하는 함수
  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("예약 불가능"),
          content: const Text("이 식당은 현재 예약이 불가능합니다."),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: ClientAppBar(title: "가게정보"),
        endDrawer: const ClientDrawerMenu(),
        body: SizedBox(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: mediaQueryData.size.width, // Set the desired width
                  height: 200, // Set the desired height
                    child: Image.network(_banner,
                      fit: BoxFit.cover,)
                ),

                Padding(
                  padding: getPadding(
                    left: 26,
                    top: 27,
                    right: 22,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: getPadding(
                              left: 1,
                            ),
                            child: Text(
                                _title,
                              // user as String,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                                style: const TextStyle(fontSize:24, fontFamily: "Mainfonts",color: Colors.black)
                            ),
                          ),
                          Padding(
                            padding: getPadding(
                              top: 2,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.black,
                                  size: 19,
                                ),

                                Padding(
                                  padding: getPadding(
                                    left: 4,
                                  ),
                                  child: Text(
                                    _location,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    // style: CustomTextStyles
                                    //     .bodyLargePrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;

                          if (_isFavorite) {
                            _favoriteItems.add(_title); // 즐겨찾기 리스트에 아이템 추가
                          } else {
                            _favoriteItems.remove(_title); // 즐겨찾기 리스트에서 아이템 제거
                          }
                        });

                        // TODO: 즐겨찾기 리스트에 추가 또는 제거하는 동작 추가
                      },
                      backgroundColor: Colors.white,
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.black12,
                      ),
                    )
                    ],
                  ),
                ),
                Container(
                  margin: getMargin(
                    left: 21,
                    top: 24,
                    right: 21,
                  ),
                  padding: getPadding(
                    all: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color:  Color(0XFFB3BFCB).withOpacity(0.46)
                    color: const Color(0xFFB3BFCB).withOpacity(0.46)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: getPadding(
                          left: 1,
                          top: 1,
                          bottom: 3,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                Padding(
                                  padding: getPadding(
                                    left: 7,
                                    top: 3,
                                    bottom: 1,
                                  ),
                                  child: FutureBuilder<num>(
                                    future: readtotalPoint(),
                                    builder: (BuildContext context, AsyncSnapshot<num> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text(
                                          '십시일반 포인트 계산 중...',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        );
                                      } else if (snapshot.hasError) {
                                        return const Text(
                                          '십시일반 포인트를 가져오는 중 오류 발생',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        );
                                      } else {
                                        final totalPoint = snapshot.data ?? 0;
                                        final formattedPoint = totalPoint.toInt().toString();
                                        return Text(
                                          '십시일반 포인트 $formattedPoint원',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: getPadding(
                                left: 3,
                                top: 11,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_filled_rounded,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      left: 9,
                                      top: 1,
                                    ),
                                    child: Text(
                                      _time,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      // style: theme.textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: getVerticalSize(
                    59,
                  ),
                  width: double.maxFinite,
                  margin: getMargin(
                    top: 24,
                  ),
                  child: TabBar(
                    controller: tabviewController,
                    labelColor: const Color(0xFF292D32),
                    labelStyle: const TextStyle(),
                    unselectedLabelColor: const Color(0xFFB3BFCB),
                    unselectedLabelStyle: const TextStyle(),
                    indicatorColor: const Color(0xFFFFC95F),
                    tabs: const [
                      Tab(
                        child: Text(
                          "메뉴  보기",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Tab(
                        child: Text(
                          "감사 편지 읽기",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(
                    309,
                  ),
                  child: TabBarView(
                    controller: tabviewController,
                    children: [
                      MenuPage(restaurantId: _ownerId,), // Menu 데이터 전달),
                      thanks(restaurantId: _ownerId),
                      // menu3(),
                    ],
                  ),
                ),

              ],
            ),

          ),

        ),

      ),

    );
  }
}
