import 'package:mason/mason.dart';

import 'simple_bundle.dart';

MasonBundle getBundleForName(String name) {
  final bundle = {
    'simple': simpleBundle,
  }[name];
  if (bundle == null) {
    throw 'Invalid template $name';
  }
  return bundle;
}
