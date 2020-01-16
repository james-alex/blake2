import 'dart:io';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:blake2/blake2.dart';

final List<String> keys = _getVectors('keys.txt');
final List<String> salts = _getVectors('salts.txt');
final List<String> personalizations = _getVectors('personalizations.txt');
final List<String> updates = _getVectors('updates.txt');

void main() {
  test('BLAKE2b Hashes', () {
    final hashes = _calculateHashes(Blake2b);

    expect(_compareHashes(hashes, 'blake2b.txt'), equals(true));
  });

  test('BLAKE2s Hashes', () {
    final hashes = _calculateHashes(Blake2s);

    expect(_compareHashes(hashes, 'blake2s.txt'), equals(true));
  });
}

List<Uint8List> _calculateHashes(Type type) {
  assert(type != null && (type == Blake2b || type == Blake2s));

  final hashes = List<Uint8List>(keys.length);

  var updateCount = 0;

  for (var i = 0; i < keys.length; i++) {
    final numUpdates = i % 4;

    final blake2 = (type == Blake2b)
        ? Blake2b.fromStrings(
            key: keys[i],
            salt: salts[i],
            personalization: personalizations[i],
          )
        : Blake2s.fromStrings(
            key: keys[i],
            salt: salts[i],
            personalization: personalizations[i],
          );

    for (var j = 0; j < numUpdates; j++) {
      blake2.updateWithString(updates[updateCount]);
      updateCount++;
    }

    var hash = blake2.digest();

    hashes[i] = hash;
  }

  return hashes;
}

List<String> _getVectors(String filename) {
  assert(filename != null);

  final file = File('test/test_vectors/$filename');

  final vectors = file.readAsLinesSync();

  for (var i = 0; i < vectors.length; i++) {
    if (vectors[i].isEmpty) vectors[i] = null;
  }

  return vectors;
}

bool _compareHashes(List<Uint8List> tests, String filename) {
  assert(tests != null);
  assert(filename != null);

  final vectors = _getVectors('hashes/$filename');

  assert(vectors.length == tests.length);

  for (var i = 0; i < vectors.length; i++) {
    final vector = Uint8List.fromList(
      vectors[i].split(',').map(int.parse).toList(),
    );

    for (var j = 0; j < vector.length; j++) {
      if (vector[j] != tests[i][j]) return false;
    }
  }

  return true;
}
