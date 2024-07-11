import 'dart:math';

String generateUID() {
  const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random.secure();
  return List.generate(10, (index) => chars[random.nextInt(chars.length)]).join();
}