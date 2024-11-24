import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:recipe/Provider/favorite_provider.dart';
import 'package:recipe/Provider/quantity.dart';
import 'package:recipe/Utils/constants.dart';
import 'package:recipe/Widget/my_icon_button.dart';
import 'package:recipe/Widget/quantity_increment_decrement.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeDetailScreen extends StatefulWidget {

  final DocumentSnapshot<Object?> documentSnapshot;

  const RecipeDetailScreen({super.key, required this.documentSnapshot});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {

  late YoutubePlayerController _youtubeController;



  @override
  void initState() {
    String videoUrl = widget.documentSnapshot['videoLink'];
    String? videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
    List<double> baseAmounts = widget.documentSnapshot['ingredientsAmount']
        .map<double>((amount) => double.parse(amount.toString()))
        .toList();
    Provider.of<QuantityProivder>(context, listen: false)
        .setBaseIngredientAmounts(baseAmounts);
    super.initState();
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final quantityProvider = Provider.of<QuantityProivder>(context);
    List<dynamic> cookingSteps = widget.documentSnapshot['cookingSteps'];

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {},
        label: Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 13),
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: Text(
                "Start Cooking",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              style: IconButton.styleFrom(
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
              ),
              onPressed: () {
                provider.toggleFavorite(widget.documentSnapshot);
              },
              icon: Icon(
                provider.isExist(widget.documentSnapshot)
                    ? Iconsax.heart5
                    : Iconsax.heart,
                color: provider.isExist(widget.documentSnapshot)
                    ? Colors.red
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                //for image
                Hero(
                  tag: widget.documentSnapshot['image'],
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.documentSnapshot['image'],
                        ),
                      ),
                    ),
                  ),
                ),
                //for back buton
                Positioned(
                  top: 40,
                  left: 10,
                  right: 30,
                  child: Row(
                    children: [
                      MyIconButton(
                          icon: Icons.arrow_back,
                          pressed: () {
                            Navigator.pop(context);
                          }),
                      Spacer(),
                      MyIconButton(icon: Iconsax.notification, pressed: () {}),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.height,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            //for drag handle
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.documentSnapshot['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.flash_1,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        "${widget.documentSnapshot['cal']} Cal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        " · ",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                        ),
                      ),
                      const Icon(
                        Iconsax.clock,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.documentSnapshot['time']} Min",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ingredients",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "How many servings?",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      QuantityIncrementDecrement(
                        currentNumber: quantityProvider.currentNumber,
                        onAdd: () => quantityProvider.increaseQuantity(),
                        onRemov: () => quantityProvider.decreaseQuantity(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // list of ingredients
                  Column(
                    children: [
                      Row(
                        children: [
                          //ingredients images
                          Column(
                            children: widget
                                .documentSnapshot['ingredientsImage']
                                .map<Widget>(
                                  (imageUrl) => Container(
                                    height: 60,
                                    width: 60,
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          imageUrl,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          //ingredients name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.documentSnapshot['ingredientsName']
                                .map<Widget>((ingredient) => SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          ingredient,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade400),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          Spacer(),
                          //ingredient amount
                          Column(
                            children: quantityProvider.updateIngredientAmounts
                                .map<Widget>((amount) => SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          "${amount}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "Cooking Steps",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cookingSteps.length,
                    itemBuilder: (context, index) {
                      return
                         Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                cookingSteps[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        );
                    },
                  ),
                  const SizedBox(height: 20),

                  // YouTube Video Player (now above cooking steps)
                  if (_youtubeController.initialVideoId.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: YoutubePlayer(
                        controller: _youtubeController,
                        showVideoProgressIndicator: true,
                        onReady: () {
                          print('YouTube Player is ready!');
                        },
                      ),
                    ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
