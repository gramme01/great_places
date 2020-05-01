import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import '../providers/great_places.dart';
import '../screens/place_details_screen.dart';

class PlacesListScreen extends StatelessWidget {
  Widget _childBuilder(context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Got no places yet, start adding some!',
            style: TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 12.0),
          FlatButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
            child: const Text(
              'Start Adding',
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(
          context,
          listen: false,
        ).fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<GreatPlaces>(
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlaces.items[i].image),
                          ),
                          title: Text(greatPlaces.items[i].title),
                          subtitle: Text(greatPlaces.items[i].location.address),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlaceDetailScreen.routeName,
                              arguments: greatPlaces.items[i].id,
                            );
                          },
                        ),
                        itemCount: greatPlaces.items.length,
                      ),
                child: _childBuilder(context),
              ),
      ),
    );
  }
}
