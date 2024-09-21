import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hotel_app/data_center.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/side_drawer.dart';

class RoomListings extends StatefulWidget {
  const RoomListings({super.key});

  @override
  State<RoomListings> createState() => _RoomListingsState();
}

class _RoomListingsState extends State<RoomListings> {
  final ScrollController _scrollController = ScrollController();
  Future<List<QueryDocumentSnapshot<Object?>>> roomData = getRoomData();
  String searchQuery = '', selectedAvailability = 'Available', selectedRoomType = 'Regular', priceSortOrder = 'Ascending';
  double minRent = 0, maxRent = 10000000;
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
                child: Text(_showFilters ? 'Hide Filters' : 'Show Filters',style: isDarkModeEnabled == false ? kDarkSemiBoldTextSize18 : kLightSemiBoldTextSize18),
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
                          Text('Availability: ', style: isDarkModeEnabled == false ? kDarkListingDecorationSize17 : kLightListingDecorationSize17),
                          const SizedBox(width: 15),
                          DropdownButton<String>(
                            value: selectedAvailability,
                            items: <String>['Available', 'Out of Service', 'Not Available'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: isDarkModeEnabled == false ? kDarkListingDecorationSize17 : kLightListingDecorationSize17),
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
                          Text('Room Type: ', style: isDarkModeEnabled == false ? kDarkListingDecorationSize17 : kLightListingDecorationSize17),
                          const SizedBox(width: 15),
                          DropdownButton<String>(
                            value: selectedRoomType,
                            items: <String>['Regular', 'Suite', 'Semi-Deluxe', 'Deluxe'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: isDarkModeEnabled == false ? kDarkListingDecorationSize17 : kLightListingDecorationSize17),
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
                          Text('Sort by Price: ', style: isDarkModeEnabled == false ? kDarkListingDecorationSize17 : kLightListingDecorationSize17),
                          const SizedBox(width: 15),
                          DropdownButton<String>(
                            value: priceSortOrder,
                            items: <String>['Ascending', 'Descending'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: isDarkModeEnabled == false ? kDarkListingDecorationSize17 : kLightListingDecorationSize17),
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
              child:FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
                future: roomData,
                builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot<Object?>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(isDarkModeEnabled == false ? kDarkTitleColor : kLightTitleColor),
                      backgroundColor: isDarkModeEnabled == false ? kLightTitleColor : kDarkTitleColor,
                      strokeWidth: 5,
                    ));
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

                  final items = snapshot.data!;
                  final filteredItems = items.where((doc) {
                    final roomNumber = doc['roomNumber'].toString();
                    final description = doc['description'].toString();
                    final availability = doc['roomStatus'].toString();
                    final roomType = doc['roomType'].toString();
                    final rent = doc['rent'];

                    final matchesSearchQuery = roomNumber.contains(searchQuery) || description.contains(searchQuery);
                    final matchesAvailability = selectedAvailability == 'Available' || availability == selectedAvailability;
                    final matchesRoomType = selectedRoomType == 'Regular' || roomType == selectedRoomType;
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
                      // roomID = item.id;
                      String currencyType = item['currencyType'].split(' - ')[0];
                      List<dynamic> amenities = item['availableAmenities'] ?? [];
                      String amenitiesText = amenities.join(', ');

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        autoPlay: item['images'].length == 1 ? false : true,
                                        enableInfiniteScroll: item['images'].length == 1 ? false : true,
                                        enlargeCenterPage: true,
                                      ),
                                      items: item['images'].map<Widget>((img) {
                                        return SizedBox(
                                          child: Image.network(img, height:400, fit: BoxFit.contain),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  // Room Number
                                  Row(
                                    children: [
                                      const Text('Room Number:', style: kDarkUnderlineTextSize18),
                                      Text(' ${item['roomNumber']}', style: kDarkTextSize18),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Description
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
                                  // Rent
                                  Row(
                                    children: [
                                      const Text('Rent (Per Day):', style: kDarkUnderlineTextSize18),
                                      Text(' $currencyType ${item['rent']}', style: kDarkTextSize18),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Room Size
                                  Row(
                                    children: [
                                      const Text('Room Size:', style: kDarkUnderlineTextSize18),
                                      Text(' ${item['roomSize']} sq. ft.', style: kDarkTextSize18),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Availability
                                  Row(
                                    children: [
                                      const Text('Availability:', style: kDarkUnderlineTextSize18),
                                      Text(' ${item['roomStatus']}', style: kDarkTextSize18),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Bed Details
                                  Row(
                                    children: [
                                      const Text('Bed:', style: kDarkUnderlineTextSize18),
                                      Text(' ${item['bedQuantity']} Beds, ${item['bedType']} Size', style: kDarkTextSize18),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Max Occupancy
                                  Row(
                                    children: [
                                      const Text('Max Occupancy:', style: kDarkUnderlineTextSize18),
                                      Text(' ${item['maximumPeople']}', style: kDarkTextSize18),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Room Type
                                  Row(
                                    children: [
                                      const Text('Room Type:', style: kDarkUnderlineTextSize18),
                                      Text(' ${item['roomType']}', style: kDarkTextSize18),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // View Type
                                  Row(
                                    children: [
                                      const Text('View Type:', style: kDarkUnderlineTextSize18),
                                      Text(' ${item['viewType']}', style: kDarkTextSize18),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Amenities
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
                                  // Smoking Policy
                                  Row(
                                    children: [
                                      const Text('Smoking Policy:', style: kDarkUnderlineTextSize18),
                                      Text(' ${item['smokingPolicy']}', style: kDarkTextSize18),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Cancellation Policy
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
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                 SizedBox(
                                   height: 70,
                                   width: 200,
                                   child: ElevatedButton(
                                     onPressed: () {
                                       roomID = item.id;
                                       Navigator.pushNamed(context, '/room_booking');
                                     },
                                     style: ElevatedButton.styleFrom(
                                       backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
                                     ),
                                     child: Text('Book This Room',style: isDarkModeEnabled == false ? kDarkSemiBoldTextSize18 : kBlueSemiBoldTextSize18),
                                   ),
                                 )
                                ],
                              )
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