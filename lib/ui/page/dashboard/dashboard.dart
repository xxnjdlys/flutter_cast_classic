import 'package:flutter/material.dart';
import 'package:flutter_cast_classic/ui/page/dashboard/dashboard_menu_row.dart';
import 'package:flutter_cast_classic/utils/uidata.dart';
import 'package:flutter_cast_classic/widgets/login_background.dart';
import 'package:flutter_cast_classic/widgets/profile_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardPage extends StatefulWidget {
  @override
  DashboardPageState createState() {
    return new DashboardPageState();
  }
}

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
  })  : _icon = icon,
        _color = color,
        _title = title,
        item = new BottomNavigationBarItem(
          icon: icon,
          activeIcon: activeIcon,
          title: new Text(title),
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(
      BottomNavigationBarType type, BuildContext context) {
    Color iconColor;

    if (type == BottomNavigationBarType.fixed) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: new IconTheme(
          data: new IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: new Semantics(
            label: 'Placeholder for $_title tab',
            child: _icon,
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class CustomInactiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
        margin: const EdgeInsets.all(4.0),
        width: iconTheme.size - 8.0,
        height: iconTheme.size - 8.0,
        decoration: new BoxDecoration(
          border: new Border.all(color: iconTheme.color, width: 2.0),
        ));
  }
}

class DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  Size deviceSize;
  int _currentIndex = 0;

  final BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  List<NavigationIconView> _navigationViews;
  FocusScopeNode _searchFieldFocus;

  @override
  void initState() {
    super.initState();

    _searchFieldFocus = FocusScopeNode();

    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.access_alarm),
        title: 'Browser',
//        color: Colors.deepPurple,
        vsync: this,
      ),
      new NavigationIconView(
        activeIcon: const Icon(Icons.cloud),
        icon: const Icon(Icons.cloud_queue),
        title: 'More',
//        color: Colors.teal,
        vsync: this,
      ),
//      new NavigationIconView(
//        activeIcon: new CustomIcon(),
//        icon: new CustomInactiveIcon(),
//        title: 'Box',
//        color: Colors.deepOrange,
//        vsync: this,
//      ),
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void didUpdateWidget(DashboardPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
    _searchFieldFocus.detach();
    super.dispose();
  }

  Widget appBarColumn(BuildContext context) => SafeArea(
        child: Padding(
//          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
          padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: new ProfileTile(
                      title: "Cast Classic",
                      subtitle: "",
                      textColor: Colors.white,
                    ),
                  ),
                  new IconButton(
                    icon: new Icon(
                      Icons.tv,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      print("hi");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget searchCard() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 1.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
//                Icon(Icons.search),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter video name or URL to cast"),
                  ),
                ),
                Icon(Icons.search),
              ],
            ),
          ),
        ),
      );

  Widget actionMenuCard() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DashboardMenuRow(
                    firstIcon: FontAwesomeIcons.solidUser,
                    firstLabel: "Watch history",
                    firstIconCircleColor: Colors.blue,
                    secondIcon: FontAwesomeIcons.userFriends,
                    secondLabel: "Bookmarks",
                    secondIconCircleColor: Colors.orange,
                    thirdIcon: FontAwesomeIcons.mapMarkerAlt,
                    thirdLabel: "Local Videos",
                    thirdIconCircleColor: Colors.purple,
                    fourthIcon: FontAwesomeIcons.locationArrow,
                    fourthLabel: "Local Picture",
                    fourthIconCircleColor: Colors.indigo,
                  ),
//                  balanceCard(),
                  DashboardMenuRow(
                    firstIcon: FontAwesomeIcons.images,
                    firstLabel: "Albums",
                    firstIconCircleColor: Colors.red,
                    secondIcon: FontAwesomeIcons.solidHeart,
                    secondLabel: "Likes",
                    secondIconCircleColor: Colors.teal,
                    thirdIcon: FontAwesomeIcons.solidNewspaper,
                    thirdLabel: "Articles",
                    thirdIconCircleColor: Colors.lime,
                    fourthIcon: FontAwesomeIcons.solidCommentDots,
                    fourthLabel: "Reviews",
                    fourthIconCircleColor: Colors.amber,
                  ),
                  DashboardMenuRow(
                    firstIcon: FontAwesomeIcons.footballBall,
                    firstLabel: "Sports",
                    firstIconCircleColor: Colors.cyan,
                    secondIcon: FontAwesomeIcons.solidStar,
                    secondLabel: "Fav",
                    secondIconCircleColor: Colors.redAccent,
                    thirdIcon: FontAwesomeIcons.blogger,
                    thirdLabel: "Blogs",
                    thirdIconCircleColor: Colors.pink,
                    fourthIcon: FontAwesomeIcons.wallet,
                    fourthLabel: "Wallet",
                    fourthIconCircleColor: Colors.brown,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildMainFragment() => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          LoginBackground(
            showIcon: false,
          ),
          allCards(context),
        ],
      );

  Widget buildMoreFragment() => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: new Scaffold(
          appBar: new AppBar(
            actions: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: new IconButton(
                  icon: new Icon(
                    Icons.tv,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print("hi");
                  },
                ),
              ),
            ],
            centerTitle: true,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: new Text(
              "More",
              style: TextStyle(
                fontFamily: UIData.ralewayFont,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 8.0),
                      child: DashboardMenuRow(
                        firstIcon: FontAwesomeIcons.video,
                        firstLabel: "Local Video",
                        firstIconCircleColor: Colors.cyan,
                        secondIcon: FontAwesomeIcons.music,
                        secondLabel: "Local Music",
                        secondIconCircleColor: Colors.redAccent,
                        thirdIcon: FontAwesomeIcons.image,
                        thirdLabel: "Local Images",
                        thirdIconCircleColor: Colors.pink,
                        fourthIcon: FontAwesomeIcons.folder,
                        fourthLabel: "Local Files",
                        fourthIconCircleColor: Colors.brown,
                      ),
                    )),
                Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 8.0),
                      child: Column(
                        children: <Widget>[
                          normalOptionItem(
                            Icon(
                              Icons.message,
                              color: Colors.orange,
                            ),
                            "Join our gourp on Messenger",
                          ),
                          normalOptionItem(
                            Icon(
                              Icons.call,
                              color: Colors.orange,
                            ),
                            "Join our group on What's App",
                          ),
                          normalOptionItem(
                            Icon(
                              Icons.feedback,
                              color: Colors.orange,
                            ),
                            "Help & Feedback",
                          ),
                          normalOptionItem(
                            Icon(
                              Icons.share,
                              color: Colors.orange,
                            ),
                            "Share to friend",
                          ),
                          normalOptionItem(
                            Icon(
                              Icons.account_box,
                              color: Colors.orange,
                            ),
                            "About",
                          ),
                        ],
                      ),
                    )),
                normalCard(),
                normalCard(),
                normalCard(),
                normalCard(),
                normalCard(),
                normalCard(),
              ],
            ),
          )));

  Widget normalOptionItem(Icon icon, String text) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            icon,
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      );

  Widget normalCard() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Ad Title",
                      style: TextStyle(
                        fontFamily: UIData.ralewayFont,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Material(
                      color: Colors.black,
                      shape: StadiumBorder(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          left: 24.0,
                          right: 24.0,
                        ),
                        child: Text(
                          "View Details",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: UIData.ralewayFont),
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  "This is Desc",
                  style: TextStyle(
                      fontFamily: UIData.ralewayFont,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      );

  Widget allCards(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            appBarColumn(context),
            SizedBox(
              height: deviceSize.height * 0.01,
            ),
            searchCard(),
            SizedBox(
              height: deviceSize.height * 0.01,
            ),
            actionMenuCard(),
            SizedBox(
              height: deviceSize.height * 0.01,
            ),
            normalCard(),
            normalCard(),
            normalCard(),
            normalCard(),
            normalCard(),
            normalCard(),
          ],
        ),
      );

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  static const int BROWSER = 0;
  static const int MORE = 1;

  Widget _getCurrentFragment(int position) {
    Widget widget;
    switch (position) {
      case BROWSER:
        widget = buildMainFragment();
        break;
      case MORE:
        widget = buildMoreFragment();
        break;
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;

    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      fixedColor: Colors.orange,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return Scaffold(
      body: _getCurrentFragment(_currentIndex),
      bottomNavigationBar: botNavBar,
    );
  }
}
