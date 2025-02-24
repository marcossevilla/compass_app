import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group(User, () {
    test('supports value comparisons', () {
      expect(
        User(name: 'name', picture: 'picture'),
        equals(User(name: 'name', picture: 'picture')),
      );
    });

    test(
      'can be instantiated',
      () => expect(
        User.fromJson({'name': 'name', 'picture': 'picture'}),
        isNotNull,
      ),
    );

    test(
      'fromJson returns a valid User',
      () => expect(
        User.fromJson({'name': 'name', 'picture': 'picture'}),
        isNotNull,
      ),
    );

    test(
      'toJson returns a valid map',
      () => expect(
        User(name: 'name', picture: 'picture').toJson(),
        equals({'name': 'name', 'picture': 'picture'}),
      ),
    );
  });

  group(UserApiModel, () {
    test('supports value comparisons', () {
      expect(
        UserApiModel(
          name: 'name',
          picture: 'picture',
          id: 'id',
          email: 'email',
        ),
        equals(
          UserApiModel(
            name: 'name',
            picture: 'picture',
            id: 'id',
            email: 'email',
          ),
        ),
      );
    });

    test('can be instantiated', () {
      expect(
        UserApiModel(
          name: 'name',
          picture: 'picture',
          id: 'id',
          email: 'email',
        ),
        isNotNull,
      );
    });

    test(
      'fromJson returns a valid UserApiModel',
      () => expect(
        UserApiModel.fromJson({
          'name': 'name',
          'picture': 'picture',
          'id': 'id',
          'email': 'email',
        }),
        isNotNull,
      ),
    );

    test(
      'toJson returns a valid map',
      () => expect(
        UserApiModel(
          name: 'name',
          picture: 'picture',
          id: 'id',
          email: 'email',
        ).toJson(),
        equals({
          'name': 'name',
          'picture': 'picture',
          'id': 'id',
          'email': 'email',
        }),
      ),
    );
  });
}
