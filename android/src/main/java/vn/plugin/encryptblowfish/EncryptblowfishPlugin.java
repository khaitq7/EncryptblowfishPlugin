package vn.plugin.encryptblowfish;

import android.util.Base64;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import android.util.Log;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

/** EncryptblowfishPlugin */
public class EncryptblowfishPlugin implements FlutterPlugin, MethodCallHandler {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "encryptblowfish");
    channel.setMethodCallHandler(new EncryptblowfishPlugin());
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "encryptblowfish");
    channel.setMethodCallHandler(new EncryptblowfishPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method){
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "getStringAfterEncrypt":
        String keyencrypt = call.argument("key");
        String originStr = call.argument("origin");

        String encrypt = getEncryptFromOrigin(keyencrypt , originStr);
        result.success(encrypt);
        break;
      case "getStringAfterDecrypt":
        String keydecrypt = call.argument("key");
        String decryptStr = call.argument("decrypt");

        String afterDecrypt = getDecryptFromString(keydecrypt , decryptStr);
        result.success(afterDecrypt);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private String getDecryptFromString(String key, String decryptStr) {
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.FROYO) {
      byte[] decodeFromBase64 = Base64.decode(decryptStr, Base64.DEFAULT);
      try {
        byte[] keyBytes = key.getBytes();
        SecretKeySpec skeySpec = new SecretKeySpec(keyBytes, "Blowfish");
        Cipher cipher = Cipher.getInstance("Blowfish/ECB/NoPadding");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec);
        byte[] decrypted = cipher.doFinal(decodeFromBase64);
        String decrytionToString = new String(decrypted, "UTF-8");
        Log.d("TAG" , "result decode : " + decrytionToString);
        return decrytionToString;
      } catch (Exception e) {
        e.printStackTrace();
      }
      return "Error";
    }

    return "Error";
  }

  private String getEncryptFromOrigin(String key, String originStr) {
    try {
      if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.FROYO) {
        byte[] KeyData = key.getBytes();
        SecretKeySpec KS = new SecretKeySpec(KeyData, "Blowfish");
        Cipher cipher = Cipher.getInstance("Blowfish/ECB/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, KS);
        byte encrypt[] = originStr.getBytes();
        if(encrypt.length % 8 != 0){ //not a multiple of 8
          //create a new array with a size which is a multiple of 8
          byte[] padded = new byte[encrypt.length + 8 - (encrypt.length % 8)];

          //copy the old array into it
          System.arraycopy(encrypt, 0, padded, 0, encrypt.length);
          encrypt = padded;
        }
        byte[] encrypted = cipher.doFinal(encrypt);
        String result = Base64.encodeToString(encrypted , Base64.DEFAULT);
        Log.d("TAG" , "result encode : " + result);
        return result;
      }
    }catch (Exception e){
      e.printStackTrace();
    }
    return "Error";
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
