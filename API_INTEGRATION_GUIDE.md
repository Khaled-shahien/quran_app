# API Integration Guide

## Project Structure

The API integration follows Clean Architecture principles with the following structure:

```
lib/
├── core/
│   ├── api/
│   │   ├── api_constants.dart          # API configuration and constants
│   │   ├── base_api_service.dart       # Base HTTP client with error handling
│   │   ├── api_error_handler.dart      # Centralized error handling
│   │   ├── api_logger.dart            # API logging utilities
│   │   └── models/
│   │       ├── base_response.dart     # Generic response model
│   │       └── api_error.dart         # Error response model
│   ├── errors/
│   │   ├── api_exception.dart         # API exception classes
│   │   └── network_exception.dart     # Network exception classes
│   ├── services/
│   │   └── network_manager.dart       # Network connectivity management
│   └── testing/
│       ├── mock_http_client.dart      # Mock HTTP client for testing
│       └── api_test_utils.dart        # Test utilities and sample data
│
└── features/
    └── [feature_name]/
        └── data/
            ├── data_sources/
            │   └── [feature]_api_service.dart  # Feature-specific API service
            ├── models/
            │   └── [feature]_models.dart       # Feature-specific models
            └── repositories/
                └── [feature]_repository.dart   # Repository implementation
```

## Key Components

### 1. Base API Service (`base_api_service.dart`)
- Handles HTTP requests (GET, POST, PUT, DELETE)
- Automatic network connectivity checking
- Request/response logging
- Error handling and exception mapping
- Timeout management

### 2. API Constants (`api_constants.dart`)
- Base URLs for different services
- Default headers and timeouts
- Common response codes
- API keys configuration

### 3. Error Handling
- `ApiException`: For API-related errors
- `NetworkException`: For network connectivity issues
- `ApiErrorHandler`: Centralized error message formatting

### 4. Models
- `BaseResponse<T>`: Generic response wrapper
- `ApiError`: Structured error response model
- Feature-specific models for data serialization

### 5. Testing Infrastructure
- `MockHttpClient`: Mock HTTP client for testing
- `ApiTestUtils`: Helper methods and sample data

## Usage Pattern

### 1. Create Feature API Service

```dart
class PrayerTimesApiService extends BaseApiService {
  Future<BaseResponse<PrayerTimesModel>> getPrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) async {
    try {
      final response = await get(
        '/timings/${date.millisecondsSinceEpoch ~/ 1000}',
        queryParams: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );
      
      return BaseResponse.fromJson(
        response,
        (json) => PrayerTimesModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }
}
```

### 2. Create Repository

```dart
class PrayerTimesRepository {
  final PrayerTimesApiService _apiService;
  
  PrayerTimesRepository({required PrayerTimesApiService apiService})
      : _apiService = apiService;
  
  Future<PrayerTimesModel> getPrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) async {
    try {
      final response = await _apiService.getPrayerTimes(
        latitude: latitude,
        longitude: longitude,
        date: date,
      );
      
      if (response.status && response.data != null) {
        return response.data!;
      } else {
        throw ApiException(
          message: response.message ?? 'Failed to fetch prayer times',
          code: response.code ?? 500,
        );
      }
    } on NetworkException {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Unexpected error occurred',
        code: 0,
      );
    }
  }
}
```

### 3. Use in Domain Layer

```dart
class GetPrayerTimesUseCase {
  final PrayerTimesRepository _repository;
  
  GetPrayerTimesUseCase({required PrayerTimesRepository repository})
      : _repository = repository;
  
  Future<PrayerTimesEntity> call({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) async {
    final model = await _repository.getPrayerTimes(
      latitude: latitude,
      longitude: longitude,
      date: date,
    );
    return model.toEntity();
  }
}
```

## Error Handling

The system provides comprehensive error handling:

```dart
try {
  final result = await repository.getData();
  // Handle success
} on NetworkException catch (e) {
  // Handle network issues
  final userMessage = ApiErrorHandler().handleError(e);
  // Show user-friendly message
} on ApiException catch (e) {
  // Handle API errors
  final userMessage = ApiErrorHandler().handleError(e);
  // Show appropriate error message
} catch (e) {
  // Handle unexpected errors
  final userMessage = 'An unexpected error occurred';
}
```

## Testing

### Unit Testing with Mocks

```dart
void main() {
  late MockHttpClient mockClient;
  late PrayerTimesApiService apiService;
  
  setUp(() {
    mockClient = MockHttpClient();
    apiService = PrayerTimesApiService(httpClient: mockClient);
  });
  
  test('should fetch prayer times successfully', () async {
    // Arrange
    mockClient.addJsonResponse(
      '/timings/1705708800',
      'GET',
      ApiTestUtils.samplePrayerTimesResponse,
    );
    
    // Act
    final result = await apiService.getPrayerTimes(
      latitude: 24.7136,
      longitude: 46.6753,
      date: DateTime(2024, 1, 20),
    );
    
    // Assert
    expect(result.status, true);
    expect(result.data, isNotNull);
  });
}
```

## Best Practices

1. **Always use the base API service** for consistency
2. **Handle all exceptions** appropriately in repositories
3. **Use proper error messages** for user feedback
4. **Log API calls** for debugging
5. **Test all API endpoints** with mock data
6. **Follow the repository pattern** for data access
7. **Use models for data serialization** instead of raw JSON
8. **Implement proper timeout handling**
9. **Check network connectivity** before making requests
10. **Use environment variables** for API keys in production

## Next Steps

When you provide the actual API endpoints, I'll:

1. Create specific models for each endpoint
2. Implement the corresponding API services
3. Set up repositories with proper error handling
4. Add comprehensive unit tests
5. Document each endpoint usage
6. Set up integration tests if needed

Please share the first API endpoint details and I'll implement it following this established pattern.