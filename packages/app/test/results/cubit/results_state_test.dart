import 'package:compass_app/results/results.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void main() {
  group(ResultsState, () {
    const destination = Destination(
      ref: 'alps',
      name: 'Alps',
      country: 'Switzerland',
      continent: 'Europe',
      knownFor: 'Mountains',
      tags: ['Mountain'],
      imageUrl: 'https://example.com/alps.jpg',
    );
    const config = ItineraryConfig(continent: 'Europe');

    test('supports value equality', () {
      expect(const ResultsState(), equals(const ResultsState()));
    });

    test('props are correct', () {
      expect(
        const ResultsState().props,
        equals([
          const <Destination>[],
          const ItineraryConfig(),
          ResultsStatus.initial,
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object when no arguments are passed', () {
        expect(const ResultsState().copyWith(), equals(const ResultsState()));
      });

      test('replaces every value', () {
        expect(
          const ResultsState().copyWith(
            destinations: [destination],
            itineraryConfig: config,
            status: ResultsStatus.searchCompleted,
          ),
          equals(
            const ResultsState(
              destinations: [destination],
              itineraryConfig: config,
              status: ResultsStatus.searchCompleted,
            ),
          ),
        );
      });
    });
  });
}
