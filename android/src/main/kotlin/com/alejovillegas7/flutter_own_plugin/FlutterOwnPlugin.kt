package com.alejovillegas7.flutter_own_plugin

import android.Manifest
import android.app.Activity
import android.content.Context
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterOwnPlugin */
class FlutterOwnPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var eventChannelForLocation: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var context: Context
    private var activity: Activity? = null

    private var locationListener: EventChannel.StreamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }

    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_own_plugin")
        channel.setMethodCallHandler(this)
        eventChannelForLocation = EventChannel(flutterPluginBinding.binaryMessenger, "locationStatusStream")
        eventChannelForLocation?.setStreamHandler(locationListener)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "startListeningLocation" -> startListeningLocation(result)
            "requestPermission" -> requestPermission()
            else -> result.notImplemented()
        }
    }

    private fun requestPermission() {
        context?.run {
            ActivityCompat.requestPermissions(activity!!, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION),
                    500)
        }
    }

    private fun startListeningLocation(result: Result) {
        var listener = object : LocationListener {
            override fun onLocationChanged(location: Location?) {
                eventSink?.success("the current location is: LATITUDE: ${location?.latitude} and LONGITUDE: ${location?.longitude}")
                //result.success("the current location is: LATITUDE: ${location?.latitude} and LONGITUDE: ${location?.longitude}")
            }

            override fun onStatusChanged(p0: String?, p1: Int, p2: Bundle?) {
                TODO("Not yet implemented")
            }

            override fun onProviderEnabled(p0: String?) {
                TODO("Not yet implemented")
            }

            override fun onProviderDisabled(p0: String?) {
                TODO("Not yet implemented")
            }

        }
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
                2000,
                10f, listener)

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
