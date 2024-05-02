// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_products_by_search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allProductsBySearchHash() =>
    r'3428f2c22a5ebb59ded7fe99ce7d34e1fe1b5557';

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

/// See also [allProductsBySearch].
@ProviderFor(allProductsBySearch)
const allProductsBySearchProvider = AllProductsBySearchFamily();

/// See also [allProductsBySearch].
class AllProductsBySearchFamily extends Family<AsyncValue<Iterable<Product>>> {
  /// See also [allProductsBySearch].
  const AllProductsBySearchFamily();

  /// See also [allProductsBySearch].
  AllProductsBySearchProvider call(
    String query,
  ) {
    return AllProductsBySearchProvider(
      query,
    );
  }

  @override
  AllProductsBySearchProvider getProviderOverride(
    covariant AllProductsBySearchProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'allProductsBySearchProvider';
}

/// See also [allProductsBySearch].
class AllProductsBySearchProvider
    extends AutoDisposeFutureProvider<Iterable<Product>> {
  /// See also [allProductsBySearch].
  AllProductsBySearchProvider(
    String query,
  ) : this._internal(
          (ref) => allProductsBySearch(
            ref as AllProductsBySearchRef,
            query,
          ),
          from: allProductsBySearchProvider,
          name: r'allProductsBySearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allProductsBySearchHash,
          dependencies: AllProductsBySearchFamily._dependencies,
          allTransitiveDependencies:
              AllProductsBySearchFamily._allTransitiveDependencies,
          query: query,
        );

  AllProductsBySearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<Iterable<Product>> Function(AllProductsBySearchRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllProductsBySearchProvider._internal(
        (ref) => create(ref as AllProductsBySearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Iterable<Product>> createElement() {
    return _AllProductsBySearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllProductsBySearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AllProductsBySearchRef
    on AutoDisposeFutureProviderRef<Iterable<Product>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _AllProductsBySearchProviderElement
    extends AutoDisposeFutureProviderElement<Iterable<Product>>
    with AllProductsBySearchRef {
  _AllProductsBySearchProviderElement(super.provider);

  @override
  String get query => (origin as AllProductsBySearchProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
