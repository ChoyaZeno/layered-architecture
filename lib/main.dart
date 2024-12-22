import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:utilities/line/dotted_line.dart';
import 'package:layered_architecture/domain/repositories/notification_repository.dart';
import 'package:layered_architecture/domain/usecases/slots/open_slot.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_bloc.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_event.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_state.dart';
import 'package:layered_architecture/presentation/blocs/hud/hud_bloc.dart';
import 'package:layered_architecture/presentation/blocs/notification/notification_bloc.dart';
import 'package:layered_architecture/presentation/blocs/notification/notification_state.dart';
import 'package:layered_architecture/presentation/blocs/slots/slots_cubit.dart';
import 'package:layered_architecture/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:layered_architecture/presentation/factories/coffee_house_factory.dart';
import 'package:layered_architecture/services/resource_manager.dart';
import 'package:layered_architecture/services/slot_manager.dart';
import 'package:utilities/scroll/custom_scroll.dart';

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
    final resourceManager = ResourceManager();
    final slotManager = SlotManager();

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
          create: (_) => HudBloc(
            resourceManager: resourceManager,
          ),
        ),
        BlocProvider(
          create: (_) => SlotsCubit(
            openSlotUseCase: OpenSlotUseCase(
              slotManager: slotManager,
              resourceManager: resourceManager,
              notificationRepository: context.read(),
            ),
          ),
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
          appBar: AppBar(
            backgroundColor: Colors.brown[700],
            title: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: BlocBuilder<HudBloc, HudState>(
                builder: (context, state) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildHudItem('Coffee', state.resources, Icons.local_cafe),
                    _buildHudItem('Guests', state.guests, Icons.group),
                    _buildHudItem('Money', state.money, Icons.monetization_on),
                  ],
                ),
              ),
            ),
          ),
          body: Builder(
            builder: (context) {
              final systemLocale = Localizations.localeOf(context).toString();
              print('locale $systemLocale');

              Stream.periodic(const Duration(seconds: 3), (_) {
                context.read<HudBloc>().add(const HudUpdateEvent());
              }).listen((_) {});

              return BlocListener<NotificationBloc, NotificationState>(
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
                child: OrientationBuilder(
                  builder: (context, orientation) =>
                      BlocBuilder<SlotsCubit, SlotsState>(
                    builder: (context, state) => ListView(
                      physics: const PageViewScrollPhysics(),
                      padding: EdgeInsets.zero,
                      scrollDirection: orientation == Orientation.portrait
                          ? Axis.vertical
                          : Axis.horizontal,
                      children: [
                        for (var i = 0; i < state.slots.length + 4; i++)
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Material(
                              color: Colors.red,
                              elevation: 1,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: DottedLineBoxDecoration(),
                                  // const BoxDecoration(
                                  //   color: Colors.red,
                                  //   border: Border(
                                  //     bottom: BorderSide(
                                  //       color: Colors.black,
                                  //       width: 2,
                                  //     ),
                                  //   ),
                                  //   // border: Border.all(
                                  //   //   color: Colors.black,
                                  //   //   width: 2,
                                  //   // ),
                                  // ),
                                  child: i == state.slots.length + 3
                                      ? TextButton(
                                          onPressed: () {
                                            context
                                                .read<SlotsCubit>()
                                                .openSlot();
                                          },
                                          child: Text('Add'),
                                        )
                                      : Text(
                                          'Hello, World!',
                                          style: TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Center(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       ElevatedButton(
                //         onPressed: () {
                //           context
                //               .read<NotificationRepository>()
                //               .notify('Hello World');
                //         },
                //         child: const Text('Let the world know!'),
                //       ),
                //       ElevatedButton(
                //         onPressed: () {
                //           context
                //               .read<WalletBloc>()
                //               .add(const WalletUpdate(amount: '100'));
                //           context.read<HudBloc>().add(const HudUpdateEvent());
                //         },
                //         child: const Text('Add money'),
                //       ),
                //       const SizedBox(
                //         height: 20.0,
                //       ),
                //       Text(
                //         'Money: ${context.watch<WalletBloc>().state.amount}',
                //       ),
                //       BlocBuilder<CoffeeHouseBloc, CoffeeHouseState>(
                //         builder: (context, state) {
                //           final storeName =
                //               context.read<CoffeeHouseBloc>().storeName;

                //           return Column(
                //             children: [
                //               ElevatedButton(
                //                 onPressed: () {
                //                   context
                //                       .read<CoffeeHouseBloc>()
                //                       .add(const CoffeeHouseOpenStore());
                //                 },
                //                 child: Text('Open $storeName'),
                //               ),
                //               if (state is CoffeeHouseStoreClosed) ...{
                //                 Text('$storeName is closed'),
                //               },
                //               ElevatedButton(
                //                 onPressed: state is CoffeeHouseStoreClosed
                //                     ? null
                //                     : () {
                //                         context
                //                             .read<CoffeeHouseBloc>()
                //                             .add(const CoffeeHouseBrewCoffee(
                //                               coffee: 'Pumpkin Spice Latte',
                //                             ));
                //                       },
                //                 child: const Text('Brew Pumpkin Spice Latte'),
                //               ),
                //             ],
                //           );
                //         },
                //       ),
                //     ],
                //   ),
                // ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHudItem(String label, int value, IconData icon) {
    final formatter = NumberFormat('#,###', 'nl_NL');
    final formattedValue = formatter.format(value);

    const fontColor = Colors.white;
    return Row(
      children: <Widget>[
        Icon(icon, size: 20, color: fontColor),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: fontColor,
                fontSize: 12,
              ),
            ),
            Text(
              formattedValue,
              style: const TextStyle(
                color: fontColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
