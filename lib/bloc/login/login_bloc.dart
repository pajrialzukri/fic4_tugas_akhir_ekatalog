import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/auth_datasources.dart';
import '../../data/models/request/login_model.dart';
import '../../data/models/responses/login_response.dart';
import 'package:http/http.dart' as http;
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthDatasource datasource;
  LoginBloc(
    this.datasource,
  ) : super(LoginInitial()) {
    on<SaveLoginEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        final result = await datasource.login(event.request);
        print('result: $result');

        saveTokenToSharedPreferences(result.getAccessToken);
        emit(LoginLoaded(model: result));
      } catch (error) {
        if (error is http.Response) {
          if (error.statusCode == 401) {
            emit(LoginError(
                errorMessage: 'Unauthorized. Please check your credentials.'));
          } else {
            emit(
                LoginError(errorMessage: 'Failed to login. Please try again.'));
          }
        } else {
          emit(LoginError(errorMessage: 'Failed to login. Please try again.'));
        }
      }
    });
  }

  void saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
}
