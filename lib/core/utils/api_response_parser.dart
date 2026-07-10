/// Parses any API JSON shape into your model(s).
///
/// Works with:
/// - direct list: `[{...}, {...}]`
/// - direct object: `{...}`
/// - wrapped list: `{ "data": [...] }`
/// - wrapped object: `{ "data": {...} }`
/// - nested list: `{ "data": { "items": [...] } }`
class ApiResponseParser {
  ApiResponseParser._();

  static dynamic resolve(
    dynamic json, {
    String? dataKey,
    String? listKey,
  }) {
    dynamic current = json;

    if (dataKey != null && current is Map && current.containsKey(dataKey)) {
      current = current[dataKey];
    }

    if (listKey != null && current is Map && current.containsKey(listKey)) {
      current = current[listKey];
    }

    return current;
  }

  /// Use when API returns `[]` or `{ "data": [] }`.
  static List<T> parseList<T>(
    dynamic json, {
    required T Function(Map<String, dynamic> json) fromJson,
    String? dataKey,
    String? listKey,
  }) {
    final resolved = resolve(json, dataKey: dataKey, listKey: listKey);

    if (resolved is List) {
      return resolved
          .whereType<Map>()
          .map((item) => fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    if (resolved is Map) {
      return [fromJson(Map<String, dynamic>.from(resolved))];
    }

    return [];
  }

  /// Use when API returns `{}` or `{ "data": {} }`.
  static T? parseObject<T>(
    dynamic json, {
    required T Function(Map<String, dynamic> json) fromJson,
    String? dataKey,
    String? listKey,
  }) {
    final resolved = resolve(json, dataKey: dataKey, listKey: listKey);

    if (resolved is Map) {
      return fromJson(Map<String, dynamic>.from(resolved));
    }

    if (resolved is List && resolved.isNotEmpty && resolved.first is Map) {
      return fromJson(Map<String, dynamic>.from(resolved.first as Map));
    }

    return null;
  }
}
