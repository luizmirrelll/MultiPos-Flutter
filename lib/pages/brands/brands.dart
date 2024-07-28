import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_final/helpers/AppTheme.dart';
import 'package:pos_final/helpers/otherHelpers.dart';
import 'package:pos_final/locale/MyLocalizations.dart';

import 'view_model_manger/brands_cubit.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  static int themeType = 1;
  static ThemeData themeData = AppTheme.getThemeFromThemeMode(themeType);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrandsCubit()..getBrands(),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(AppLocalizations.of(context).translate('brands'),
                style: AppTheme.getTextStyle(themeData.textTheme.titleLarge,
                    fontWeight: 600)),
          ),
          body: BlocBuilder<BrandsCubit, BrandsState>(
            builder: (context, state) {
              if (state is BrandsGetDataFailure)
                return Center(
                  child: Text(state.errorMessage),
                );
              else if (state is BrandsGetDataSuccessful) {
                if(state.brandsModel.isEmpty){
                  return Helper().noDataWidget(context);
                }
                return ListView.builder(
                    itemCount: state.brandsModel.length,
                    itemBuilder: (context, index) => Card(
                          color: Color(0xffedecf2),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: ListTile(
                              leading: Icon(Icons.category_outlined),
                              title: Text(state.brandsModel[index].name),
                              subtitle: Text(
                                  state.brandsModel[index].description ??
                                      ''),
                            ),
                          ),
                        ));
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
