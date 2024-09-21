import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data_file.dart';
import '../data_center.dart';
import '../widgets/consts.dart';
import '../widgets/phone_formats.dart';
import '../widgets/rounded_button.dart';
import '../widgets/side_drawer.dart';

final _registrationScreenFirestore = FirebaseFirestore.instance;

class RoomBooking extends StatefulWidget {
  const RoomBooking({super.key});

  @override
  State<RoomBooking> createState() => _RoomBookingState();
}

class _RoomBookingState extends State<RoomBooking> {
  late final propertyDataInfo, propertyBookingInfo;
  var imageURL = [];
  DateTime? checkInDate, checkOutDate;
  String emailID = '', firstName = '', lastName = '', streetAddress = '', cityAddress = '', stateProvince = '', country = '';
  int phoneNumber = 0, zipcode = 0, numberOfStayDays = 0;
  double grandTotal = 0.0, totalAmountDue = 0.0, dailyRent = 0.0;
  bool isLoading = true;
  String? countryCode;
  String  paymentStatusDefault = 'Full Payment';
  final List<String> paymentStatus = ['Full Payment', 'Partial Payment', 'Payment Pending'];
  final TextEditingController countryCodeController = TextEditingController();
  TextEditingController emailIDController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressStreetController = TextEditingController();
  TextEditingController addressCityController = TextEditingController();
  TextEditingController addressStateController = TextEditingController();
  TextEditingController addressCountryController = TextEditingController();
  TextEditingController addressZipcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  bool checkDateOverlap(DateTime selectedCheckin, DateTime selectedCheckout, List<Map<String, DateTime>> bookings,) {
    for (var booking in bookings) {
      DateTime existingCheckin = booking['checkinDate']!;
      DateTime existingCheckout = booking['checkoutDate']!;

      if ((selectedCheckin.isAfter(existingCheckin) && selectedCheckin.isBefore(existingCheckout)) || selectedCheckin.isAtSameMomentAs(existingCheckin) || (selectedCheckout.isAfter(existingCheckin) && selectedCheckout.isBefore(existingCheckout)) ) {
        return true;
      }
    }
    return false;
  }

  void handleBooking(BuildContext context, DateTime selectedCheckin, DateTime selectedCheckout) async {
    List<Map<String, DateTime>> bookings = await getRoomBookings();

    if (checkDateOverlap(selectedCheckin, selectedCheckout, bookings)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text('Date Conflict', style: isDarkModeEnabled == false ? kDarkBoldTextSize20 : kLightBoldTextSize20),
            content: Text('The selected dates overlap with an existing booking. Please choose different dates.', style: isDarkModeEnabled == false ? kBoldDarkTextSize16 : kBoldLightTextSize16),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: isDarkModeEnabled == false ? kBoldDarkTextSize16 : kBoldDarkTextSize16),
              ),
            ],
          );
        },
      );
    } else {
      // Proceed with booking
    }
  }



  Future<void> getProfileData() async {
    final propertyData = await getPropertyData();
    propertyDataInfo = propertyData;
    final propertyBookings = await getPropertyBookings();
    propertyBookingInfo = propertyBookings;

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
    for(int i=0; i < propertyDataInfo['images'].length; i++) {
      setState(() {
        imageURL.add(propertyDataInfo['images'][i]);
        dailyRent = propertyDataInfo['rent'];
      });
    }
  }

  Future<void> _checkInDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      barrierDismissible: false,
      initialDate: checkInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: checkOutDate ?? DateTime(2200),
      builder: (BuildContext context, Widget? widget) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(primary: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
            dividerColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
            headerBackgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
            headerForegroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
              ),
            ),
          )
        ),
        child: widget!,
      )
    );
    if (pickedDate != null && pickedDate != checkInDate) {
      setState(() {
        checkInDate =  DateTime.utc(pickedDate.year, pickedDate.month, pickedDate.day);
        if(checkOutDate != null) {
          numberOfStayDays = checkOutDate!.difference(checkInDate!).inDays;
          totalAmountDue = numberOfStayDays * dailyRent;
          handleBooking(context, checkInDate!, checkOutDate!);
        }
      });
    }
  }

  Future<void> _checkOutDate(BuildContext context) async {
    final DateTime? _selectedDate = await showDatePicker(
      context: context,
      barrierDismissible: false,
      initialDate: checkInDate ?? DateTime.now(),
      firstDate: checkInDate ?? DateTime.now(),
      lastDate: DateTime(2200),
      builder: (BuildContext context, Widget? widget) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(primary: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
            dividerColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
            headerBackgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
            headerForegroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
              ),
            ),
          )
        ),
        child: widget!,
      )
    );
    if (_selectedDate != null && _selectedDate != checkOutDate) {
      setState(() {
        checkOutDate = DateTime.utc(_selectedDate.year, _selectedDate.month, _selectedDate.day);
        numberOfStayDays = checkOutDate!.difference(checkInDate!).inDays;
        totalAmountDue = numberOfStayDays * dailyRent;
        handleBooking(context, checkInDate!, checkOutDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Room Booking Page',
            style: TextStyle(
              color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor,
            ),
          ),
          backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
          iconTheme: IconThemeData(
            color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor,
          ),
        ),
        body: isLoading ? Center(child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation<Color>(isDarkModeEnabled == false ? kDarkTitleColor : kLightTitleColor),
          backgroundColor: isDarkModeEnabled == false ? kLightTitleColor : kDarkTitleColor,
          strokeWidth: 5,
        ))
        : SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image slideshow
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: false,
                    enableInfiniteScroll: imageURL.length == 1 ? false : true,
                    enlargeCenterPage: true,
                  ),
                  items: imageURL.map((img) {
                    return SizedBox(
                      child: Image.network(
                        img,
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 15.0),
              Text(
                '${propertyDataInfo['roomType']} Room',
                style: isDarkModeEnabled == false ? kButtonDarkTextSize24 : kButtonBlueTextSize24,
              ),
              const SizedBox(height: 15),
              Text(
                'Room ${propertyDataInfo['roomNumber']}',
                style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldBlueTextSize18,
              ),
              const SizedBox(height: 15),
              Text(
                '${propertyDataInfo['currencyType'].split(' - ')[0]} ${propertyDataInfo['rent']} per day',
                style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldBlueTextSize18,
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: isDarkModeEnabled == false ? kBlackBoldTextSize18 : kBlueBoldTextSize18,
                      alignment: Alignment.center,
                      elevation: 0,
                    ),
                    onPressed: () => _checkInDate(context),
                    child: checkInDate == null
                    ? Text(
                      'Check In Date',
                      style: TextStyle(
                        color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor,
                      ),
                    ) : Text(
                      DateFormat('yMMMMd').format(checkInDate!),
                      style: TextStyle(
                        color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: isDarkModeEnabled == false ? kBlackBoldTextSize18 : kBlueBoldTextSize18,
                      alignment: Alignment.center,
                      elevation: 0,
                    ),
                    onPressed: () => _checkOutDate(context),
                    child: checkOutDate == null
                        ? Text(
                      'Check Out Date',
                      style: TextStyle(
                        color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor,
                      ),
                    )
                        : Text(
                      DateFormat('yMMMMd').format(checkOutDate!),
                      style: TextStyle(
                        color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Email ID
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        firstName = firstNameController.text;
                      },
                      decoration: textInputDecoration('First Name'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        lastName = lastNameController.text;
                      },
                      decoration: textInputDecoration('Last Name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Email ID
              TextField(
                controller: emailIDController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  emailID = emailIDController.text;
                },
                decoration: textInputDecoration('Email ID'),
              ),
              const SizedBox(height: 15),
              // Phone Number
              Row(
                children: [
                  SizedBox(
                    width: 190,
                    child: Padding(
                      padding:  const EdgeInsets.only(left: 10),
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Phone Code',
                          style: isDarkModeEnabled == false ? kDarkListingDecorationSize17 : kLightListingDecorationSize17,
                        ),
                        items: phoneFormats.map((phoneCode) {
                          return DropdownMenuItem<String>(
                            value: '${phoneCode.code} - ${phoneCode.country}',
                            child: Row(
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 130),
                                  child: Text('${phoneCode.code} - ${phoneCode.country}', overflow: TextOverflow.ellipsis, style: isDarkModeEnabled == false ? kDarkListingDecorationSize17 : kLightListingDecorationSize17,),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        value: countryCode,
                        onChanged: (value) {
                          setState(() {
                            countryCode = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          width: 240,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: countryCodeController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: SizedBox(
                            height: 50,
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: countryCodeController,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Phone Code',
                                hintStyle: isDarkModeEnabled == false ? kDarkListingDecorationSize17 : kLightListingDecorationSize17,
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return item.value.toString().contains(searchValue);
                          },
                        ),
                        //This to clear the search value when you close the menu
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            countryCodeController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        phoneNumber = int.parse(phoneNumberController.text);
                      },
                      decoration: textInputDecoration('Phone Number'),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  // Address Street
                  Expanded(
                    child: TextField(
                      controller: addressStreetController,
                      keyboardType: TextInputType.streetAddress,
                      onChanged: (value) {
                        streetAddress = addressStreetController.text;
                      },
                      decoration: textInputDecoration('Street'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Address City
                  Expanded(
                    child: TextField(
                      controller: addressCityController,
                      keyboardType: TextInputType.streetAddress,
                      onChanged: (value) {
                        cityAddress = addressCityController.text;
                      },
                      decoration: textInputDecoration('City'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Address State/Province
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: addressStateController,
                      keyboardType: TextInputType.streetAddress,
                      onChanged: (value) {
                        stateProvince = addressStateController.text;
                      },
                      decoration: textInputDecoration('State/Province'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Address Country
                  Expanded(
                    child: TextField(
                      controller: addressZipcodeController,
                      keyboardType: TextInputType.streetAddress,
                      onChanged: (value) {
                        zipcode = int.parse(addressZipcodeController.text);
                      },
                      decoration: textInputDecoration('Zipcode'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Zipcode
              TextField(
                controller: addressCountryController,
                keyboardType: TextInputType.streetAddress,
                onChanged: (value) {
                  country = addressCountryController.text;
                },
                decoration: textInputDecoration('Country'),
              ),
              const SizedBox(height: 15),
              Text(
                'Your Total Stay: ',
                style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldBlueTextSize18,
              ),
              Text(
                '$numberOfStayDays Days',
                style: isDarkModeEnabled == false ? kBoldDarkTextSize18 : kBoldBlueTextSize18,
              ),
              const SizedBox(height: 20),
              Text(
                'Your Total Bill: ',
                style: isDarkModeEnabled == false ? kButtonDarkTextSize24 : kButtonBlueTextSize24,
              ),
              Text(
                '${propertyDataInfo['currencyType'].split(' - ')[0]} $totalAmountDue',
                style: isDarkModeEnabled == false ? kButtonDarkTextSize24 : kButtonBlueTextSize24,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Payment Status:',  style:  isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                  DropdownButton(
                    value: paymentStatusDefault,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: paymentStatus.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: isDarkModeEnabled == false ? kDarkListingDecorationSize17 : kLightListingDecorationSize17),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        paymentStatusDefault = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              RoundedButton(
                colour: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
                title:'Book The Room',
                onPress: (countryCode != null && checkInDate != null && checkOutDate != null && emailID != '' && firstName != '' && lastName != '' && phoneNumber != 0 && streetAddress != '' && stateProvince != '' && country != '' && zipcode != 0) ? () async {
                  Map<String, dynamic> roomData = {'countryCode': countryCode, 'checkInDate': checkInDate, 'checkOutDate':checkOutDate, 'emailID': emailID, 'firstName': firstName, 'firstName': firstName, 'lastName': lastName, 'phoneNumber': phoneNumber, 'street': streetAddress, 'state': stateProvince, 'country': country, 'zipcode': zipcode, 'paymentStatus':paymentStatusDefault, 'roomID': roomID, 'currency': propertyDataInfo['currencyType'],'isCheckedIn': false, 'isCheckedOut': false, 'totalAmountDue': totalAmountDue, 'stayDuration': numberOfStayDays, 'bookingDoneBy': currentUserEmailID};
                  DocumentReference docRef = await _registrationScreenFirestore.collection('booking_data').add(roomData);
                  commonAlertBoxWithNavigation(context, 'SUCCESS!', 'Congratulations! Your room has been booked. Your confirmation id is: ${docRef.id}', '/all_room_listings');
                } : () {
                  if(countryCode == null && checkInDate == null && checkOutDate == null && emailID == '' && firstName == '' && lastName == '' && phoneNumber == 0 && phoneNumber == '' && stateProvince == '' && country == '' && zipcode == 0) {
                    commonAlertBox(context, 'WARNING!', 'Please check your password fields, the do not match.');
                  } else if(checkInDate == null) {
                    commonAlertBox(context, 'WARNING!', 'Please select a Check In Date.');
                  } else if (checkOutDate == null) {
                    commonAlertBox(context, 'WARNING!', 'Please select a Check Out Date.');
                  } else if (countryCode == null) {
                    commonAlertBox(context, 'WARNING!', 'Please select a country code for your mobile number.');
                  } else if (emailID == '') {
                    commonAlertBox(context, 'WARNING!', 'Please enter your email id.');
                  } else if (phoneNumber == 0) {
                    commonAlertBox(context, 'WARNING!', 'Please enter your phone number.');
                  } else if (streetAddress == '') {
                    commonAlertBox(context, 'WARNING!', 'Please enter street address.');
                  } else if (stateProvince == '') {
                    commonAlertBox(context, 'WARNING!', 'Please enter street/province.');
                  } else if (country == '') {
                    commonAlertBox(context, 'WARNING!', 'Please enter country.');
                  }
                },
                txtStyle: isDarkModeEnabled == false ? kButtonBlackTextSize24 : kButtonBlueTextSize24,
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
