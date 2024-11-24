import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe/Utils/constants.dart';
import 'package:recipe/Widget/food_items_display.dart';
import 'package:recipe/Widget/my_icon_button.dart';

class ViewAllItems extends StatefulWidget {
  const ViewAllItems({super.key});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  final CollectionReference completeApp =
  FirebaseFirestore.instance.collection("Dishes");

  String searchQuery = ""; // Store the user's search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        automaticallyImplyLeading: false, //it removes the appbar back button
        elevation: 0,
        actions: [
          const SizedBox(
            width: 15,
          ),
          MyIconButton(
            icon: Icons.arrow_back,
            pressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          const Text(
            "Quick & Easy",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          MyIconButton(icon: Iconsax.notification, pressed: () {}),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 5),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase(); // Update search query
                  });
                },
                decoration: const InputDecoration(
                  filled: true,
                  prefixIcon: Icon(Iconsax.search_normal),
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: "Search any recipes",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.vertical(),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: completeApp.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                    final recipeName =
                    doc['name'].toString().toLowerCase(); // Adjust field key
                    return recipeName.contains(searchQuery);
                  }).toList();

                  return GridView.builder(
                    itemCount: filteredDocs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = filteredDocs[index];
                      return Column(
                        children: [
                          FoodItemsDisplay(documentSnapshot: documentSnapshot),
                        ],
                      );
                    },
                  );
                }
                // Show progress indicator if data is not available
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
