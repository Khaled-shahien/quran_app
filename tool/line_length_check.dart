import 'dart:io';

const int _defaultMaxLineLength = 80;
const List<String> _defaultRoots = <String>['lib'];

void main(List<String> args) {
  final config = _parseArgs(args);
  final violations = <String>[];

  for (final root in config.roots) {
    final rootDir = Directory(root);
    if (!rootDir.existsSync()) {
      continue;
    }

    for (final file
        in rootDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .where((file) => !_isGeneratedFile(file.path))) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.length > config.maxLineLength) {
          violations.add(
            '${_normalizePath(file.path)}:${i + 1}:${line.length}:$line',
          );
        }
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln(
      'Line-length check passed. No lines exceed '
      '${config.maxLineLength} characters.',
    );
    return;
  }

  stderr.writeln(
    'Line-length check failed: ${violations.length} violation(s) found.',
  );
  for (final violation in violations) {
    stderr.writeln(violation);
  }
  exitCode = 1;
}

bool _isGeneratedFile(String path) {
  final normalized = path.replaceAll('\\', '/');
  return normalized.endsWith('.g.dart') ||
      normalized.endsWith('.freezed.dart') ||
      normalized.contains('/build/');
}

String _normalizePath(String path) => path.replaceAll('\\', '/');

_CheckConfig _parseArgs(List<String> args) {
  var maxLineLength = _defaultMaxLineLength;
  var roots = List<String>.from(_defaultRoots);

  for (final arg in args) {
    if (arg.startsWith('--max=')) {
      final value = int.tryParse(arg.substring('--max='.length));
      if (value == null || value < 1) {
        _exitWithUsage('Invalid --max value: $arg');
      }
      maxLineLength = value;
      continue;
    }

    if (arg.startsWith('--roots=')) {
      final value = arg.substring('--roots='.length);
      final parsedRoots = value
          .split(',')
          .map((root) => root.trim())
          .where((root) => root.isNotEmpty)
          .toList();
      if (parsedRoots.isEmpty) {
        _exitWithUsage('Invalid --roots value: $arg');
      }
      roots = parsedRoots;
      continue;
    }

    if (arg == '--help' || arg == '-h') {
      _printUsage();
      exit(0);
    }

    _exitWithUsage('Unknown argument: $arg');
  }

  return _CheckConfig(maxLineLength: maxLineLength, roots: roots);
}

Never _exitWithUsage(String message) {
  stderr.writeln(message);
  _printUsage();
  exit(2);
}

void _printUsage() {
  stdout.writeln('Usage: dart run tool/line_length_check.dart [options]');
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln(
    '  --max=<number>      Maximum allowed line length (default: 80).',
  );
  stdout.writeln(
    '  --roots=<a,b,...>   Comma-separated directories to scan '
    '(default: lib).',
  );
  stdout.writeln('  --help, -h          Show this help message.');
}

class _CheckConfig {
  const _CheckConfig({required this.maxLineLength, required this.roots});

  final int maxLineLength;
  final List<String> roots;
}
