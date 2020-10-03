import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userid;
  DateTime _expirydate;
  Timer _authtimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expirydate != null &&
        _expirydate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userid {
    return _userid;
  }

  Future<void> _authenticate(
      String email, String password, String urlsegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/$urlsegment?key=AIzaSyCGksuWFQOa19zcbbLI01RLIsdAcjUF1do";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responsedata = json.decode(response.body);
      if (responsedata["error"] != null) {
        throw HttpException(responsedata["error"]["message"]);
      }
      _token = responsedata["idToken"];
      _userid = responsedata["localId"];
      _expirydate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responsedata["expiresIn"],
          ),
        ),
      );
      _autologout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userdata = json.encode({
        "token": _token,
        "userid": _userid,
        "expirydate ": _expirydate.toIso8601String(),
      });
      pref.setString("userdata", userdata);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "accounts:signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "accounts:signInWithPassword");
  }

  Future<bool> tryautologin() async {
    print("Try TO Login");
    final pref = await SharedPreferences.getInstance();
    try{
      if (pref.getString("userdata") == null) {
        print("Have User Data");
        return false;
    }
    final extractedUserData = json.decode(pref.getString("userdata")) as Map<String,Object>;
    print(extractedUserData);
    print(extractedUserData['expirydate']);
    final expierydate = DateTime.parse(extractedUserData["expirydate"]);

    if(expierydate.isBefore(DateTime.now())){
      print("Expiry Date Found");
      return false;
    }
    _token = extractedUserData["token"];
    _userid = extractedUserData["userid"];  
    _expirydate = extractedUserData["expirydate"];

    print("token" + _token);
    print("userId" + _userid);
    print("_expirydate" + _expirydate.toIso8601String());
    _autologout();
    notifyListeners();
    return true;
    }catch (e) {
      print(e);
    }
    
  }

  Future<void> logout() async {
    _token = null;
    _userid = null;
    _expirydate = null;

    if (_authtimer != null) {
      _authtimer.cancel();
      _authtimer = null;
    }
    final pref = await SharedPreferences.getInstance();
    // pref.remove("userdata");
    pref.clear();
    notifyListeners();

  }

  void _autologout() {
    if (_authtimer != null) {
      _authtimer.cancel();
    }
    final exipirytime = _expirydate.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: exipirytime), logout);
    notifyListeners();
  }
}
