import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music/blocs/global.dart';
import 'package:music/models/playerstate.dart';
import 'package:provider/provider.dart';
import '../globals.dart';

class MyCard extends StatelessWidget {
  final Song _song;
  String _duration;

  MyCard({Key key, @required Song song})
      : _song = song,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc store = Provider.of<GlobalBloc>(context);

    parseDuration();
    return StreamBuilder(
      stream: store.musicPlayerBloc.playerState$,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final PlayerState _state = snapshot.data.key;
        final Song _currentSong = snapshot.data.value;
        final bool _isSelectedSong = _song == _currentSong;
        return AnimatedContainer(
          height: 70,
          duration: Duration(milliseconds: 250),
          decoration: _isSelectedSong
              ? BoxDecoration(
                  color: MyTheme.darkRed.withOpacity(0.7),
                )
              : BoxDecoration(),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(1.0),
                        child: FadeInImage(
                          fadeInDuration: Duration(milliseconds: 50),
                          fadeOutDuration: Duration(milliseconds: 50),
                          image: AssetImage(_song.albumArt != null
                              ? _song.albumArt
                              : "images/default_track.png"),
                          placeholder: AssetImage("images/default_track.png"),
                          fit: BoxFit.fitHeight,
                        ),
                        // child: Text("image"),
                        // child: Image.asset(this.image),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              _song.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: MyTheme.grey700,
                              ),
                            ),
                          ),
                          Text(
                            getArtists(_song.artist),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  _duration,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void parseDuration() {
    final double _temp = _song.duration / 1000;
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      _duration = _minutes.toString() + ":" + _seconds.toString();
    } else {
      _duration = _minutes.toString() + ":0" + _seconds.toString();
    }
  }

  String getArtists(artists) {
    return artists.split(";").reduce((String a, String b) {
      return a + " & " + b;
    });
  }
}
