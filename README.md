# Exploring DevTools

A Flutter application designed to demonstrate various performance bottlenecks and how to identify them using Flutter DevTools.

## Demo



## Levels Breakdown

### Level 0 - No Rendering
Baseline with minimal impact. This page renders an empty container to serve as a control for performance comparisons.

### Level 1 - Baseline
Standard `ListView` with cached images. Represents a well-optimized Flutter page with good performance.

### Level 2 - Excessive Rebuilds
Demonstrates high CPU usage due to frequent `setState` calls (every 16ms). Useful for identifying unnecessary rebuilds in the Performance view.

### Level 3 - GPU Stress
Demonstrates high GPU usage with complex rendering (gradients, shadows, blurs) and continuous animations. Useful for analyzing raster thread performance.

### Level 4 - Network Polling
Demonstrates network and CPU impact of frequent HTTP requests (polling every 2 seconds). Useful for analyzing network traffic and its correlation with CPU usage.

### Level 5 - The Worst Scenario
Combines all issues to create extreme jank and resource usage:
- **Heavy Rebuilds**: Complex widget tree rebuilt every frame.
- **Blocking Main Thread**: Simulated heavy calculation blocking the UI thread.
- **Network Polling**: Frequent uncached requests.
- **Sensors**: Continuous accelerometer updates.
- **Large Images**: High-resolution image decoding without caching.

## Getting Started

1. Run the app: `flutter run`
2. Open DevTools: Click the "Open DevTools" button in your IDE or run `dart devtools`.
3. Navigate through the levels and observe the performance metrics in DevTools (Performance, Network, Memory, CPU Profiler).
