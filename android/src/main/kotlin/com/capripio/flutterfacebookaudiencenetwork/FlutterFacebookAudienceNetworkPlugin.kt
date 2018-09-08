package com.capripio.flutterfacebookaudiencenetwork

import android.util.Log
import com.facebook.ads.Ad
import com.facebook.ads.AdError
import com.facebook.ads.InterstitialAd
import com.facebook.ads.InterstitialAdListener
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar




class FlutterFacebookAudienceNetworkPlugin(registrar: Registrar, channel: MethodChannel) : MethodCallHandler {
    private val channel = channel
    private val registrar = registrar

    private var interstitialAd: InterstitialAd? = null

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "flutter_facebook_audience_network")
            channel.setMethodCallHandler(FlutterFacebookAudienceNetworkPlugin(registrar, channel))
        }
    }


    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        if (call.method.equals("initInterstitial")) {
            this.callInitInterstitial(call.argument("placement_id") as String)
        } else if (call.method.equals("initInterstitial")) {

        } else {
            result.notImplemented()
        }
    }

    private fun callInitInterstitial(placementID: String) {
        this.interstitialAd = InterstitialAd(registrar.context(), placementID)
        Log.println(Log.ERROR,"capripio","Call Init")
        this.interstitialAd?.setAdListener(object : InterstitialAdListener{
            override fun onInterstitialDisplayed(p0: Ad?) {
                channel.invokeMethod("onInterstitialDisplayed", p0)
                Log.println(Log.ERROR,"capripio","Call onInterstitialDisplayed")
            }

            override fun onAdClicked(p0: Ad?) {
                channel.invokeMethod("onAdClicked", argumentsMap())
                Log.println(Log.ERROR,"capripio","Call onAdClicked")
            }

            override fun onInterstitialDismissed(p0: Ad?) {
                channel.invokeMethod("onInterstitialDismissed", argumentsMap())
                Log.println(Log.ERROR,"capripio","Call onInterstitialDismissed")
            }

            override fun onError(p0: Ad?, p1: AdError?) {
                channel.invokeMethod("onError", argumentsMap())
                Log.println(Log.ERROR,"capripio","Call onError")
            }

            override fun onAdLoaded(p0: Ad?) {
                channel.invokeMethod("onAdLoaded", argumentsMap())
                Log.println(Log.ERROR,"capripio","Call onAdLoaded")
            }

            override fun onLoggingImpression(p0: Ad?) {
                channel.invokeMethod("onLoggingImpression", argumentsMap())
                Log.println(Log.ERROR,"capripio","Call onLoggingImpression")
            }

        })
        this.interstitialAd?.loadAd()
    }

    private fun argumentsMap(vararg args: Any): Map<String, Any> {
        val arguments = HashMap<String, Any>()
        var i = 0
        while (i < args.size) {
            arguments[args[i].toString()] = args[i + 1]
            i += 2
        }
        return arguments
    }


}


