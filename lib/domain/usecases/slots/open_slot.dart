import 'package:dartz/dartz.dart';
import 'package:layered_architecture/domain/repositories/notification_repository.dart';
import 'package:layered_architecture/services/resource_manager.dart';
import 'package:layered_architecture/services/slot_manager.dart';

class OpenSlotUseCase {
  OpenSlotUseCase({
    required SlotManager slotManager,
    required ResourceManager resourceManager,
    required NotificationRepository notificationRepository,
  })  : _slotManager = slotManager,
        _resourceManager = resourceManager,
        _notificationRepository = notificationRepository;

  final SlotManager _slotManager;
  final ResourceManager _resourceManager;
  final NotificationRepository _notificationRepository;

  Future<Either<String, SlotMapping>> call() async {
    final resourceState = _resourceManager.getState();

    if (resourceState.money < 100) {
      _notificationRepository.notify('Insufficient money');
      return const Left('');
    }

    final resourceAction = await _resourceManager.takeMoney(100);

    return resourceAction.bind((_) {
      _slotManager.openSlot();
      _notificationRepository.notify('Slot opened');

      return Right(_slotManager.getState());
    });
  }
}
