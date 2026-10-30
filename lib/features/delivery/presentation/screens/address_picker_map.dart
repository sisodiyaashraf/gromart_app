import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../config/store_config.dart';
import '../../domain/entities/address.dart';
import '../providers/address_provider.dart';
import '../widgets/address_form_fields.dart';

class AddressPickerMap extends StatefulWidget {
  final Address? initialAddress;
  const AddressPickerMap({super.key, this.initialAddress});

  @override
  State<AddressPickerMap> createState() => _AddressPickerMapState();
}

class _AddressPickerMapState extends State<AddressPickerMap> {
  final MapController _mapController = MapController();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _lbl, _l1, _l2, _city, _state, _zip;
  LatLng? _point;
  bool _isLocating = false, _isSaving = false;

  @override
  void initState() {
    super.initState();
    final a = widget.initialAddress;
    _lbl = TextEditingController(text: a?.label ?? 'Home');
    _l1 = TextEditingController(text: a?.line1 ?? '');
    _l2 = TextEditingController(text: a?.line2 ?? '');
    _city = TextEditingController(text: a?.city ?? '');
    _state = TextEditingController(text: a?.state ?? '');
    _zip = TextEditingController(text: a?.zip ?? '');
    if (a != null && a.lat != 0.0 && a.lng != 0.0) _point = LatLng(a.lat, a.lng);
  }

  @override
  void dispose() {
    _mapController.dispose();
    for (final c in [_lbl, _l1, _l2, _city, _state, _zip]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("GPS disabled. Enter address manually.")),
        );
        return;
      }
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied || p == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied. Enter manually.")),
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (!mounted) return;
      final pt = LatLng(pos.latitude, pos.longitude);
      _mapController.move(pt, 16.0);
      _onPointPicked(pt);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _onPointPicked(LatLng pt) async {
    setState(() => _point = pt);
    try {
      final marks = await placemarkFromCoordinates(pt.latitude, pt.longitude);
      if (!mounted || marks.isEmpty) return;
      final m = marks.first;
      if (_l1.text.trim().isEmpty) {
        _l1.text = [m.street, m.subLocality].where((s) => s != null && s.isNotEmpty).join(', ');
      }
      if (_city.text.trim().isEmpty) _city.text = m.locality ?? m.subAdministrativeArea ?? '';
      if (_state.text.trim().isEmpty) _state.text = m.administrativeArea ?? '';
      if (_zip.text.trim().isEmpty) _zip.text = m.postalCode ?? '';
    } catch (_) {}
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;
    if (_point == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please tap on map to pick location.")),
      );
      return;
    }
    setState(() => _isSaving = true);
    final address = Address(
      id: widget.initialAddress?.id ?? '',
      label: _lbl.text.trim().isEmpty ? 'Home' : _lbl.text.trim(),
      line1: _l1.text.trim(),
      line2: _l2.text.trim().isNotEmpty ? _l2.text.trim() : null,
      city: _city.text.trim(),
      state: _state.text.trim().isNotEmpty ? _state.text.trim() : null,
      zip: _zip.text.trim().isNotEmpty ? _zip.text.trim() : null,
      lat: _point!.latitude,
      lng: _point!.longitude,
      isDefault: widget.initialAddress?.isDefault ?? false,
    );
    try {
      final p = context.read<AddressProvider>();
      widget.initialAddress == null ? await p.addAddress(address) : await p.updateAddress(address);
      if (!mounted) return;
      Navigator.of(context).pop(address);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _point ?? const LatLng(StoreConfig.storeLat, StoreConfig.storeLng);
    return Scaffold(
      appBar: AppBar(title: Text(widget.initialAddress == null ? "Add Address" : "Edit Address")),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(initialCenter: c, initialZoom: 15.0, onTap: (_, p) => _onPointPicked(p)),
                  children: [
                    TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.project_01'),
                    if (_point != null)
                      MarkerLayer(markers: [Marker(point: _point!, width: 44, height: 44, child: const Icon(Icons.location_on, color: Colors.red, size: 44))]),
                  ],
                ),
                Positioned(
                  bottom: 12, right: 12,
                  child: FloatingActionButton.small(
                    heroTag: 'loc_btn', onPressed: _isLocating ? null : _useCurrentLocation,
                    child: _isLocating ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AddressFormFields(formKey: _formKey, labelController: _lbl, line1Controller: _l1, line2Controller: _l2, cityController: _city, stateController: _state, zipController: _zip),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveAddress,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800, foregroundColor: Colors.white),
                      child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text("Save Address"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
