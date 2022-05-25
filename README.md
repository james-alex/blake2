# blake2

[![pub package](https://img.shields.io/pub/v/blake2.svg)](https://pub.dartlang.org/packages/blake2)

Pure Dart implementations of the BLAKE2b and BLAKE2s cryptographic
hashing functions.

# Usage

```dart
import 'package:blake2/blake2.dart';
```

The blake2 library contains 3 classes:
[Blake2b], [blake2s], and their parent class: [blake2].

Both [Blake2b] and [Blake2s] can be instanced directly, accepting
[Uint8List]s for the [key], [salt] and [personalization] parameters.

An [iv] can also be specified as a [Uint64List] or [Uint32List],
for [Blake2b] and [Blake2s] respectively.

All of the parameters are optional and can be left null.

The hash can be returned as a [Uint8List] with the `digest()` method,
or as a [String] with the `digestToString()` method.

```dart
const String key = '7a546d0acf4f30d371c505f32548c867';
const String salt = '39b69017';
const String personalization = '4d97847f';

final Blake2b blake2b = Blake2b(
  key: Uint8List.fromList(key.codeUnits),
  salt: Uint8List.fromList(salt.codeUnits),
  personalization: Uint8List.fromList(personalization.codeUnits),
);

print(blake2b.digest());

// Prints: [179, 80, 231, 226, 92, 124, 89, 99, 133, 217, 254, 167, 78, 189, 21, 254, 209, 126, 124, 142, 180, 193, 37, 196, 83, 167, 106, 44, 107, 178, 135, 23]

print(blake2b.digestToString());

// Prints: ÓZê]×8£ÛU]ÚÙ¬DÛ!;s¶Ø

blake2b.update(Uint8List.fromList([110, 101, 119, 32, 100, 97, 116, 97]));

print(blake2b.digestToString());

// Prints: {é2¾ë];²à&Õ½BXN¼ý(³ö(î&?½ND_
```

Each class also has a static method `fromStrings()`, that accepts
the [key], [salt], and [personalization] parameters as [String]s, and
a method `updateWithString()` to add additional data as a [String].

```dart
final Blake2s blake2s = Blake2s.fromStrings(
  key: '2805f1ad825b3489dae4c5526014c1ed',
  salt: '8d6efe2c',
  personalization: 'e9f6def7',
);

print(blake2s.digestToString());

// Prints: ÃÉØNPnû·Ì÷Eæüç-SºØ·Ò=ëik

blake2s.updateWithString('new data');

print(blake2s.digestToString());

// Prints: ßlF©óþ;+®Ð¸BaðÅª_#Y¥\²p

```
