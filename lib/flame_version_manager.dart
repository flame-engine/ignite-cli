import 'dart:convert';

import 'package:http/http.dart' as http;

class FlameVersionManager {
  static late FlameVersionManager singleton;

  static Future<void> init() async {
    singleton = await FlameVersionManager.fetch();
  }

  final Map<Package, Versions> versions;

  const FlameVersionManager._(this.versions);

  static Future<FlameVersionManager> fetch() async {
    final futures = Package.values.map((package) {
      return _fetch(package).then((value) => MapEntry(package, value));
    });
    final entries = await Future.wait(futures);
    return FlameVersionManager._(Map.fromEntries(entries));
  }

  static Future<Versions> _fetch(Package package) async {
    final api = 'https://pub.dev/api/packages/${package.name}';
    final response = await http.get(Uri.parse(api));
    final definition = jsonDecode(response.body) as Map<String, dynamic>;
    final versions = (definition['versions'] as List<dynamic>)
        .map((dynamic e) => e as Map<String, dynamic>)
        .toList();
    return Versions.parse(versions);
  }
}

enum Package {
  flame('flame'),
  flameLint('flame_lint', isDevDependency: true),
  flameAudio('flame_audio'),
  flameBloc('flame_bloc'),
  flameFireAtlas('flame_fire_atlas'),
  flameForge2D('flame_forge2d'),
  flameOxygen('flame_oxygen'),
  flameRive('flame_rive'),
  flameSVG('flame_svg'),
  flameTest('flame_test', isDevDependency: true),
  flameTiled('flame_tiled');

  static final includedByDefault = {Package.flame, Package.flameLint};
  static final preSelectedByDefault = {Package.flameAudio, Package.flameTest};

  final String name;
  final bool isDevDependency;
  const Package(this.name, {this.isDevDependency = false});

  Map<String, String> toMustache(
    Map<Package, Versions> versions,
    String flameVersion,
  ) {
    final version = this == flame ? flameVersion : versions[this]!.main;
    return {'name': name, 'version': version};
  }

  static Package valueOf(String name) {
    return values.firstWhere((e) => e.name == name);
  }
}

class Versions {
  final List<String> versions;

  String get main => versions.first;
  List<String> get visible => versions.take(5).toList();

  const Versions(this.versions);

  factory Versions.parse(List<Map<String, dynamic>> json) {
    final versions = json.map((e) => e['version'] as String).toList().reversed;
    return Versions(versions.toList());
  }
}
