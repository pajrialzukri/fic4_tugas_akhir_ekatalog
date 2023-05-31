import 'package:flutter/material.dart';
import 'package:flutter_auth_bloc/bloc/product/delete_product/delete_product_bloc.dart';
import 'package:flutter_auth_bloc/bloc/product/update_product/update_product_bloc.dart';
import 'package:flutter_auth_bloc/bloc/register/register_bloc.dart';
import 'package:flutter_auth_bloc/data/datasources/auth_datasources.dart';
import 'package:flutter_auth_bloc/presentation/pages/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/login/login_bloc.dart';
import 'bloc/product/create_product/create_product_bloc.dart';
import 'bloc/product/get_all_product/get_all_product_bloc.dart';
import 'bloc/profile/profile_bloc.dart';
import 'data/datasources/product_datasources.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(AuthDatasource()),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => CreateProductBloc(ProductDatasources()),
        ),
        BlocProvider(
          create: (context) => GetAllProductBloc(ProductDatasources()),
        ),
        BlocProvider(
          create: (context) => UpdateProductBloc(ProductDatasources()),
        ),
        BlocProvider(
          create: (context) => DeleteProductBloc(ProductDatasources()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth Bloc',
        routes: appRoutes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme().copyWith(
            // Tambahkan penyesuaian gaya teks kustom di sini
            headlineLarge: GoogleFonts.poppins(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            // tambahkan penyesuaian teks lainnya sesuai kebutuhan Anda
          ),
        ),
        initialRoute: '/',
      ),
    );
  }
}
