import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/side_drawer.dart';

class RoomListings extends StatefulWidget {
  const RoomListings({super.key});

  @override
  State<RoomListings> createState() => _RoomListingsState();
}

class _RoomListingsState extends State<RoomListings> {
  final ScrollController _scrollController = ScrollController();
  CollectionReference roomData = FirebaseFirestore.instance.collection('room_data');
  String searchQuery = '', selectedAvailability = 'All', selectedRoomType = 'All', priceSortOrder = 'Ascending';
  double minRent = 0, maxRent = 1000000;
  bool _showFilters = false;
  TextEditingController minRentController = TextEditingController();
  TextEditingController maxRentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    minRentController.text = minRent.toString();
    maxRentController.text = maxRent.toString();
  }

  @override
  void dispose() {
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
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                child: Text(_showFilters ? 'Hide Filters' : 'Show Filters',style: isDarkModeEnabled == false ? kDarkSemiBoldTextStyle : kLightSemiBoldTextStyle),
              ),
            ),
            const SizedBox(height: 10),
            //Filters
            Visibility(
              visible: _showFilters,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
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
                          Text('Availability: ', style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle),
                          const SizedBox(width: 15),
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
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Room Type: ', style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle),
                          const SizedBox(width: 15),
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
                      Row(
                        children: [
                          Text('Sort by Price: ', style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle),
                          const SizedBox(width: 15),
                          DropdownButton<String>(
                            value: priceSortOrder,
                            items: <String>['Ascending', 'Descending'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                priceSortOrder = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      const Text('Note: "Sort by Price" sorts by the rent amount value, irrespective of currency!', style: kWarningTextSize15),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              )
            ),

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

                  filteredItems.sort((a, b) {
                    final rentA = a['rent'] as num;
                    final rentB = b['rent'] as num;
                    if (priceSortOrder == 'Ascending') {
                      return rentA.compareTo(rentB);
                    } else {
                      return rentB.compareTo(rentA);
                    }
                  });

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