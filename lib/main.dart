import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered_architecture/domain/repositories/notification_repository.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_bloc.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_event.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_state.dart';
import 'package:layered_architecture/presentation/blocs/notification/notification_bloc.dart';
import 'package:layered_architecture/presentation/blocs/notification/notification_state.dart';
import 'package:layered_architecture/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:layered_architecture/presentation/factories/coffee_house_factory.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => NotificationRepository(),
        ),
        // RepositoryProvider(
        //   create: (_) => StarbucksChainRepository(),
        // ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationBloc(
            notificationRepository: context.read(),
          ),
        ),
        BlocProvider(
          create: (_) => WalletBloc(),
        ),
        BlocProvider(
            create: (_) => CoffeeHouseFactory(
                  notificationRepository: context.read(),
                ).create()
            //  CoffeeHouseBloc(
            //   coffeeHouseRepository: context.read<StarbucksChainRepository>(),
            //   notificationRepository: context.read(),
            //   brewCoffeeUseCase: BrewCoffeeUseCase(
            //     coffeeHouseRepository: context.read<StarbucksChainRepository>(),
            //     notificationRepository: context.read(),
            //   ),
            // ),
            ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                BlocListener<NotificationBloc, NotificationState>(
              listener: (context, state) {
                if (state case NotificationData(:final message)) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                }
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<NotificationRepository>()
                            .notify('Hello World');
                      },
                      child: const Text('Let the world know!'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<WalletBloc>()
                            .add(const WalletUpdate(amount: '100'));
                      },
                      child: const Text('Add money'),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text('Money: ${context.watch<WalletBloc>().state.amount}'),
                    BlocBuilder<CoffeeHouseBloc, CoffeeHouseState>(
                      builder: (context, state) {
                        final storeName =
                            context.read<CoffeeHouseBloc>().storeName;

                        return Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<CoffeeHouseBloc>()
                                    .add(const CoffeeHouseOpenStore());
                              },
                              child: Text('Open $storeName'),
                            ),
                            if (state is CoffeeHouseStoreClosed) ...{
                              Text('$storeName is closed'),
                            },
                            ElevatedButton(
                              onPressed: state is CoffeeHouseStoreClosed
                                  ? null
                                  : () {
                                      context
                                          .read<CoffeeHouseBloc>()
                                          .add(const CoffeeHouseBrewCoffee(
                                            coffee: 'Pumpkin Spice Latte',
                                          ));
                                    },
                              child: const Text('Brew Pumpkin Spice Latte'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
