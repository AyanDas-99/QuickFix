// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'can_cancel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$canCancelHash() => r'28f36893c2ad113e6dd58f21462aa044d702b4a2';

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

/// See also [canCancel].
@ProviderFor(canCancel)
const canCancelProvider = CanCancelFamily();

/// See also [canCancel].
class CanCancelFamily extends Family<AsyncValue<bool>> {
  /// See also [canCancel].
  const CanCancelFamily();

  /// See also [canCancel].
  CanCancelProvider call(
    Order order,
  ) {
    return CanCancelProvider(
      order,
    );
  }

  @override
  CanCancelProvider getProviderOverride(
    covariant CanCancelProvider provider,
  ) {
    return call(
      provider.order,
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
  String? get name => r'canCancelProvider';
}

/// See also [canCancel].
class CanCancelProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [canCancel].
  CanCancelProvider(
    Order order,
  ) : this._internal(
          (ref) => canCancel(
            ref as CanCancelRef,
            order,
          ),
          from: canCancelProvider,
          name: r'canCancelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$canCancelHash,
          dependencies: CanCancelFamily._dependencies,
          allTransitiveDependencies: CanCancelFamily._allTransitiveDependencies,
          order: order,
        );

  CanCancelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.order,
  }) : super.internal();

  final Order order;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CanCancelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CanCancelProvider._internal(
        (ref) => create(ref as CanCancelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        order: order,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CanCancelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CanCancelProvider && other.order == order;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, order.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CanCancelRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `order` of this provider.
  Order get order;
}

class _CanCancelProviderElement extends AutoDisposeFutureProviderElement<bool>
    with CanCancelRef {
  _CanCancelProviderElement(super.provider);

  @override
  Order get order => (origin as CanCancelProvider).order;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
