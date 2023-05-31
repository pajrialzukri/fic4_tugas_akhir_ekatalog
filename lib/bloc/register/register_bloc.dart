import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_auth_bloc/data/datasources/auth_datasources.dart';
import 'package:flutter_auth_bloc/data/models/request/register_model.dart';
import 'package:flutter_auth_bloc/data/models/responses/register_response.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthDatasource datasource;
  RegisterBloc(
    this.datasource,
  ) : super(RegisterInitial()) {
    on<SaveRegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      final result = await datasource.register(event.request);
      print(result);
      emit(RegisterLoaded(model: result));
    });
  }
}
