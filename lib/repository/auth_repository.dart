import 'dart:convert';
import 'package:docs_clone/constant.dart';
import 'package:docs_clone/model/errormodel.dart';
import 'package:docs_clone/model/usermodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
    (ref) => AuthRepository(googleSignIn: GoogleSignIn(), client: Client()));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({required GoogleSignIn googleSignIn, required Client client})
      : _googleSignIn = googleSignIn,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(error: 'some unexpected error', data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName!,
          profilePic: user.photoUrl!,
          uid: '',
          token: '',
        );
        var res = await _client.post(
          Uri.parse('$host/signup'),
          body: userAcc.toJson(),
          headers: {'Content-Type': 'application/json;charset=UTF-8'},
        );

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
            );
            error = ErrorModel(error: null, data: newUser);
            break;
          default:
            throw 'Some error Occured';
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}
