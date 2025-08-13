# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

#-------------- AdSet start-------------
-keep class com.kc.openset.**{*;}
-keep class com.od.**{*;}
-dontwarn com.kc.openset.**
-keep class com.jiagu.sdk.** { *; }

-keep @com.qihoo.SdkProtected.OSETSDK.Keep class **{*;}
-keep,allowobfuscation interface com.qihoo.SdkProtected.OSETSDK.Keep
#-------------- AdSet end-------------


#-------------- gromoe start-------------
-keep class com.bytedance.sdk.openadsdk.** { *; }
-keep public interface com.bytedance.sdk.openadsdk.downloadnew.** {*;}
-keep class com.ss.**{*;}
-dontwarn com.ss.**

-keep class bykvm*.**
-keep class com.bytedance.msdk.adapter.**{ public *; }
-keep class com.bytedance.msdk.api.** {
 public *;
}
-keep class com.bytedance.msdk.base.TTBaseAd{*;}
-keep class com.bytedance.msdk.adapter.TTAbsAdLoaderAdapter{
    public *;
    protected <fields>;
}
#-keep class com.bykv.**{*;}
#-keep class com.byted.live.lite.**{*;}
#-keep class com.bytedance.**{*;}
#-keep class com.pandora.common.**{*;}
#-keep class com.ss.**{*;}
#-------------- gromoe end -------------


#-------------- 快手 start-------------
-keep class org.chromium.** {*;}
-keep class org.chromium.** { *; }
-keep class aegon.chrome.** { *; }
-keep class com.kwai.**{ *; }

-dontwarn com.kwai.**
-dontwarn com.kwad.**
-dontwarn com.ksad.**
-dontwarn aegon.chrome.**
#-------------- 快手 end-------------


#-------------- sigmob start-------------
-dontoptimize

# WindAd
-keep class sun.misc.Unsafe { *; }
-keep class com.sigmob.sdk.**{ *;}
-keep interface com.sigmob.sdk.**{ *;}
-keep class com.sigmob.windad.**{ *;}
-keep interface com.sigmob.windad.**{ *;}
-keep class com.czhj.**{ *;}
-keep interface com.czhj.**{ *;}
-keep class com.tan.mark.**{*;}

# miitmdid
-dontwarn com.bun.**
-keep class com.bun.** {*;}
-keep class a.**{*;}
-keep class XI.CA.XI.**{*;}
-keep class XI.K0.XI.**{*;}
-keep class XI.XI.K0.**{*;}
-keep class XI.vs.K0.**{*;}
-keep class XI.xo.XI.XI.**{*;}
-keep class com.asus.msa.SupplementaryDID.**{*;}
-keep class com.asus.msa.sdid.**{*;}
-keep class com.huawei.hms.ads.identifier.**{*;}
-keep class com.samsung.android.deviceidservice.**{*;}
-keep class com.zui.opendeviceidlibrary.**{*;}
-keep class org.json.**{*;}
-keep public class com.netease.nis.sdkwrapper.Utils {public <methods>;}

# androidx
-keep class com.google.android.material.** {*;}
-keep class androidx.** {*;}
-keep public class * extends androidx.**
-keep interface androidx.** {*;}
-dontwarn com.google.android.material.**
-dontnote com.google.android.material.**
-dontwarn androidx.**

# android.support.v4
-dontwarn android.support.v4.**
-keep class android.support.v4.** { *; }
-keep interface android.support.v4.** { *; }
-keep public class * extends android.support.v4.**
#-------------- sigmob end-------------


#-------------- oaid start-------------
# 注意不同版本混淆不一样，如果你接入的是sdk默认的1.0.25版本就用下面的，其他版本自行检查
-keep class com.bun.supplier.** {*;}
-dontwarn com.bun.supplier.core.**
-keep class XI.**{*;}
-keep class com.bun.miitmdid.**{*;}

-keep class com.asus.msa.**{*;}
-keep class com.bun.**{*;}
-keep class com.huawei.hms.ads.identifier.**{*;}
-keep class com.netease.nis.sdkwrapper.**{*;}
-keep class com.samsung.android.deviceidservice.**{*;}
-keep class com.zui.**{*;}
-keep class XI.**{*;}
#-------------- oaid end-------------


#-------------- 广点通 start-------------
-keep class com.qq.e.** {*;}
-dontwarn com.qq.e.**
#-------------- 广点通 end-------------


#-------------- 百度 start-------------
-ignorewarnings
-dontwarn com.baidu.mobads.sdk.api.**
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keep class com.baidu.mobads.** { *; }
-keep class com.style.widget.** {*;}
-keep class com.component.** {*;}
-keep class com.baidu.ad.magic.flute.** {*;}
-keep class com.baidu.mobstat.forbes.** {*;}
#-------------- 百度 end-------------


#-------------- okhttp3 start-------------
# OkHttp3
# https://github.com/square/okhttp
# okhttp
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.squareup.okhttp.* { *; }
-keep interface com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**

# okhttp 3
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

-keepattributes InnerClasses

# Okio
-dontwarn com.squareup.**
-dontwarn okio.**
-keep public class org.codehaus.* { *; }
-keep public class java.nio.* { *; }
#----------okhttp end--------------


#----------log start--------------
-keep class com.aliyun.sls.android.producer.** { *; }
-keep interface com.aliyun.sls.android.producer.* { *; }
#----------log end--------------


#----------倍孜 start--------------
-dontwarn com.beizi.fusion.**
-dontwarn com.beizi.ad.**
-keep class com.beizi.fusion.** {*; }
-keep class com.beizi.ad.** {*; }

-keep class com.qq.e.** {
    public protected *;
}

-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod

-dontwarn  org.apache.**
#----------倍孜 end--------------


#----------Glide start--------------
-dontwarn com.bumptech.glide.**
-keep class com.bumptech.glide.**{*;}
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}
#----------Glide end--------------


#----------阿里TanxAd start--------------
-dontwarn com.alibaba.fastjson.**

-keep class com.alibaba.fastjson.**{*;}
-keep class com.bumptech.glide.**{*;}

-keep class com.alimm.tanx.**{*;}

# 有进程间通信,保证service相关不被混淆
#-keep public class * extends android.app.Service
#-keep public class * extends android.content.BroadcastReceiver

# 自动曝光数据的防混淆
-keep class * implements java.io.Serializable{
     <fields>;
    <methods>;
}
#----------阿里TanxAd end--------------


#----------章鱼 start--------------
# Octopus混淆
-dontwarn com.octopus.ad.**
-keep class com.octopus.ad.** {*;}
#----------章鱼 end--------------

#----------华为荣耀 start--------------
-keep class com.hihonor.ads.** {*; }
#----------华为荣耀 end--------------

#-------------- 京东 start-------------
-keep class com.jd.ad.sdk.** { *; }
#-------------- 京东 end-------------

