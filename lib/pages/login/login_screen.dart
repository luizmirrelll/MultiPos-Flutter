import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_final/constants.dart';
import 'package:pos_final/helpers/AppTheme.dart';
import 'package:pos_final/locale/MyLocalizations.dart';

import 'view_model_manger/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailed) {
            LoginCubit.get(context).isLoading = false;
            Fluttertoast.showToast(
                fontSize: 18,
                backgroundColor: Colors.red,
                msg: AppLocalizations.of(context)
                    .translate('invalid_credentials'));
          } else if (state is LoginSuccessfully) {
            LoginCubit.get(context).navigateToHome(context);
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
              body: SafeArea(
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xCF583C8F),
                kDefaultColor.withOpacity(.9),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/welcome.json',
                          height: size.height * .1),
                      Text(
                        'ASAHL POS',
                        style: cubit.themeData.textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: size.height * 0.07),
                        height: size.height * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextFormField(
                              style: AppTheme.getTextStyle(
                                  cubit.themeData.textTheme.bodyLarge,
                                  letterSpacing: 0.1,
                                  color:
                                      cubit.themeData.colorScheme.onBackground,
                                  fontWeight: 500),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('username'),
                                hintStyle: AppTheme.getTextStyle(
                                    cubit.themeData.textTheme.titleSmall,
                                    letterSpacing: 0.1,
                                    color: cubit
                                        .themeData.colorScheme.onBackground,
                                    fontWeight: 500),
                                filled: true,
                                fillColor:
                                    const Color.fromRGBO(248, 247, 251, 1),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      color: kDefaultColor,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      color: kDefaultColor,
                                    )),
                                suffixIcon: Icon(MdiIcons.faceMan),
                              ),
                              controller: cubit.usernameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)
                                      .translate('please_enter_username');
                                }
                                return null;
                              },
                              autofocus: true,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              style: AppTheme.getTextStyle(
                                  cubit.themeData.textTheme.bodyLarge,
                                  letterSpacing: 0.1,
                                  color:
                                      cubit.themeData.colorScheme.onBackground,
                                  fontWeight: 500),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('password'),
                                hintStyle: AppTheme.getTextStyle(
                                    cubit.themeData.textTheme.titleSmall,
                                    letterSpacing: 0.1,
                                    color: cubit
                                        .themeData.colorScheme.onBackground,
                                    fontWeight: 500),
                                filled: true,
                                fillColor:
                                    const Color.fromRGBO(248, 247, 251, 1),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      color: kDefaultColor,
                                    )),
                                suffixIcon: IconButton(
                                  color: kDefaultColor,
                                  icon: Icon(cubit.passwordIcon),
                                  onPressed: () {
                                    cubit.passwordVisible =
                                        !cubit.passwordVisible;
                                    /*setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });*/
                                  },
                                ),
                              ),
                              obscureText: !cubit.passwordVisible,
                              controller: cubit.passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)
                                      .translate('please_enter_password');
                                }
                                return null;
                              },
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await cubit.checkOnLogin(context);
                              },
                              child: Text(
                                AppLocalizations.of(context).translate('login'),
                                style: cubit.themeData.textTheme.labelLarge,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('no_account'),
                        style: cubit.themeData.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await cubit.register();
                        },
                        child: Text(
                          AppLocalizations.of(context).translate('register'),
                          style: cubit.themeData.textTheme.labelLarge,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}
