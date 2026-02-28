import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'dart:math';

/// Performance Monitoring and Analytics Service
///
/// Provides comprehensive performance monitoring with:
/// - Startup time tracking
/// - Memory usage monitoring
/// - Frame rate measurement
/// - API response time tracking
/// - Custom metric collection
/// - Performance benchmarking

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  // Timing markers
  final Map<String, DateTime> _timingMarkers = {};
  final Map<String, Duration> _performanceMetrics = {};

  // Performance data collection
  final List<PerformanceData> _collectedData = [];
  final Map<String, List<double>> _customMetrics = {};

  /// Initialize performance monitoring
  Future<void> initialize() async {
    // Start application startup timer
    startTimer('app_startup');

    // Register platform information
    _addPerformanceMetric('platform_info', {
      'platform': Platform.operatingSystem,
      'version': Platform.version,
      'numberOfProcessors': Platform.numberOfProcessors,
    });
  }

  /// Start timing for a specific operation
  void startTimer(String name) {
    _timingMarkers[name] = DateTime.now();
  }

  /// End timing and record the duration
  void endTimer(String name) {
    if (!_timingMarkers.containsKey(name)) {
      if (kDebugMode) {
        print('Warning: No start timer found for $name');
      }
      return;
    }

    final start = _timingMarkers[name]!;
    final duration = DateTime.now().difference(start);
    _performanceMetrics[name] = duration;
    _timingMarkers.remove(name);

    // Add to collected data for reporting
    _collectedData.add(
      PerformanceData(
        operation: name,
        duration: duration,
        timestamp: DateTime.now(),
      ),
    );

    // Log performance metrics in debug mode
    if (kDebugMode) {
      _logPerformanceMetric(name, duration);
    }
  }

  /// Record custom performance metric
  void recordMetric(String name, double value, [String? unit]) {
    _customMetrics.putIfAbsent(name, () => []).add(value);

    // Add to performance metrics
    _addPerformanceMetric(name, {'value': value, 'unit': unit});

    if (kDebugMode) {
      print('PerformanceMetric: $name = $value${unit != null ? ' $unit' : ''}');
    }
  }

  /// Get average of a custom metric
  double? getAverageMetric(String name) {
    final metrics = _customMetrics[name];
    if (metrics == null || metrics.isEmpty) return null;
    return metrics.reduce((a, b) => a + b) / metrics.length;
  }

  /// Get performance metrics
  Map<String, dynamic> getPerformanceMetrics() {
    return {
      'timingMarkers': _performanceMetrics.map(
        (key, value) => MapEntry(key, value.inMilliseconds),
      ),
      'customMetrics': _customMetrics.map(
        (key, value) => MapEntry(key, {
          'average': getAverageMetric(key),
          'samples': value.length,
        }),
      ),
      'totalMetrics': _performanceMetrics.length + _customMetrics.length,
    };
  }

  /// Start memory monitoring
  void startMemoryMonitoring() {
    // Dart's memory monitoring requires calling this periodically
    if (kDebugMode) {
      print('Memory Monitoring Started');
    }
    // Note: Dart provides current memory usage but not trends easily
    // For production, use platform-specific solutions
  }

  /// Track API performance
  Future<T> trackApiPerformance<T>(
    Future<T> apiCall,
    String operationName,
  ) async {
    startTimer('${operationName}_api');

    try {
      final result = await apiCall;
      endTimer('${operationName}_api');

      // Record successful response time
      final responseTime =
          _performanceMetrics['${operationName}_api']?.inMilliseconds;
      if (responseTime != null) {
        recordMetric(
          'api_${operationName}_response_time',
          responseTime.toDouble(),
          'ms',
        );
      }

      return result;
    } catch (error) {
      // Record API error timing
      recordMetric('${operationName}_api_error_rate', 1.0, 'error');
      endTimer('${operationName}_api');
      rethrow;
    }
  }

  /// Monitor rendering performance (FPS tracking)
  late final FPSMonitor fpsMonitor = FPSMonitor();

  /// Performance benchmarking utility
  Future<List<PerformanceBenchmark>> runBenchmarks() async {
    final benchmarks = <PerformanceBenchmark>[];

    // Benchmark 1: JSON parsing
    benchmarks.add(await _benchmarkJsonParsing());

    // Benchmark 2: File I/O operations
    benchmarks.add(await _benchmarkFileOperations());

    // Benchmark 3: Network simulation
    benchmarks.add(await _benchmarkNetworkOperations());

    // Benchmark 4: UI rendering
    benchmarks.add(await _benchmarkUIRendering());

    return benchmarks;
  }

  /// Export performance data
  Map<String, dynamic> exportPerformanceData() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'metrics': getPerformanceMetrics(),
      'collectedData': _collectedData.map((data) => data.toJson()).toList(),
      'benchmarks': _runBenchmarkSummary(),
    };
  }

  /// Clear performance data
  void clearData() {
    _timingMarkers.clear();
    _performanceMetrics.clear();
    _collectedData.clear();
    _customMetrics.clear();
  }

  // Private helper methods
  void _addPerformanceMetric(String name, dynamic data) {
    _performanceMetrics[name] = Duration.zero; // Placeholder
    // In a real implementation, you'd store the actual data
  }

  void _logPerformanceMetric(String name, Duration duration) {
    final ms = duration.inMilliseconds;
    final color = ms > 1000
        ? '🔴'
        : ms > 100
        ? '🟡'
        : '🟢';
    print('$color Performance: $name took ${duration.inMilliseconds}ms');
  }

  Future<PerformanceBenchmark> _benchmarkJsonParsing() async {
    startTimer('json_parsing_benchmark');

    // Simulate JSON parsing workload
    final data = List.generate(
      1000,
      (index) => {
        'id': index,
        'name': 'Item $index',
        'value': Random().nextDouble() * 1000,
        'nested': {'level': 1, 'data': List.generate(10, (i) => 'nested_$i')},
      },
    );

    endTimer('json_parsing_benchmark');

    final duration = _performanceMetrics['json_parsing_benchmark']!;
    return PerformanceBenchmark(
      name: 'JSON Parsing',
      duration: duration,
      score: 1000 / duration.inMilliseconds,
      category: 'Data Processing',
    );
  }

  Future<PerformanceBenchmark> _benchmarkFileOperations() async {
    startTimer('file_operations_benchmark');

    // Simulate file operations
    for (int i = 0; i < 100; i++) {
      // Simulate file read/write operations
      await Future.delayed(const Duration(microseconds: 100));
    }

    endTimer('file_operations_benchmark');

    final duration = _performanceMetrics['file_operations_benchmark']!;
    return PerformanceBenchmark(
      name: 'File Operations',
      duration: duration,
      score: 10000 / duration.inMilliseconds,
      category: 'I/O Operations',
    );
  }

  Future<PerformanceBenchmark> _benchmarkNetworkOperations() async {
    startTimer('network_operations_benchmark');

    // Simulate network operations
    for (int i = 0; i < 50; i++) {
      await Future.delayed(const Duration(milliseconds: 10));
    }

    endTimer('network_operations_benchmark');

    final duration = _performanceMetrics['network_operations_benchmark']!;
    return PerformanceBenchmark(
      name: 'Network Operations',
      duration: duration,
      score: 5000 / duration.inMilliseconds,
      category: 'Network',
    );
  }

  Future<PerformanceBenchmark> _benchmarkUIRendering() async {
    startTimer('ui_rendering_benchmark');

    // Simulate UI rendering workload
    for (int i = 0; i < 200; i++) {
      // Simulate widget building
      await Future.delayed(const Duration(microseconds: 50));
    }

    endTimer('ui_rendering_benchmark');

    final duration = _performanceMetrics['ui_rendering_benchmark']!;
    return PerformanceBenchmark(
      name: 'UI Rendering',
      duration: duration,
      score: 20000 / duration.inMilliseconds,
      category: 'UI',
    );
  }

  Map<String, dynamic> _runBenchmarkSummary() {
    return {
      'totalBenchmarks': 4,
      'categories': ['Data Processing', 'I/O Operations', 'Network', 'UI'],
    };
  }
}

/// Performance data structure
class PerformanceData {
  final String operation;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  PerformanceData({
    required this.operation,
    required this.duration,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'operation': operation,
    'duration_ms': duration.inMilliseconds,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };
}

/// Performance benchmark result
class PerformanceBenchmark {
  final String name;
  final Duration duration;
  final double score;
  final String category;

  PerformanceBenchmark({
    required this.name,
    required this.duration,
    required this.score,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'duration_ms': duration.inMilliseconds,
    'score': score,
    'category': category,
  };
}

/// Performance monitoring configuration
class PerformanceConfig {
  static const bool enableDebugLogging = true;
  static const int maxDataPoints = 1000;
  static const Duration monitoringInterval = Duration(seconds: 5);
  static const bool enableFPSMonitoring = true;
  static const bool enableMemoryMonitoring = true;
  static const bool enableApiPerformanceTracking = true;
}

/// FPS Monitoring utility class
class FPSMonitor {
  int _frameCount = 0;
  int _lastCheckTime = DateTime.now().millisecondsSinceEpoch;
  final int _monitorInterval = 1000; // ms
  late Duration frameTimeAllowance = const Duration(milliseconds: 1000 ~/ 60);

  Function(String)? onFPSUpdate;

  void startMonitoring() {
    _frameCount = 0;
    _lastCheckTime = DateTime.now().millisecondsSinceEpoch;
  }

  void recordFrame() {
    _frameCount++;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - _lastCheckTime >= _monitorInterval) {
      final fps = (_frameCount * 1000) / (currentTime - _lastCheckTime);
      onFPSUpdate?.call('FPS: ${fps.toStringAsFixed(1)}');

      // Record FPS metric
      PerformanceMonitor().recordMetric('fps', fps, 'frames_per_second');

      _frameCount = 0;
      _lastCheckTime = currentTime;
    }
  }

  void stopMonitoring() {
    _frameCount = 0;
  }
}
