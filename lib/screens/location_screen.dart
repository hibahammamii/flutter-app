import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location.dart';

import '../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationScreen extends StatefulWidget {
  static const routeName = '/location_screen';
  bool isEdite ;
  String locId;
  LocationScreen({this.isEdite,this.locId});



  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool isValid = true;
  String id = 'one';
  bool isFirstLocation =true;

 // Map<String, dynamic> _location = {
 //    'name': '',
 //    'lastName': '',
 //    'phone': '',
 //    'address': '',
 //  };
  var _location =LocationItem(id:'',name: '',lastName: '',phoneNumber: '',address: '', );

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      isValid = false;
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    if(widget.isEdite == false)

    await Provider.of<Location>(context, listen: false).addUserLocation(
        _location);
    if(widget.isEdite == true)
      await Provider.of<Location>(context,listen: false).updateLocation(widget.locId, _location);



  }

  @override
  Widget build(BuildContext context) {
    final locId =
    ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Info'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.90,
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                width: 150.w,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    // fillColor: kPrimaryColor,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          //  color: kPrimaryColor,

                                          ///  color: Colors.red,//this has no effect
                                          ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if(value.length<2 ||value.length>10)
                                     { return 'inter valid name';}
                                  },
                                  onSaved: (value) {
                                    _location.name= value;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 150.w,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'LastName',
                                    // fillColor: kPrimaryColor,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          //  color: kPrimaryColor,

                                          ///  color: Colors.red,//this has no effect
                                          ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.name,
                                  onSaved: (value) {
                                    _location.lastName= value;
                                  },
                                  validator: (value) {
                                    if(value.length<2 || value.length>10)
                                      return 'inter valid name';
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 200,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'phone',
                                // fillColor: kPrimaryColor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      //  color: kPrimaryColor,

                                      ///  color: Colors.red,//this has no effect
                                      ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if(value.length<11|| value.length>11)
                                  return 'inter valid phone number';
                              },
                              onSaved: (value) {
                                _location.phoneNumber= value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Flexible(
                            child: TextFormField(
                             // maxLines: 4,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                // fillColor: kPrimaryColor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      //  color: kPrimaryColor,

                                      ///  color: Colors.red,//this has no effect
                                      ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.streetAddress,
                              validator: (value) {
                                if(value.length<13 || value.length>80)
                                  return 'inter valid address';
                              },
                              onSaved: (value) {
                                _location.address = value;
                              },
                            ),
                          ),
                          Spacer(),
                          if (_isLoading)
                            CircularProgressIndicator()
                          else
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: TextButton(
                              // onPressed: () {
                              //   Navigator.of(context).pushNamed(
                              //
                              //     ProductDetailScreen.routeName,
                              //     arguments: product.id,);
                              //
                              // },

                              child: Text("save"
                                  //  textAlign: TextAlign.center,
                                  ),
                              onPressed: () {
                                isValid = true;
                              _submit();

                               if(isValid == true)
                                {//Provider.of<Location>(context, listen: false).fetchAndSetOrders();
                                  Navigator.pop(context);}

                               // ;
                               //  else
                               //




                              },
                              style: TextButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                primary: Colors.white,
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ))));
  }
}
