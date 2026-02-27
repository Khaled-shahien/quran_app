## 2024-05-23 - Static Data Caching
**Learning:** Even with Repository pattern and persistence caching (SharedPreferences), direct usage of Service/DataSource classes in UI (bypassing Repository) can lead to performance issues (repeated network calls).
**Action:** When implementing caching, consider adding a layer of in-memory caching (static or singleton) in the Service/DataSource itself for static/immutable data, to protect against inefficient usage patterns in upper layers.
