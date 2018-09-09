package com.capripio.flutterfacebookaudiencenetwork

import android.util.Log
import com.facebook.ads.*

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar


class FlutterFacebookAudienceNetworkPlugin(private val registrar: Registrar, private val channel: MethodChannel) : MethodCallHandler {

    private var interstitialAd: InterstitialAd? = null

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_facebook_audience_network")
            channel.setMethodCallHandler(FlutterFacebookAudienceNetworkPlugin(registrar, channel))
        }
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "initInterstitial" -> this.callInitInterstitial(call.argument("placement_id") as String, result)
            call.method == "interstitialLoad" -> this.callInterstitialLoad(result)
            call.method == "interstitialShow" -> this.callInterstitialShow(result)
            call.method == "addTestDevice" -> this.callAddTestDevice(call.argument("device_hash") as String,result)
            else -> result.notImplemented()
        }
    }

    private fun callAddTestDevice(device_hash: String, result: Result) {
        AdSettings.addTestDevice(device_hash)
        result.success(true)
    }

    private fun callInterstitialShow(result: Result) {
        if (this.interstitialAd == null) {
            result.error("null_interstitial_ad", "Interstitial Ad Not Initialized", null)
            return
        }
        this.interstitialAd?.show()
    }

    private fun callInterstitialLoad(result: Result) {
        if (this.interstitialAd == null) {
            result.error("null_interstitial_ad", "Interstitial Ad Not Initialized", null)
            return
        }
        this.interstitialAd?.loadAd()
    }

    private fun callInitInterstitial(placementID: String, result: Result) {

        if (placementID == "") {
            result.error("no_placement_id", "a null or empty Placement id provided", null)
            return
        }
        this.interstitialAd = InterstitialAd(registrar.context(), placementID)
        this.interstitialAd?.setAdListener(object : InterstitialAdListener {
            override fun onInterstitialDisplayed(p0: Ad?) {
                channel.invokeMethod("onInterstitialDisplayed", argumentsMap())
            }

            override fun onAdClicked(p0: Ad?) {
                channel.invokeMethod("onInterstitialAdClicked", argumentsMap())
            }

            override fun onInterstitialDismissed(p0: Ad?) {
                channel.invokeMethod("onInterstitialDismissed", argumentsMap())
            }

            override fun onError(p0: Ad?, p1: AdError?) {
                channel.invokeMethod("onInterstitialError",
                            argumentsMap("error_code", p1?.errorCode!!, "error_message", p1?.errorMessage!!))
            }

            override fun onAdLoaded(p0: Ad?) {
                channel.invokeMethod("onInterstitialAdLoaded", argumentsMap())
            }

            override fun onLoggingImpression(p0: Ad?) {
                channel.invokeMethod("onInterstitialLoggingImpression", argumentsMap())
            }

        })
    }

    private fun argumentsMap(vararg args: Any): Map<String, Any?> {
        val arguments = HashMap<String, Any>()
        var i = 0
        while (i < args.size) {
            arguments[args[i].toString()] = args[i + 1]
            i += 2
        }
        return arguments
    }


}


