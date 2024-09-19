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
//                   return Center(child: Text('Error: ${snapshot.error}'));
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
//                                               Text('${items[index]['description']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Rent (per night):', style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text('$currencyType ${items[index]['rent']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Availability:', style:isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text('${items[index]['availability']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
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
//                                               Text('${items[index]['smokingPolicy']}', style:isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 6,),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text('Cancellation Policy:', style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldLightTextSize18),
//                                               Text('${items[index]['cancellationPolicy']}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
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

  String searchQuery = '';
  String selectedAvailability = 'All'; // Example filter
  String selectedRoomType = 'All'; // Example filter

  // Rent range filter
  double minRent = 0;
  double maxRent = 10000;
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
          style: TextStyle(
              color: isDarkModeEnabled == false
                  ? kThemeBlackColor
                  : kThemeBlueColor),
        ),
        backgroundColor: isDarkModeEnabled == false
            ? kThemeBlueColor
            : kThemeBlackColor,
        iconTheme: IconThemeData(
            color: isDarkModeEnabled == false
                ? kThemeBlackColor
                : kThemeBlueColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by Room Number or Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),

            // Rent range filter
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minRentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Min Rent',
                      border: OutlineInputBorder(),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Max Rent',
                      border: OutlineInputBorder(),
                    ),
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

            // Filter dropdowns
            Row(
              children: [
                DropdownButton<String>(
                  value: selectedAvailability,
                  items: <String>['All', 'Available', 'Out of Service', 'Not Available']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
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
                  items: <String>['All', 'Suite', 'Single', 'Double']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
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

            // StreamBuilder to display rooms
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: roomData.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            'No Rooms Found!',
                            style: isDarkModeEnabled == false
                                ? kDarkTextSize18
                                : kLightTextSize18,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/add_new_room');
                            },
                            child: Text(
                              'Click Here to Add New Rooms!',
                              style: isDarkModeEnabled == false
                                  ? kDarkTextSize18
                                  : kLightTextSize18,
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  final items = snapshot.data!.docs;

                  // Filter and search logic
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
                              const SizedBox(height: 6),
                              Text('Room Number: ${item['roomNumber']}'),
                              Text('Description: ${item['description']}'),
                              Text('Rent: $currencyType ${item['rent']}'),
                              Text('Availability: ${item['availability']}'),
                              Text('Bed: ${item['bedQuantity']} Beds ${item['bedType']}'),
                              Text('Max Occupancy: ${item['maximumPeople']}'),
                              Text('Room Type: ${item['roomType']}'),
                              Text('View Type: ${item['viewType']}'),
                              Text('Amenities: $amenitiesText'),
                              Text('Smoking Policy: ${item['smokingPolicy']}'),
                              Text('Cancellation Policy: ${item['cancellationPolicy']}'),
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