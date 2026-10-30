import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/supabase_address_repository.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';

/// Provider managing user saved addresses with Supabase persistence.
class AddressProvider extends ChangeNotifier {
  final AddressRepository _repository;
  final List<Address> _addresses = [];
  StreamSubscription<AuthState>? _authSub;

  bool _isLoading = false;
  String? _error;

  AddressProvider({AddressRepository? repository})
      : _repository = repository ?? SupabaseAddressRepository() {
    _initAuth();
  }

  List<Address> get addresses => List.unmodifiable(_addresses);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Address? get defaultAddress {
    if (_addresses.isEmpty) return null;
    final matches = _addresses.where((a) => a.isDefault);
    if (matches.isNotEmpty) return matches.first;
    return _addresses.first;
  }

  void _initAuth() {
    try {
      final client = Supabase.instance.client;
      final currentSession = client.auth.currentSession;
      if (currentSession != null) {
        loadAddresses();
      }

      _authSub = client.auth.onAuthStateChange.listen((data) {
        if (data.event == AuthChangeEvent.initialSession ||
            data.event == AuthChangeEvent.signedIn) {
          if (data.session != null) {
            loadAddresses();
          }
        } else if (data.event == AuthChangeEvent.signedOut) {
          _addresses.clear();
          _error = null;
          notifyListeners();
        }
      });
    } catch (_) {
      // Allows testing in environments where Supabase is not initialized
    }
  }

  Future<void> loadAddresses() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      _addresses.clear();
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final list = await _repository.getAddresses(userId);
      _addresses
        ..clear()
        ..addAll(list);
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to load addresses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Address?> addAddress(Address address) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;

    final isFirst = _addresses.isEmpty;
    final shouldBeDefault = isFirst || address.isDefault;

    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final saved = await _repository.addAddress(
        address,
        userId,
        isDefault: shouldBeDefault,
      );
      if (shouldBeDefault) {
        for (var i = 0; i < _addresses.length; i++) {
          if (_addresses[i].isDefault) {
            _addresses[i] = _addresses[i].copyWith(isDefault: false);
          }
        }
      }
      _addresses.add(saved);
      return saved;
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to add address: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAddress(Address address) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final updated = await _repository.updateAddress(address, userId);
      final idx = _addresses.indexWhere((a) => a.id == address.id);
      if (idx != -1) {
        _addresses[idx] = updated;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to update address: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAddress(String id) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final wasDefault = _addresses.any((a) => a.id == id && a.isDefault);
      await _repository.deleteAddress(id, userId);
      _addresses.removeWhere((a) => a.id == id);
      if (wasDefault && _addresses.isNotEmpty) {
        final newDefault = _addresses.first;
        await _repository.setDefaultAddress(newDefault.id, userId);
        _addresses[0] = newDefault.copyWith(isDefault: true);
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to delete address: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setDefault(String id) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.setDefaultAddress(id, userId);
      for (var i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: _addresses[i].id == id);
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to set default address: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
