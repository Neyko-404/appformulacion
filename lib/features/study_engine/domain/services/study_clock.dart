abstract interface class StudyClock {
  DateTime now();
}

final class SystemStudyClock implements StudyClock {
  const SystemStudyClock();
  @override
  DateTime now() => DateTime.now();
}
