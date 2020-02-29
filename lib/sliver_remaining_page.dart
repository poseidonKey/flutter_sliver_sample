import 'package:flutter/material.dart';
import 'services/pixabay_service.dart';

class SliverRemainingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Using SliverList'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              height: 60,
              color: Colors.yellow,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'White Flowers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: PixabayService.getPixabayPhotos('white flower', 10),
            builder: (BuildContext context,
                AsyncSnapshot<List<PixabayImage>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        '${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = snapshot.data[index];

                      return Container(
                        width: double.infinity,
                        height: 300,
                        child: Image.network(
                          item.webformatURL,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    childCount: snapshot.data.length,
                  ),
                );
              } else {
                return SliverFillRemaining(
                  child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
