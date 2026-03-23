package com.example.quran_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * Boot Receiver - Handles device boot and app updates
 * 
 * This receiver listens for:
 * - BOOT_COMPLETED: Device has finished booting
 * - QUICKBOOT_POWERON: Fast boot (some devices)
 * - MY_PACKAGE_REPLACED: App was updated
 * 
 * When triggered, it initializes WorkManager to reschedule all alarms
 */
class BootReceiver : BroadcastReceiver() {
    
    companion object {
        private const val TAG = "BootReceiver"
    }
    
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(TAG, "Received broadcast action: $action")
        
        when (action) {
            Intent.ACTION_BOOT_COMPLETED -> {
                Log.i(TAG, "Device boot completed - rescheduling alarms")
                handleBootCompleted(context)
            }
            "android.intent.action.QUICKBOOT_POWERON" -> {
                Log.i(TAG, "Quick boot detected - rescheduling alarms")
                handleBootCompleted(context)
            }
            Intent.ACTION_MY_PACKAGE_REPLACED -> {
                Log.i(TAG, "Package replaced - rescheduling alarms")
                handleBootCompleted(context)
            }
        }
    }
    
    /**
     * Handle boot completed event
     * This schedules a WorkManager task to reschedule all alarms
     */
    private fun handleBootCompleted(context: Context) {
        try {
            // Note: The actual alarm rescheduling is handled by WorkManager
            // in the Flutter layer. This receiver just ensures the app
            // can respond to boot events.
            
            // You could add additional Android-native initialization here if needed
            Log.d(TAG, "Boot handling complete")
            
        } catch (e: Exception) {
            Log.e(TAG, "Error handling boot: ${e.message}", e)
        }
    }
}
