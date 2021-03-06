import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_lovers_app/core/config/api_config.dart';
import 'package:game_lovers_app/core/database/games_database.dart';
import 'package:game_lovers_app/core/network/network_info.dart';
import 'package:game_lovers_app/core/theme/bloc/theme_bloc.dart';
import 'package:game_lovers_app/features/games/data/datasources/game_remote_data_source.dart';
import 'package:game_lovers_app/features/games/domain/repositories/game_repository.dart';
import 'package:game_lovers_app/features/games/domain/usecases/list_games.dart';
import 'package:game_lovers_app/features/home/presentation/bloc/home_page_bloc.dart';
import 'package:game_lovers_app/features/home/presentation/pages/home_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

import 'features/games/data/datasources/game_local_data_source.dart';
import 'features/games/data/repositories/game_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    Provider(
      create: (context) => GamesDatabase(),
    ),
    Provider(
      create: (context) => Dio(
        BaseOptions(
          headers: <String, String>{
            'authorization': 'Bearer ' + token,
            'Client-ID': clientID,
          },
        ),
      ),
    ),
    Provider<GameRemoteDataSource>(
      create: (context) => GameRemoteDataSourceImpl(
        httpClient: context.read<Dio>(),
      ),
    ),
    Provider<GameLocalDataSource>(
      create: (context) => GameLocalDataSource(
        context.read<GamesDatabase>(),
      ),
    ),
    Provider(
      create: (context) => NetworkInfo(
        InternetConnectionChecker(),
      ),
    ),
    Provider<GameRepository>(
      create: (context) => GameRepositoryImpl(
        gameRemoteDataSource: context.read<GameRemoteDataSource>(),
        gameLocalDataSource: context.read<GameLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),
    Provider(
      create: (context) => ListGames(
        gameRepository: context.read<GameRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => HomePageBloc(
        listGames: context.read<ListGames>(),
      ),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: BlocProvider(
        create: (context) => ThemeBloc(),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            debugPrint('ThemeBloc => $state ${state.themeData}');
            return MaterialApp(
              builder: (context, widget) => ResponsiveWrapper.builder(
                ClampingScrollWrapper.builder(context, widget!),
                defaultScale: true,
                breakpoints: const [
                  ResponsiveBreakpoint.resize(350, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(600, name: TABLET),
                  ResponsiveBreakpoint.resize(800, name: DESKTOP),
                  ResponsiveBreakpoint.autoScale(1200, name: 'XL'),
                ],
              ),
              debugShowCheckedModeBanner: false,
              theme: state.themeData,
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}
