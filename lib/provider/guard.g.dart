// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllGuardsHash() => r'abbadfbd7c9f39b7a798f0840719494ec5279285';

/// See also [getAllGuards].
@ProviderFor(getAllGuards)
final getAllGuardsProvider = AutoDisposeFutureProvider<List<Guard>>.internal(
  getAllGuards,
  name: r'getAllGuardsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllGuardsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllGuardsRef = AutoDisposeFutureProviderRef<List<Guard>>;
String _$findGuardHash() => r'9afe6d3fef9199d57fb9742aa6abeb4d74aa0d85';

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

/// See also [findGuard].
@ProviderFor(findGuard)
const findGuardProvider = FindGuardFamily();

/// See also [findGuard].
class FindGuardFamily extends Family<AsyncValue<Guard?>> {
  /// See also [findGuard].
  const FindGuardFamily();

  /// See also [findGuard].
  FindGuardProvider call(
    int id,
  ) {
    return FindGuardProvider(
      id,
    );
  }

  @override
  FindGuardProvider getProviderOverride(
    covariant FindGuardProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'findGuardProvider';
}

/// See also [findGuard].
class FindGuardProvider extends AutoDisposeFutureProvider<Guard?> {
  /// See also [findGuard].
  FindGuardProvider(
    int id,
  ) : this._internal(
          (ref) => findGuard(
            ref as FindGuardRef,
            id,
          ),
          from: findGuardProvider,
          name: r'findGuardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$findGuardHash,
          dependencies: FindGuardFamily._dependencies,
          allTransitiveDependencies: FindGuardFamily._allTransitiveDependencies,
          id: id,
        );

  FindGuardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Guard?> Function(FindGuardRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FindGuardProvider._internal(
        (ref) => create(ref as FindGuardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Guard?> createElement() {
    return _FindGuardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FindGuardProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FindGuardRef on AutoDisposeFutureProviderRef<Guard?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FindGuardProviderElement extends AutoDisposeFutureProviderElement<Guard?>
    with FindGuardRef {
  _FindGuardProviderElement(super.provider);

  @override
  int get id => (origin as FindGuardProvider).id;
}

String _$guardListNotifierHash() => r'92e21f8192bec800be6edb8c62da2b62f6ec7fdc';

/// See also [GuardListNotifier].
@ProviderFor(GuardListNotifier)
final guardListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<GuardListNotifier, List<Guard>>.internal(
  GuardListNotifier.new,
  name: r'guardListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$guardListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GuardListNotifier = AutoDisposeAsyncNotifier<List<Guard>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
