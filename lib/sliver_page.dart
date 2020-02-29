import 'package:flutter/material.dart';
import 'package:flutter_sliver/sliver_remaining_page.dart';
import 'services/pixabay_service.dart';

class SliverPage extends StatefulWidget {
  @override
  _SliverPageState createState() => _SliverPageState();
}

class _SliverPageState extends State<SliverPage> {
  List<PixabayImage> pixabayListImages = [];
  List<PixabayImage> pixabayGridImages = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getPixabayImages();
  }

  getPixabayImages() async {
    setState(() => loading = true);
    final listImages =
        await PixabayService.getPixabayPhotos('yellow flowers', 10);
    final gridImages = await PixabayService.getPixabayPhotos('red flowers', 30);
    setState(() {
      loading = false;
      pixabayListImages = listImages;
      pixabayGridImages = gridImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 100.0,
                  floating: true,
                  // pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Slivers Demo'),
                  ),

                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SliverRemainingPage();
                        }),
                      ),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    color: Colors.yellow,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Yellow Flowers',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int idx) {
                      final item = pixabayListImages[idx];
                      return Container(
                        width: double.infinity,
                        height: 200,
                        child: Image.network(
                          item.webformatURL,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    childCount: pixabayListImages.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Red Flowers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int idx) {
                      final item = pixabayGridImages[idx];
                      return Image.network(item.webformatURL,
                          fit: BoxFit.cover);
                    },
                    childCount: pixabayGridImages.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 1,
                  ),
                ),
              ],
            ),
    );
  }
}
