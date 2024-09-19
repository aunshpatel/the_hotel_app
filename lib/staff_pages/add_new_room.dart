import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/consts.dart';
import '../widgets/currency_listings.dart';
import '../widgets/rounded_button.dart';
import '../widgets/side_drawer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

final _addNewRoomFirestore = FirebaseFirestore.instance;

class AddNewRoom extends StatefulWidget {
  const AddNewRoom({super.key});

  @override
  State<AddNewRoom> createState() => _AddNewRoomState();
}

class _AddNewRoomState extends State<AddNewRoom> {
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController roomTypeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController maximumPeopleController = TextEditingController();
  TextEditingController bedTypeController = TextEditingController();
  TextEditingController roomSizeController = TextEditingController();
  TextEditingController rentAmountController = TextEditingController();
  TextEditingController cancellationPolicyController = TextEditingController();
  TextEditingController roomViewController = TextEditingController();
  TextEditingController smokingPolicyController = TextEditingController();
  final TextEditingController currencyDropdownController = TextEditingController();
  final TextEditingController bedQuantityController = TextEditingController();
  int roomNumber = 0, maximumPeople = 0, roomSize = 0, bedQuantity = 0;
  double rentAmount = 0.0;
  String description = '', roomType = '', bedType = 'Twin/Single', cancellationPolicy = '', roomView = '';
  String? selectedCurrencyCode;
  bool uploading = false, isUploadButtonDisabled = false;
  String roomTypeDropdownDefault = 'Regular', roomAvailabilityDropdownDefault = 'Available', smokingPolicy = 'No Smoking';
  final List<String> bedTypeDropdown = ['Twin/Single', 'Full/Double', 'Queen', 'King'];
  final List<String> roomTypeDropdown = ['Regular', 'Semi-Deluxe', 'Deluxe', 'Suite'], roomAvailability = ['Available', 'Not Available', 'Out of Service'], smokingPolicyDropdown = ['No Smoking', 'Smoking Allowed'];
  final List<String> amenityOptions = ['TV', 'Swimming Pool', 'Fitness Center', 'Complimentary Breakfast', 'Complimentary Lunch', 'Complimentary Dinner', 'Complimentary Parking', 'Complimentary WiFi', 'Room Service', 'In Room Bar'];
  List<String> selectedAmenities = [], urlOfImageUploaded = [];
  var pickedImages;
  File? _image;
  final picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  startUpload(bool isUploading){
    setState(() {
      uploading = isUploading;
    });
  }

  Future getPhotoFromGallery() async {
    pickedImages = await picker.pickMultiImage(imageQuality: 100);
    if(pickedImages.length > 0 && pickedImages.length<=6){
      if (pickedImages != null) {
        for(int i=0; i<pickedImages?.length; i++){
          _image = File(pickedImages[i].path);

          startUpload(true);
          Reference ref = FirebaseStorage.instance.ref().child(
              Path.basename(_image!.path)
          );
          UploadTask uploadTask = ref.putFile(_image!);
          TaskSnapshot snapshot = await uploadTask.whenComplete(() {
            startUpload(false);
          });
          var uploadedImageLink = await snapshot.ref.getDownloadURL();
          setState(() {
            urlOfImageUploaded.add(uploadedImageLink);
          });

          if(urlOfImageUploaded.length == 6){
            isUploadButtonDisabled = true;
          }
        }
      } else {
        print('No image selected.');
      }
    }
    else{
      commonAlertBox(context, 'WARNING', 'You can only upload upto 6 images!');
    }
  }

  Future photoFromCamera() async {
    pickedImages = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedImages != null) {
      _image = File(pickedImages.path);
      startUpload(true);
      Reference ref = FirebaseStorage.instance.ref().child(
          Path.basename(_image!.path)
      );
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {
        startUpload(false);
      });
      var uploadedImageLink = await snapshot.ref.getDownloadURL();
      setState(() {
        urlOfImageUploaded.add(uploadedImageLink);
      });
      if(urlOfImageUploaded.length == 6){
        isUploadButtonDisabled = true;
      }
    } else {
      print('No image selected.');
    }
  }

  Future<void> photoSelector() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Row(
            children: [
              Text('Select A Photo Source', style: isDarkModeEnabled == false ? kDarkBoldTextSize20 : kLightBoldTextSize20)
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  getPhotoFromGallery();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: kLightTitleColor,
                ),
                child:  Text('Gallery', style: isDarkModeEnabled == false ? kWhiteBoldTextSize20 : kBlueBoldTextSize20,),
              ),
              TextButton(
                onPressed: () {
                  photoFromCamera();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: kDarkTitleColor,
                ),
                child:  Text('Photo', style: isDarkModeEnabled == false ? kWhiteBoldTextSize20 : kBlueBoldTextSize20,),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Cancel', style: isDarkModeEnabled == false ? kDarkBoldTextSize20 : kLightBoldTextSize20),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  deletePhoto(String photoURL, int index){
    deletePhotoConfirmation(photoURL, index);
  }

  Future<void> deletePhotoConfirmation(String photoURL, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text('WARNING', style: isDarkModeEnabled == false ? kDarkBoldTextSize20 : kLightBoldTextSize20),
          content: const Text('Are you sure you want to delete the image?', style: kLightSemiBoldTextStyle),
          actions: <Widget>[
            TextButton(
              child: const Text('YES', style: TextStyle(color: kDarkTitleColor),),
              onPressed: () {
                Navigator.of(context).pop();
                var deletedImage = FirebaseStorage.instance.refFromURL(photoURL!);
                deletedImage.delete().whenComplete(() {
                  setState(() {
                    urlOfImageUploaded.removeAt(index);
                    if(urlOfImageUploaded.length < 6){
                      isUploadButtonDisabled = false;
                    }
                  });
                });
              },
            ),
            TextButton(
              child: const Text('NO', style: TextStyle(color: kDarkTitleColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onItemCheck(bool? isChecked, String item) {
    setState(() {
      if (isChecked != null && isChecked) {
        selectedAmenities.add(item);
      } else {
        selectedAmenities.remove(item);
      }
    });
  }

  _addNewRoomButton() {
    if(description == '' &&  cancellationPolicy == '' &&  roomView == '' &&  smokingPolicy == '' &&   roomNumber == 0 &&  maximumPeople == 0  &&  roomSize == 0 &&  bedQuantity ==  0 && urlOfImageUploaded.isEmpty) {
      commonAlertBox(context, 'WARNING!', 'Please fill out all fields!');
    } else if(description == '') {
      commonAlertBox(context, 'WARNING!', 'Description field can not be empty!');
    }else if(cancellationPolicy == '') {
      commonAlertBox(context, 'WARNING!', 'Cancellation policy field can not be empty!');
    } else if(roomView == '') {
      commonAlertBox(context, 'WARNING!', 'Room view field can not be empty!');
    } else if(smokingPolicy == '') {
      commonAlertBox(context, 'WARNING!', 'Smoking policy field can not be empty!');
    } else if(urlOfImageUploaded.isEmpty) {
      commonAlertBox(context, 'WARNING!', 'Please upload atleast 1 image!');
    } else{
      _addNewRoomFirestore.collection('room_data').add({'availability':roomAvailabilityDropdownDefault, 'availableAmenities':selectedAmenities, 'bedQuantity':bedQuantity, 'bedType':bedType, 'cancellationPolicy': cancellationPolicy, 'currencyType':selectedCurrencyCode, 'description': description, 'images':urlOfImageUploaded, 'maximumPeople':maximumPeople, 'rent':rentAmount, 'roomNumber':roomNumber, 'roomType':roomTypeDropdownDefault, 'smokingPolicy':smokingPolicy, 'viewType':roomView});
      commonAlertBoxWithNavigation(context, 'SUCCESS!', 'Room added successfully.', '/staff_dashboard');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
        drawerEnableOpenDragGesture: true,
        drawer: SideDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add New Room', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
          backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
          iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
        ),
        body: SingleChildScrollView(
          child: uploading == true ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Text('Uploading Photo(s)'),
                ],
              )
            ),
          ) : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Room number
                            TextField(
                              controller: roomNumberController,
                              keyboardType: TextInputType.number,
                              onChanged:(value){
                                setState(() {
                                  roomNumber = int.parse(value);
                                });
                              },
                              style: TextStyle(color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
                              decoration: textInputDecoration('Room Number'),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Room Type
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Room Type:',  style:  isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                DropdownButton(
                                  value: roomTypeDropdownDefault,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: roomTypeDropdown.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      roomTypeDropdownDefault = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Description
                            TextField(
                              controller: descriptionController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 6,
                              onChanged:(value){
                                setState(() {
                                  description = value;
                                });
                              },
                              style: TextStyle(color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
                              decoration: textInputDecoration('Description'),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Room Capacity
                            TextField(
                              controller: maximumPeopleController,
                              keyboardType: TextInputType.number,
                              onChanged:(value){
                                setState(() {
                                  maximumPeople = int.parse(value);
                                });
                              },
                              style: TextStyle(color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
                              decoration: textInputDecoration('Room Capacity'),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            //Room number
                            TextField(
                              controller: bedQuantityController,
                              keyboardType: TextInputType.number,
                              onChanged:(value){
                                setState(() {
                                  bedQuantity = int.parse(value);
                                });
                              },
                              style: TextStyle(color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
                              decoration: textInputDecoration('Number Of Beds'),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Bed Type

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bed Type:',  style:  isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                DropdownButton(
                                  value: bedType,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: bedTypeDropdown.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      roomTypeDropdownDefault = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Room Size
                            TextField(
                              controller: roomSizeController,
                              keyboardType: TextInputType.number,
                              onChanged:(value){
                                setState(() {
                                  roomSize = int.parse(value);
                                });
                              },
                              style: TextStyle(color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
                              decoration: textInputDecoration('Room Size (sq. ft.)'),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            //Currency Code
                            Padding(
                              padding:  const EdgeInsets.only(left: 10),
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Select a currency',
                                  style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle,
                                ),
                                items: currencies.map((currency) {
                                  return DropdownMenuItem<String>(
                                    value: '${currency.code} - ${currency.name}',
                                    child: Row(
                                      children: [
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 148),
                                          child: Text('${currency.code} - ${currency.name}', overflow: TextOverflow.ellipsis, style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle,),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                value: selectedCurrencyCode,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCurrencyCode = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  width: 250,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                                dropdownSearchData: DropdownSearchData(
                                  searchController: currencyDropdownController,
                                  searchInnerWidgetHeight: 50,
                                  searchInnerWidget: SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      expands: true,
                                      maxLines: null,
                                      controller: currencyDropdownController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Enter currency details',
                                        hintStyle: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle,
                                        // border: OutlineInputBorder(
                                        //   borderRadius: BorderRadius.circular(8),
                                        // ),
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
                                    currencyDropdownController.clear();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Currency Value
                            TextField(
                              controller: rentAmountController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              onChanged:(value){
                                setState(() {
                                  rentAmount = double.parse(value);
                                });
                              },
                              style: TextStyle(color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
                              decoration: textInputDecoration('Rent Per Night'),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Room Availability
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Room Availability:',  style:  isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: DropdownButton(
                                    value: roomAvailabilityDropdownDefault,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: roomAvailability.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value, style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        roomAvailabilityDropdownDefault = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Cancellation Policy
                            TextField(
                              controller: cancellationPolicyController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 6,
                              onChanged:(value){
                                setState(() {
                                  cancellationPolicy = value;
                                });
                              },
                              style: TextStyle(color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
                              decoration: textInputDecoration('Cancellation Policy'),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Room View
                            TextField(
                              controller: roomViewController,
                              keyboardType: TextInputType.text,
                              onChanged:(value){
                                setState(() {
                                  roomView = value;
                                });
                              },
                              style: TextStyle(color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
                              decoration: textInputDecoration('Room View Type'),
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Smoking Policy
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Smoking Policy:',  style:  isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: DropdownButton(
                                    value: smokingPolicy,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: smokingPolicyDropdown.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value, style: isDarkModeEnabled == false ? kDarkListingInputDecorationStyle : kLightListingInputDecorationStyle),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        smokingPolicy = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17.5,
                            ),
                            // Display the selected items
                            Text('Amenities Included:',  style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 350,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollController,
                                      child: ListView(
                                        controller: _scrollController,
                                        scrollDirection: Axis.vertical,
                                        children: amenityOptions.map((item) {
                                          return CheckboxListTile(
                                            title: Text(item,  style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                                            value: selectedAmenities.contains(item), // Check if the item is selected
                                            onChanged: (isChecked) {
                                              onItemCheck(isChecked, item);
                                            },
                                          );
                                        }).toList(),
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MaterialButton(
                              onPressed: isUploadButtonDisabled == true ? () => {
                                commonAlertBox(context, 'WARNING', 'You can not upload more than 6 images.')
                              } : photoSelector,
                              color:  isDarkModeEnabled == false ? kLightTitleColor : kDarkTitleColor,
                              child: Text('Upload Photos',style: isDarkModeEnabled == false ? kWhiteBoldTextSize20 : kBlueBoldTextSize20,),
                            ),

                            if(urlOfImageUploaded.isNotEmpty || urlOfImageUploaded!=null) ...[
                              const SizedBox(height:10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height - 220,
                                    child: Scrollbar(
                                      thickness: 10,
                                      controller: _scrollController2,
                                      child: ScrollConfiguration(
                                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          controller: _scrollController2,
                                          itemCount: urlOfImageUploaded.length,
                                          itemBuilder: (BuildContext context, int index) => Padding(
                                              padding: const EdgeInsets.only(top:6, bottom: 6),
                                              child: Column(
                                                children: [
                                                  Image.network(
                                                    urlOfImageUploaded[index],
                                                    height: 100,
                                                  ),
                                                  TextButton(
                                                    onPressed: () => {
                                                      deletePhoto(urlOfImageUploaded[index], index)
                                                    },
                                                    child: const Text('Delete Image',style: kRedBoldRegularText),
                                                  ),
                                                ],
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    ]
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  RoundedButton(
                    colour:kDarkTitleColor,
                    title:'Add New Room',
                    onPress:_addNewRoomButton,
                    txtStyle: isDarkModeEnabled == false ? kButtonBlackTextSize24 : kButtonBlueTextSize24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
