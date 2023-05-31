import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/product_datasources.dart';
import '../../../data/models/request/product_model.dart';
import '../../../data/models/responses/product_response_model.dart';

part 'update_product_event.dart';
part 'update_product_state.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final ProductDatasources productDatasources;
  UpdateProductBloc(
    this.productDatasources,
  ) : super(UpdateProductInitial()) {
    on<DoUpdateProductEvent>((event, emit) async {
      emit(UpdateProductLoading());
      final result =
          await productDatasources.updateProduct(event.productModel, event.id);

      emit(UpdateProductLoaded(productResponseModel: result, id: event.id));
    });
  }
}
