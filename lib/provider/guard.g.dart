// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$findGuardHash() => r'f21b670e8834e2ce8ab1ca6d71e1670be821e303';

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

/// Finds and returns a [Guard] object by its [id].
///
/// This method retrieves the list of guards from the [guardListNotifierProvider]
/// and filters it to find the guard with the provided [id].
/// If found, it returns the [Guard] object, otherwise returns null.
///
/// [ref] - The [FindGuardRef] instance to observe the [guardListNotifierProvider].
/// [id] - The unique identifier of the [Guard] object to find.
///
/// Returns [Guard?] - The [Guard] object with the matching [id] or null if not found.
///
/// Copied from [findGuard].
@ProviderFor(findGuard)
const findGuardProvider = FindGuardFamily();

/// Finds and returns a [Guard] object by its [id].
///
/// This method retrieves the list of guards from the [guardListNotifierProvider]
/// and filters it to find the guard with the provided [id].
/// If found, it returns the [Guard] object, otherwise returns null.
///
/// [ref] - The [FindGuardRef] instance to observe the [guardListNotifierProvider].
/// [id] - The unique identifier of the [Guard] object to find.
///
/// Returns [Guard?] - The [Guard] object with the matching [id] or null if not found.
///
/// Copied from [findGuard].
class FindGuardFamily extends Family<AsyncValue<Guard?>> {
  /// Finds and returns a [Guard] object by its [id].
  ///
  /// This method retrieves the list of guards from the [guardListNotifierProvider]
  /// and filters it to find the guard with the provided [id].
  /// If found, it returns the [Guard] object, otherwise returns null.
  ///
  /// [ref] - The [FindGuardRef] instance to observe the [guardListNotifierProvider].
  /// [id] - The unique identifier of the [Guard] object to find.
  ///
  /// Returns [Guard?] - The [Guard] object with the matching [id] or null if not found.
  ///
  /// Copied from [findGuard].
  const FindGuardFamily();

  /// Finds and returns a [Guard] object by its [id].
  ///
  /// This method retrieves the list of guards from the [guardListNotifierProvider]
  /// and filters it to find the guard with the provided [id].
  /// If found, it returns the [Guard] object, otherwise returns null.
  ///
  /// [ref] - The [FindGuardRef] instance to observe the [guardListNotifierProvider].
  /// [id] - The unique identifier of the [Guard] object to find.
  ///
  /// Returns [Guard?] - The [Guard] object with the matching [id] or null if not found.
  ///
  /// Copied from [findGuard].
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

/// Finds and returns a [Guard] object by its [id].
///
/// This method retrieves the list of guards from the [guardListNotifierProvider]
/// and filters it to find the guard with the provided [id].
/// If found, it returns the [Guard] object, otherwise returns null.
///
/// [ref] - The [FindGuardRef] instance to observe the [guardListNotifierProvider].
/// [id] - The unique identifier of the [Guard] object to find.
///
/// Returns [Guard?] - The [Guard] object with the matching [id] or null if not found.
///
/// Copied from [findGuard].
class FindGuardProvider extends AutoDisposeFutureProvider<Guard?> {
  /// Finds and returns a [Guard] object by its [id].
  ///
  /// This method retrieves the list of guards from the [guardListNotifierProvider]
  /// and filters it to find the guard with the provided [id].
  /// If found, it returns the [Guard] object, otherwise returns null.
  ///
  /// [ref] - The [FindGuardRef] instance to observe the [guardListNotifierProvider].
  /// [id] - The unique identifier of the [Guard] object to find.
  ///
  /// Returns [Guard?] - The [Guard] object with the matching [id] or null if not found.
  ///
  /// Copied from [findGuard].
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

String _$guardListNotifierHash() => r'd87b9de27c57dae697aad83bd97c745219fd485a';

/// Manages a list of [Guard] objects by interfacing with the Isar database.
///
/// This notifier provides asynchronous operations to read and modify the list
/// of guards. It includes methods to retrieve all guards, add or update a single
/// guard, and delete a guard by id. Changes to the list are persisted in the
/// Isar database and will trigger an update to all listeners.
///
/// Copied from [GuardListNotifier].
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
