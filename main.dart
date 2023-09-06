import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fav.dart';
import 'home.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite List Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}





import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:music_appp/model/album.dart';
import 'package:music_appp/screen/homedetails.dart';
import 'package:provider/provider.dart';

import '../fav_provider.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  Future<AlbumHome>? albumHomeFuture;

  @override
  void initState() {
    super.initState();
    albumHomeFuture = getAlbumViewData();
  }

  Future<AlbumHome> getAlbumViewData() async {
    try {
      const url = "https://www.kbmusique.com/api/albums.php";
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      final cleanedJson = body.substring(0, body.lastIndexOf('}') + 1);
      print(cleanedJson);
      AlbumHome GetList = albumHomeFromJson(cleanedJson);
      return GetList;
    } catch (e) {
      print('Error parsing JSON: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFf0eddd),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: AppBar(
            elevation: 0,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/img.png",
                    fit: BoxFit.cover,
                  ),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder<AlbumHome>(
          future: albumHomeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: ColorfulCircularProgressIndicator(
                colors: [Colors.blue, Colors.red, Colors.amber, Colors.green],
                strokeWidth: 5,
                indicatorHeight: 40,
                indicatorWidth: 40,
              ));
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData ||
                snapshot.data?.albums.isEmpty == true) {
              return const Center(
                child: Text('No data to show'),
              );
            } else {
              final albumHome = snapshot.data!;
              return GestureDetector(
                child: ListView.separated(
                  itemCount: albumHome.albums.length,
                  itemBuilder: (_, i) {
                    final album = albumHome.albums[i];
                    final rating = double.tryParse(album.rating) ?? 0;
                    final filledStars = rating.toInt();
                    final imageUrl =
                        "http://kbmusique.com/images/albums/${albumHome.albums[i].picture}";
                    final itemTitle = albumHome.albums[i].name;

                    final isFavorite = Provider.of<FavoriteProvider>(context)
                        .isItemFavorite(itemTitle);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeDetailsscreen(
                              name: albumHome?.albums[i].name ?? '',
                              year: albumHome?.albums[i].year ?? '',
                              bandName: albumHome?.albums[i].name ?? '',
                              picture: albumHome?.albums[i].picture ?? '',
                              rating: albumHome?.albums[i].rating ?? '',
                              id: albumHome?.albums[i].id ?? "",
                              bandId:
                                  albumHome?.albums[i].bandId.toString() ?? "",
                              updateFavoriteStatus: (isFavorite) {
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 20, left: 20, top: 5),
                                height: 120,
                                width: 120,
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/img.png',
                                  image: imageUrl,
                                  fit: BoxFit.cover,
                                  fadeInDuration:
                                      const Duration(milliseconds: 300),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 300),
                                  imageErrorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Image.network(imageUrl);
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                250), // Adjust the maxWidth as needed
                                        child: Text(
                                          albumHome.albums[i].name.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 19,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                HomeDetailsscreen(
                                              name: albumHome?.albums[i].name ??
                                                  '',
                                              year: albumHome?.albums[i].year ??
                                                  '',
                                              bandName:
                                                  albumHome?.albums[i].name ??
                                                      '',
                                              picture: albumHome
                                                      ?.albums[i].picture ??
                                                  '',
                                              rating:
                                                  albumHome?.albums[i].rating ??
                                                      '',
                                              bandId: albumHome
                                                      ?.albums[i].bandId
                                                      .toString() ??
                                                  "",
                                              updateFavoriteStatus:
                                                  (isFavorite) {
                                                setState(() {});
                                              },
                                              id: albumHome?.albums[i]
                                                  .toString(),
                                            ),
                                          ));
                                        },
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  albumHome.albums[i].year
                                                      .toString(),
                                                  style: GoogleFonts.lexend(
                                                      color: const Color(
                                                          0xFF616161),
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  albumHome.albums[i].bandName
                                                      .toString(),
                                                  style: GoogleFonts.lexend(
                                                      color: const Color(
                                                          0xFF616161),
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          ...List.generate(
                                            5, // Total number of stars
                                            (index) => Icon(
                                              Icons.star,
                                              color: index < filledStars
                                                  ? Colors.grey
                                                  : Colors.grey[400],
                                              size: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite,
                                    size: 32,
                                  ),
                                  color: isFavorite
                                      ? Colors.red
                                      : Color(0xFFBDBDBD),
                                  onPressed: () {
                                    final favoriteProvider =
                                        Provider.of<FavoriteProvider>(context,
                                            listen: false);

                                    if (isFavorite) {
                                      favoriteProvider
                                          .removeFromFavorites(itemTitle);
                                    } else {
                                      final year =
                                          albumHome.albums[i].year.toString();
                                      final bandName = albumHome
                                          .albums[i].bandName
                                          .toString();
                                      final imgUrl =
                                          "http://kbmusique.com/images/albums/${albumHome.albums[i].picture}";
                                      final rating = albumHome.albums[i].rating
                                          .toString(); // Add this line to get the rating

                                      favoriteProvider.addToFavorites(
                                          itemTitle,
                                          year,
                                          bandName,
                                          imgUrl,
                                          rating); // Pass the rating here
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: const Divider(
                      color: Colors.grey,
                      endIndent: 2,
                      indent: 2,
                      thickness: 1,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

=====================



  import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/songdetails.dart';
import 'package:http/http.dart' as http;

class HomeDetailsscreen extends StatefulWidget {
  final String? name;
  final String? year;
  final String? bandName;
  final String? picture;
  final String? rating;
  final String? bandId;
  final Function(bool) updateFavoriteStatus;
  final String? itemTitle;
  final String? id;
  const HomeDetailsscreen({
    super.key,
    this.name,
    this.year,
    this.bandName,
    this.picture,
    this.rating,
    this.bandId,
    required this.updateFavoriteStatus,
    this.itemTitle,
    required this.id,
  });

  @override
  State<HomeDetailsscreen> createState() => _HomeDetailsscreenState();
}

class _HomeDetailsscreenState extends State<HomeDetailsscreen> {
  BandDetails? bandDetails;
  bool isLoading = true;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  var song;

  // audioPlayerState = AudioPlayerState;
  @override
  void initState() {
    super.initState();
    getBandDetails();
    setAudio();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getBandDetails() async {
    try {
      bandDetails = await getBandDetailsFromApi(widget.id);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching band details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double parsedRating = double.tryParse(widget.rating ?? '0') ?? 0;
    int filledStars = parsedRating.toInt();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFf0eddd),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: AppBar(
            elevation: 0,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                    child: Image.asset(
                  "assets/img.png",
                  fit: BoxFit.cover,
                )),
                AppBar(
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: ColorfulCircularProgressIndicator(
                colors: [Colors.blue, Colors.red, Colors.amber, Colors.green],
                strokeWidth: 5,
                indicatorHeight: 40,
                indicatorWidth: 40,
              ))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      margin: const EdgeInsets.only(right: 0, left: 0, top: 5),
                      decoration: BoxDecoration(
                        color: Color(0xFFf0eddd),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  "http://kbmusique.com/images/albums/${widget.picture}",
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " ${widget.name}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          " ${widget.year}",
                                          style: GoogleFonts.lexend(
                                            color: const Color(0xFF616161),
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          " ${widget.bandName}",
                                          style: GoogleFonts.lexend(
                                            color: const Color(0xFF616161),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    for (int i = 0; i < 5; i++)
                                      Icon(
                                        Icons.star,
                                        color: i < filledStars
                                            ? Colors.grey
                                            : Colors.grey[400],
                                        size: 22,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: bandDetails?.songs.length ?? 0,
                      itemBuilder: (_, i) {
                        song = bandDetails?.songs[i];
                        String audioUrl =
                            "http://www.kbmusique.com/songs/${song?.sgUrl}";
                        String index = (i + 1).toString().padLeft(2, '0');

                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                '$index ${'   '}${song?.sgName.toString() ?? ""}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<BandDetails> getBandDetailsFromApi(String? id) async {
    final response = await http
        .get(Uri.parse('http://www.kbmusique.com/api/songs.php?id=$id'));
    print(response);
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return BandDetails.fromJson(decodedData);
    } else {
      throw Exception('Failed to load band details');
    }
  }

  Future<void> setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    String url =
        "https://storage.googleapis.com/uamp/The_Kyoto_Connection_-_Wake_Up/08_-_Reveal_the_Magic.mp3";
    await audioPlayer.setSourceUrl(url);
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, twoDigitMinutes, twoDigitSeconds]
        .join(':');
  }
}
