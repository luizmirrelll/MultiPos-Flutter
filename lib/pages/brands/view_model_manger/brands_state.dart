part of 'brands_cubit.dart';


abstract class BrandsState {
  const BrandsState();
}

class BrandsInitial extends BrandsState {}

class BrandsGetDataLoading extends BrandsState {
  const BrandsGetDataLoading();
}
class BrandsGetDataSuccessful extends BrandsState {
  final List<BusinessBrands> brandsModel;
  const BrandsGetDataSuccessful(this.brandsModel);
}
class BrandsGetDataFailure extends BrandsState {
  final String errorMessage;
  const BrandsGetDataFailure(this.errorMessage);
}