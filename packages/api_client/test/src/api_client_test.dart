// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock implements HttpClient {}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

/// A fake [HttpClientResponse] backed by an in-memory [body].
///
/// `transform` and `join` are implemented in terms of [listen], so delegating
/// [listen] to a real stream is enough for the whole decode pipeline to work.
class _FakeHttpClientResponse extends Fake implements HttpClientResponse {
  _FakeHttpClientResponse(this.body, {this.statusCode = 200});

  final String body;

  @override
  final int statusCode;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(utf8.encode(body)).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  group(ApiClient, () {
    late HttpClient httpClient;
    late HttpClientRequest request;
    late HttpHeaders headers;
    late StreamController<String?> authHeaderController;
    late ApiClient apiClient;

    setUp(() {
      httpClient = _MockHttpClient();
      request = _MockHttpClientRequest();
      headers = _MockHttpHeaders();
      authHeaderController = StreamController<String?>.broadcast();

      when(() => request.headers).thenReturn(headers);

      apiClient = ApiClient(
        authHeaderProvider: authHeaderController.stream,
        client: httpClient,
      );
    });

    tearDown(() {
      unawaited(authHeaderController.close());
    });

    /// Stubs a GET request that returns [response].
    void stubGet(HttpClientResponse response) {
      when(
        () => httpClient.get(any(), any(), any()),
      ).thenAnswer((_) async => request);
      when(request.close).thenAnswer((_) async => response);
    }

    test('can be instantiated', () {
      expect(ApiClient(authHeaderProvider: Stream.empty()), isNotNull);
    });

    test('uses the provided host and port', () async {
      stubGet(_FakeHttpClientResponse('[]'));

      apiClient = ApiClient(
        authHeaderProvider: authHeaderController.stream,
        client: httpClient,
        host: 'example.com',
        port: 9090,
      );

      await apiClient.getContinents();

      verify(() => httpClient.get('example.com', 9090, '/continent')).called(1);
    });

    test('defaults to localhost:8080', () async {
      stubGet(_FakeHttpClientResponse('[]'));

      await apiClient.getContinents();

      verify(() => httpClient.get('localhost', 8080, '/continent')).called(1);
    });

    group('authHeader', () {
      test('does not add header when none has been provided', () async {
        stubGet(_FakeHttpClientResponse('[]'));

        await apiClient.getContinents();

        verifyZeroInteractions(headers);
      });

      test('adds the authorization header once provided', () async {
        stubGet(_FakeHttpClientResponse('[]'));

        authHeaderController.add('Bearer token');
        // Allow the subscription to process the emitted value.
        await Future<void>.delayed(Duration.zero);

        await apiClient.getContinents();

        verify(
          () => headers.add(HttpHeaders.authorizationHeader, 'Bearer token'),
        ).called(1);
      });

      test('ignores null auth header values', () async {
        stubGet(_FakeHttpClientResponse('[]'));

        authHeaderController
          ..add('Bearer token')
          ..add(null);
        await Future<void>.delayed(Duration.zero);

        await apiClient.getContinents();

        // The previously set header is retained.
        verify(
          () => headers.add(HttpHeaders.authorizationHeader, 'Bearer token'),
        ).called(1);
      });
    });

    group('getContinents', () {
      const continent = Continent(name: 'Europe', imageUrl: 'image');

      test('returns a list of continents on success', () async {
        stubGet(_FakeHttpClientResponse(jsonEncode([continent.toJson()])));

        final result = await apiClient.getContinents();

        expect(result, equals([continent]));
        verify(() => httpClient.get('localhost', 8080, '/continent')).called(1);
        verify(() => request.headers).called(1);
      });

      test('throws HttpException on non-200 response', () async {
        stubGet(_FakeHttpClientResponse('', statusCode: 500));

        expect(apiClient.getContinents(), throwsA(isA<HttpException>()));
      });
    });

    group('getDestinations', () {
      const destination = Destination(
        ref: 'alaska',
        name: 'Alaska',
        country: 'United States',
        continent: 'North America',
        knownFor: 'Wildlife',
        tags: ['Mountain'],
        imageUrl: 'image',
      );

      test('returns a list of destinations on success', () async {
        stubGet(_FakeHttpClientResponse(jsonEncode([destination.toJson()])));

        final result = await apiClient.getDestinations();

        expect(result, equals([destination]));
        verify(
          () => httpClient.get('localhost', 8080, '/destination'),
        ).called(1);
      });

      test('throws HttpException on non-200 response', () async {
        stubGet(_FakeHttpClientResponse('', statusCode: 404));

        expect(apiClient.getDestinations(), throwsA(isA<HttpException>()));
      });
    });

    group('getActivityByDestination', () {
      const activity = Activity(
        name: 'Glacier Trekking',
        description: 'Explore glaciers',
        locationName: 'Matanuska Glacier',
        duration: 8,
        timeOfDay: TimeOfDay.morning,
        familyFriendly: false,
        price: 4,
        destinationRef: 'alaska',
        ref: 'glacier-trekking',
        imageUrl: 'image',
      );

      test('returns a list of activities on success', () async {
        stubGet(_FakeHttpClientResponse(jsonEncode([activity.toJson()])));

        final result = await apiClient.getActivityByDestination('alaska');

        expect(result, equals([activity]));
        verify(
          () =>
              httpClient.get('localhost', 8080, '/destination/alaska/activity'),
        ).called(1);
      });

      test('throws HttpException on non-200 response', () async {
        stubGet(_FakeHttpClientResponse('', statusCode: 500));

        expect(
          apiClient.getActivityByDestination('alaska'),
          throwsA(isA<HttpException>()),
        );
      });
    });

    group('getBookings', () {
      final booking = BookingApiModel(
        id: 1,
        startDate: DateTime.utc(2024),
        endDate: DateTime.utc(2024, 1, 5),
        name: 'Alaska, North America',
        destinationRef: 'alaska',
        activitiesRef: const ['glacier-trekking'],
      );

      test('returns a list of bookings on success', () async {
        stubGet(_FakeHttpClientResponse(jsonEncode([booking.toJson()])));

        final result = await apiClient.getBookings();

        expect(result, equals([booking]));
        verify(() => httpClient.get('localhost', 8080, '/booking')).called(1);
      });

      test('throws HttpException on non-200 response', () async {
        stubGet(_FakeHttpClientResponse('', statusCode: 500));

        expect(apiClient.getBookings(), throwsA(isA<HttpException>()));
      });
    });

    group('getBooking', () {
      final booking = BookingApiModel(
        id: 7,
        startDate: DateTime.utc(2024),
        endDate: DateTime.utc(2024, 1, 5),
        name: 'Alaska, North America',
        destinationRef: 'alaska',
        activitiesRef: const ['glacier-trekking'],
      );

      test('returns a booking on success', () async {
        stubGet(_FakeHttpClientResponse(jsonEncode(booking.toJson())));

        final result = await apiClient.getBooking(7);

        expect(result, equals(booking));
        verify(() => httpClient.get('localhost', 8080, '/booking/7')).called(1);
      });

      test('throws HttpException on non-200 response', () async {
        stubGet(_FakeHttpClientResponse('', statusCode: 404));

        expect(apiClient.getBooking(7), throwsA(isA<HttpException>()));
      });
    });

    group('postBooking', () {
      final booking = BookingApiModel(
        startDate: DateTime.utc(2024),
        endDate: DateTime.utc(2024, 1, 5),
        name: 'Alaska, North America',
        destinationRef: 'alaska',
        activitiesRef: const ['glacier-trekking'],
      );
      final created = booking.copyWith(id: () => 1);

      void stubPost(HttpClientResponse response) {
        when(
          () => httpClient.post(any(), any(), any()),
        ).thenAnswer((_) async => request);
        when(request.close).thenAnswer((_) async => response);
      }

      test('writes the booking body and returns the created booking', () async {
        stubPost(
          _FakeHttpClientResponse(
            jsonEncode(created.toJson()),
            statusCode: 201,
          ),
        );

        final result = await apiClient.postBooking(booking);

        expect(result, equals(created));
        verify(() => httpClient.post('localhost', 8080, '/booking')).called(1);
        verify(() => request.write(jsonEncode(booking))).called(1);
      });

      test('throws HttpException on non-201 response', () async {
        stubPost(_FakeHttpClientResponse(''));

        expect(apiClient.postBooking(booking), throwsA(isA<HttpException>()));
      });
    });

    group('getUser', () {
      const user = UserApiModel(
        id: '1',
        email: 'me@example.com',
        name: 'Me',
        picture: 'image',
      );

      test('returns a user on success', () async {
        stubGet(_FakeHttpClientResponse(jsonEncode(user.toJson())));

        final result = await apiClient.getUser();

        expect(result, equals(user));
        verify(() => httpClient.get('localhost', 8080, '/user')).called(1);
      });

      test('throws HttpException on non-200 response', () async {
        stubGet(_FakeHttpClientResponse('', statusCode: 401));

        expect(apiClient.getUser(), throwsA(isA<HttpException>()));
      });
    });

    group('deleteBooking', () {
      void stubDelete(HttpClientResponse response) {
        when(
          () => httpClient.delete(any(), any(), any()),
        ).thenAnswer((_) async => request);
        when(request.close).thenAnswer((_) async => response);
      }

      test('completes on a 204 response', () async {
        stubDelete(_FakeHttpClientResponse('', statusCode: 204));

        await expectLater(apiClient.deleteBooking(3), completes);
        verify(
          () => httpClient.delete('localhost', 8080, '/booking/3'),
        ).called(1);
      });

      test('throws HttpException on non-204 response', () async {
        stubDelete(_FakeHttpClientResponse('', statusCode: 500));

        expect(apiClient.deleteBooking(3), throwsA(isA<HttpException>()));
      });
    });

    group('close', () {
      test('cancels the auth subscription and closes the client', () async {
        await apiClient.close();

        verify(() => httpClient.close(force: true)).called(1);
        // The subscription is cancelled so further emissions are ignored.
        authHeaderController.add('Bearer token');
        await Future<void>.delayed(Duration.zero);
      });
    });
  });
}
