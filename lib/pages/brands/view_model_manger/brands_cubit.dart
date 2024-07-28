import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_final/apis/brands.dart';
import 'package:pos_final/models/brand_model.dart';

part 'brands_state.dart';

class BrandsCubit extends Cubit<BrandsState> {
  BrandsCubit() : super(BrandsInitial());

  Future<void> getBrands() async {
    emit(const BrandsGetDataLoading());
    final data = await BrandsServices().getBrands();
    if (data.error == null) {
      List<BusinessBrands> brands = [];
      for (Map<String, dynamic> json in data.response!.data['data']) {
        brands.add(BusinessBrands.fromJson(json));
      }

      emit(BrandsGetDataSuccessful(brands));
    } else {
      emit(BrandsGetDataFailure(data.error));
    }
  }
}
