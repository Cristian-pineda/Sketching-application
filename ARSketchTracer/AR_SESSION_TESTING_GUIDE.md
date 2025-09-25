# AR Session Testing Guide

## Overview

This document provides comprehensive testing guidelines for the AR session reuse fixes implemented in ARSketchTracer. The fixes address session lifecycle management, error recovery, and resource cleanup issues that previously caused crashes when transitioning between camera views.

## Implementation Summary

### Enhanced Components

1. **ARSessionManager.swift** - Core session lifecycle management
2. **ARSessionRecovery.swift** - Error recovery and monitoring system

### Key Features Fixed

- Session state validation before operations
- Proper resource cleanup on session transitions
- Automatic error recovery with retry logic
- Session health monitoring
- Comprehensive error handling and logging

## Testing Scenarios

### 1. Basic Session Lifecycle Testing

#### Test Case 1.1: Initial Session Start
**Steps:**
1. Launch the app
2. Navigate to camera view
3. Grant camera and AR permissions
4. Observe AR session initialization

**Expected Results:**
- AR session starts successfully
- No crashes or error messages
- AR tracking begins within 2-3 seconds
- Console shows successful session initialization logs

#### Test Case 1.2: Session Restart
**Steps:**
1. Start AR session (from Test Case 1.1)
2. Navigate away from camera view
3. Return to camera view
4. Observe session restart

**Expected Results:**
- Previous session is properly cleaned up
- New session starts successfully
- No resource conflicts or memory leaks
- Session state transitions cleanly

### 2. Error Recovery Testing

#### Test Case 2.1: Camera Permission Revoked
**Steps:**
1. Start AR session successfully
2. Go to iOS Settings > ARSketchTracer > Camera
3. Disable camera permission
4. Return to app
5. Attempt to use AR features

**Expected Results:**
- App detects permission loss
- Shows appropriate error message
- Offers to open settings
- Gracefully handles lack of camera access

#### Test Case 2.2: AR Session Interrupted
**Steps:**
1. Start AR session successfully
2. Receive a phone call or use Control Center
3. Return to app after interruption
4. Observe session recovery

**Expected Results:**
- Session pauses during interruption
- Automatic recovery attempt when returning
- If recovery fails, shows retry option
- No crashes or undefined states

#### Test Case 2.3: Multiple Rapid Transitions
**Steps:**
1. Navigate to camera view
2. Quickly navigate away and back 5-10 times
3. Observe session behavior
4. Monitor for memory issues

**Expected Results:**
- Each transition handled gracefully
- No session conflicts
- Memory usage remains stable
- No crashes or freezes

### 3. Resource Management Testing

#### Test Case 3.1: Memory Usage
**Steps:**
1. Use Xcode's Memory Debugger
2. Start AR session
3. Navigate away and back multiple times
4. Monitor memory allocations

**Expected Results:**
- Memory usage increases initially with AR session
- Memory is properly released when leaving camera
- No significant memory leaks
- Memory usage stabilizes after multiple transitions

#### Test Case 3.2: Session Cleanup Verification
**Steps:**
1. Start AR session
2. Add breakpoint in `cleanupCurrentSession()` method
3. Navigate away from camera view
4. Verify cleanup method execution

**Expected Results:**
- Cleanup method is called
- Session delegate is properly removed
- AR session is paused and reset
- Resources are released

### 4. Edge Case Testing

#### Test Case 4.1: Device Orientation Changes
**Steps:**
1. Start AR session in portrait
2. Rotate device to landscape
3. Rotate back to portrait
4. Observe session stability

**Expected Results:**
- Session adapts to orientation changes
- No crashes or visual artifacts
- AR tracking continues smoothly
- UI elements remain properly positioned

#### Test Case 4.2: Low Memory Conditions
**Steps:**
1. Use Xcode's Memory Debugger to simulate low memory
2. Start AR session
3. Trigger memory warning
4. Observe app behavior

**Expected Results:**
- App receives memory warning
- Non-critical resources are released
- AR session continues if possible
- Graceful degradation if necessary

#### Test Case 4.3: Background/Foreground Transitions
**Steps:**
1. Start AR session
2. Press home button (background app)
3. Wait 10 seconds
4. Return to app
5. Observe session recovery

**Expected Results:**
- Session pauses when backgrounded
- Automatic recovery when returning to foreground
- If recovery fails, clear error message and retry option
- No data loss or crashes

## Automated Testing Integration

### Unit Tests for ARSessionManager

```swift
// Example test structure (for reference)
class ARSessionManagerTests: XCTestCase {
    func testSessionStateValidation() {
        // Test validateSessionState() method
    }
    
    func testSessionCleanup() {
        // Test cleanupCurrentSession() method
    }
    
    func testErrorHandling() {
        // Test error handling scenarios
    }
}
```

### Unit Tests for ARSessionRecovery

```swift
// Example test structure (for reference)
class ARSessionRecoveryTests: XCTestCase {
    func testRecoveryRetryLogic() {
        // Test retry mechanism with exponential backoff
    }
    
    func testSessionMonitoring() {
        // Test health monitoring functionality
    }
    
    func testErrorCategorization() {
        // Test proper error classification
    }
}
```

## Performance Benchmarks

### Session Start Time
- **Target:** AR session should start within 3 seconds
- **Measurement:** Time from session.run() call to first tracking state

### Memory Usage
- **Target:** Memory usage should not exceed 200MB increase with AR session
- **Measurement:** Monitor memory before/after session start

### Recovery Time
- **Target:** Error recovery should complete within 5 seconds
- **Measurement:** Time from error detection to successful recovery

## Testing Tools and Setup

### Required Tools
1. **Xcode** - Latest version with iOS simulator
2. **Physical iOS Device** - Required for AR testing
3. **Memory Debugger** - For memory leak detection
4. **Console App** - For log monitoring

### Test Device Requirements
- iOS 13.0 or later
- A12 Bionic chip or newer (for AR support)
- At least 3GB RAM recommended

### Debug Logging
Enable debug logging by adding to Debug configuration:
```
-ARSessionManager.enableDebugLogging true
-ARSessionRecovery.enableVerboseLogging true
```

## Common Issues and Troubleshooting

### Issue: Session fails to start
**Symptoms:** Black screen, no AR tracking
**Check:** Camera permissions, AR availability, device compatibility

### Issue: Memory warnings during testing
**Symptoms:** App becomes unresponsive, crashes
**Check:** Proper cleanup implementation, resource deallocation

### Issue: Session recovery fails
**Symptoms:** Persistent error state, no automatic recovery
**Check:** Recovery manager initialization, retry logic

## Test Reporting

### Required Information
1. Device model and iOS version
2. Test scenario and steps performed
3. Expected vs actual results
4. Screenshots or screen recordings
5. Console logs (if errors occur)
6. Memory usage data (if applicable)

### Success Criteria
- All basic lifecycle tests pass
- Error recovery works in at least 90% of scenarios
- No memory leaks detected
- Performance benchmarks met
- No crashes during 30-minute continuous testing

## Regression Testing

After any future AR-related changes:
1. Run all test scenarios above
2. Verify no new crashes introduced
3. Confirm performance benchmarks still met
4. Test on multiple device models
5. Validate with both iOS simulator and physical devices

---

**Last Updated:** September 25, 2025  
**Version:** 1.0  
**Tested iOS Versions:** 13.0+  
**Tested Devices:** iPhone 12, iPhone 13, iPhone 14, iPhone 15
