import 'package:flutter/material.dart';
import '../tab_container_screen/tab_container_screen.dart';

/// Content of the DraggableBottomSheet's child SingleChildScrollView
class CustomScrollViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: CustomInnerContent(),
      ),
    );
  }
}

class CustomInnerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 12),
        CustomDraggingHandle(),
        SizedBox(height: 16),
        ResultText(),
        SizedBox(height: 16),
        ScrollingRestaurants(),
      ],
    );
  }
}

class CustomDraggingHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 50,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    );
  }
}

class ScrollingRestaurants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomRestaurantCategory("오양칼국수", "충청남도 보령시 오천면",
                "오후 8:00시까지 영업", "assets/images/ohyang_restaurant.png"),
            DivideLine(),
            SizedBox(height: 20),
            CustomRestaurantCategory("권영철 콩짬뽕", "충청남도 보령시 오천면",
                "오후 6:30시까지 영업", "assets/images/kongjjamppong.png"),
            DivideLine(),
            SizedBox(height: 20),
            CustomRestaurantCategory("정통집", "대전광역시 유성구 온천1동",
                "오후 10:00시까지 영업", "assets/images/originalhouse.png"),
            DivideLine(),
            SizedBox(height: 20),
            CustomRestaurantCategory("훈불", "대전광역시 유성구 궁동", "오후 8:00시까지 영업",
                "assets/images/handsomefire.png"),
            DivideLine(),
            SizedBox(height: 20),
            CustomRestaurantCategory("팔각도 대전괴정롯데점", "대전광역시 서구 괴정동",
                "오후 8:00시까지 영업", "assets/images/eightangle.png"),
           
          ],
        ),
      ),
    );
  }
}

class DivideLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: 350, child: Divider(color: Colors.grey, thickness: 1.0)));
  }
}

class ResultText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      //only to left align the text
      child: Row(
        children: <Widget>[
          Text("13개 결과",
              style: TextStyle(fontFamily: "Mainfonts", fontSize: 14))
        ],
      ),
    );
  }
}

class CustomRestaurantCategory extends StatelessWidget {
  final String title;
  final String location;
  final String time;
  final String image;

  const CustomRestaurantCategory(
      this.title, this.location, this.time, this.image);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          width : 340,
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                    /// 수정 필요
                    // 각각 해당하는 가게 정보로 넘어가야함.
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TabContainerScreen()));
                    },
                    child: Container(
                        height: 90,
                        width: 90,
                        child: Image(
                          image: AssetImage(image),
                          fit: BoxFit.fill,
                        ))),
                SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      style: TextStyle(
                          fontFamily: "Mainfonts",
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, size: 20),
                      SizedBox(width: 8),
                      Text(location,
                          style:
                              TextStyle(fontFamily: "Pretendard", fontSize: 15))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.access_time_filled, size: 20),
                      SizedBox(width: 8),
                      Text(time,
                          style:
                              TextStyle(fontFamily: "Pretendard", fontSize: 15))
                    ],
                  ),
                ]),
              ],
            ),
            Container(
              height: 40,
              width: 40,
              child: Icon(Icons.favorite, size: 12, color: Colors.black54),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(100)),
            ),
          ],
        )));
  }
}

class CustomFeaturedItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
