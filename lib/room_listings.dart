import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/side_drawer.dart';
import 'package:the_hotel_app/widgets/uniqueEmail_confirmation.dart';

class RoomListings extends StatefulWidget {
  const RoomListings({super.key});

  @override
  State<RoomListings> createState() => _RoomListingsState();
}

class _RoomListingsState extends State<RoomListings> {
  final ScrollController _scrollController = ScrollController();
  CollectionReference roomData = FirebaseFirestore.instance.collection('room_data');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
      drawer: const SideDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('All Rooms', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
        backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
        iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: roomData.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No items found.'));
                }

                final items = snapshot.data!.docs;
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(4),
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        String currencyType = items[index]['currencyType'].split(' - ')[0];
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: null,
                                  child: Card(
                                    child: SizedBox(
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.network(items[index]['images'][0], height: 80,),
                                            const SizedBox(height: 6,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Room Number:', style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
                                                Text(items[index]['roomNumber'].toString(), style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                              ],
                                            ),
                                            const SizedBox(height: 6,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Description:', style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
                                                Text('${items[index]['description']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                              ],
                                            ),
                                            const SizedBox(height: 6,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Rent (per night):', style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
                                                Text('$currencyType ${items[index]['rent']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                              ],
                                            ),
                                            const SizedBox(height: 6,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Availability:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
                                                Text('${items[index]['availability']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                              ],
                                            ),
                                            const SizedBox(height: 6,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Bed & Bed Size:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
                                                Text('${items[index]['bedQuantity']} Beds ${items[index]['bedType']} Size', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                              ],
                                            ),
                                            const SizedBox(height: 6,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Max Occupancy:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
                                                Text('${items[index]['maximumPeople'].toString()} People', style:isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                              ],
                                            ),
                                            const SizedBox(height: 6,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Room Type:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
                                                Text(items[index]['roomType'].toString(), style:isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                              ],
                                            ),
                                            const SizedBox(height: 6,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('View Type:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
                                                Text('${items[index]['viewType'].toString()}', style:isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                              ],
                                            ),
                                            const SizedBox(height: 6,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Smoking Policy:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
                                                Text('${items[index]['smokingPolicy']}', style:isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                              ],
                                            ),
                                            const SizedBox(height: 6,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Cancellation Policy:', style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
                                                Text('${items[index]['cancellationPolicy']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                              ],
                                            ),
                                            const SizedBox(height: 6,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        );
                      }
                    )
                  ),
                );
              },
            )
          ],
        )
      ),
    );
  }
}
