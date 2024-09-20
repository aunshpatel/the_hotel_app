import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/side_drawer.dart';
import 'package:the_hotel_app/widgets/uniqueEmail_confirmation.dart';

class RoomListings extends StatefulWidget {
  const RoomListings({super.key});

  @override
  State<RoomListings> createState() => _RoomListingsState();
}

// class _RoomListingsState extends State<RoomListings> {
//   final ScrollController _scrollController = ScrollController();
//   CollectionReference roomData = FirebaseFirestore.instance.collection('room_data');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
//       drawer: const SideDrawer(),
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('All Rooms', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
//         backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
//         iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             StreamBuilder<QuerySnapshot>(
//               stream: roomData.snapshots(),
//               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18));
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(
//                     child: Column(
//                       children: [
//                         Text('No Rooms Found!', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                         MaterialButton(
//                           onPressed: () {
//                             Navigator.pushNamed(context, '/add_new_room');
//                           },
//                           child: Text('Click Here to Add New Rooms!', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                         )
//                       ],
//                     )
//                   );
//                 }
//
//                 final items = snapshot.data!.docs;
//                 return SizedBox(
//                   height: MediaQuery.of(context).size.height - 145,
//                   child: Scrollbar(
//                     controller: _scrollController,
//                     thumbVisibility: true,
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       scrollDirection: Axis.vertical,
//                       shrinkWrap: true,
//                       padding: const EdgeInsets.all(4),
//                       itemCount: items.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         String currencyType = items[index]['currencyType'].split(' - ')[0];
//                         List<dynamic> amenities = items[index]['availableAmenities'] ?? [];
//                         String amenitiesText = amenities.join(', ');
//                         return Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Card(
//                                   child: SizedBox(
//                                     width: 300,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(14),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Image.network(items[index]['images'][0], height: 140,),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Room Number:', style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text(items[index]['roomNumber'].toString(), style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Description:', style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text('${items[index]['description']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18, style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Rent (per night):', style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text('$currencyType ${items[index]['rent']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18, style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Availability:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text('${items[index]['availability']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18, style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Bed & Bed Size:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text('${items[index]['bedQuantity']} Beds ${items[index]['bedType']} Size', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Max Occupancy:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text('${items[index]['maximumPeople'].toString()} People', style:isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Room Type:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text(items[index]['roomType'].toString(), style:isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('View Type:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text(items[index]['viewType'].toString(), style:isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Amenities:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text(amenitiesText, style:isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Smoking Policy:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text('${items[index]['smokingPolicy']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18, style:isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Cancellation Policy:', style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text('${items[index]['cancellationPolicy']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18, style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             )
//                           ],
//                         );
//                       }
//                     )
//                   ),
//                 );
//               },
//             )
//           ],
//         )
//       ),
//     );
//   }
// }

class _RoomListingsState extends State<RoomListings> {
  final ScrollController _scrollController = ScrollController();
  CollectionReference roomData = FirebaseFirestore.instance.collection('room_data');
  String searchQuery = '', selectedAvailability = 'All', selectedRoomType = 'All';
  double minRent = 0, maxRent = 1000000;
  TextEditingController minRentController = TextEditingController();
  TextEditingController maxRentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default values for rent filters
    minRentController.text = minRent.toString();
    maxRentController.text = maxRent.toString();
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    minRentController.dispose();
    maxRentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
      drawer: const SideDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Rooms',
          style: TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
        ),
        backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
        iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //Filters
            TextField(
              decoration: textInputDecoration('Search by Room Number'),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minRentController,
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration('Min Rent'),
                    onChanged: (value) {
                      setState(() {
                        minRent = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: maxRentController,
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration('Max Rent'),
                    onChanged: (value) {
                      setState(() {
                        maxRent = double.tryParse(value) ?? 10000;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                DropdownButton<String>(
                  value: selectedAvailability,
                  items: <String>['All', 'Available', 'Out of Service', 'Not Available'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAvailability = value!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedRoomType,
                  items: <String>['All', 'Suite', 'Single', 'Double'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRoomType = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // All rooms display
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: roomData.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Text('No Rooms Found!', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/add_new_room');
                            },
                            child: Text(
                              'Click Here to Add New Rooms!',
                              style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18,
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  final items = snapshot.data!.docs;

                  final filteredItems = items.where((doc) {
                    final roomNumber = doc['roomNumber'].toString();
                    final description = doc['description'].toString();
                    final availability = doc['availability'].toString();
                    final roomType = doc['roomType'].toString();
                    final rent = doc['rent'];

                    final matchesSearchQuery = roomNumber.contains(searchQuery) || description.contains(searchQuery);
                    final matchesAvailability = selectedAvailability == 'All' || availability == selectedAvailability;
                    final matchesRoomType = selectedRoomType == 'All' || roomType == selectedRoomType;
                    final matchesRentRange = rent >= minRent && rent <= maxRent;

                    return matchesSearchQuery && matchesAvailability && matchesRoomType && matchesRentRange;
                  }).toList();

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: filteredItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = filteredItems[index];
                      String currencyType = item['currencyType'].split(' - ')[0];
                      List<dynamic> amenities = item['availableAmenities'] ?? [];
                      String amenitiesText = amenities.join(', ');

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.network(item['images'][0], height: 140),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Room Number:', style: kDarkUnderlineTextSize18),
                                  Text(' ${item['roomNumber']}', style: kDarkTextSize18),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Description:', style: kDarkUnderlineTextSize18),
                                  Expanded(
                                    child: Text(' ${item['description']}', style: kDarkTextSize18),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Rent:', style: kDarkUnderlineTextSize18),
                                  Text(' $currencyType ${item['rent']}', style: kDarkTextSize18),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Availability:', style: kDarkUnderlineTextSize18),
                                  Text(' ${item['availability']}', style: kDarkTextSize18),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Bed:', style: kDarkUnderlineTextSize18),
                                  Text(' ${item['bedQuantity']} Beds ${item['bedType']}', style: kDarkTextSize18),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Max Occupancy:', style: kDarkUnderlineTextSize18),
                                  Text(' ${item['maximumPeople']}', style: kDarkTextSize18),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Room Type:', style: kDarkUnderlineTextSize18),
                                  Text(' ${item['roomType']}', style: kDarkTextSize18),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('View Type:', style: kDarkUnderlineTextSize18),
                                  Text(' ${item['viewType']}', style: kDarkTextSize18),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Amenities:', style: kDarkUnderlineTextSize18),
                                  Expanded(
                                    child: Text(' $amenitiesText', style: kDarkTextSize18),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Smoking Policy:', style: kDarkUnderlineTextSize18),
                                  Text(' ${item['smokingPolicy']}', style: kDarkTextSize18),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Cancellation Policy:', style: kDarkUnderlineTextSize18),
                                  Expanded(
                                    child: Text(' ${item['cancellationPolicy']}', style: kDarkTextSize18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}