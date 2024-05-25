// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_by_id.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userByIdHash() => r'760a31c6cc8e6a71629e47820855ed996824f7ff';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userById].
@ProviderFor(userById)
const userByIdProvider = UserByIdFamily();

/// See also [userById].
class UserByIdFamily extends Family<AsyncValue<User?>> {
  /// See also [userById].
  const UserByIdFamily();

  /// See also [userById].
  UserByIdProvider call(
    String? uid,
  ) {
    return UserByIdProvider(
      uid,
    );
  }

  @override
  UserByIdProvider getProviderOverride(
    covariant UserByIdProvider provider,
  ) {
    return call(
      provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userByIdProvider';
}

/// See also [userById].
class UserByIdProvider extends StreamProvider<User?> {
  /// See also [userById].
  UserByIdProvider(
    String? uid,
  ) : this._internal(
          (ref) => userById(
            ref as UserByIdRef,
            uid,
          ),
          from: userByIdProvider,
          name: r'userByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userByIdHash,
          dependencies: UserByIdFamily._dependencies,
          allTransitiveDependencies: UserByIdFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String? uid;

  @override
  Override overrideWith(
    Stream<User?> Function(UserByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserByIdProvider._internal(
        (ref) => create(ref as UserByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  StreamProviderElement<User?> createElement() {
    return _UserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserByIdRef on StreamProviderRef<User?> {
  /// The parameter `uid` of this provider.
  String? get uid;
}

class _UserByIdProviderElement extends StreamProviderElement<User?>
    with UserByIdRef {
  _UserByIdProviderElement(super.provider);

  @override
  String? get uid => (origin as UserByIdProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
