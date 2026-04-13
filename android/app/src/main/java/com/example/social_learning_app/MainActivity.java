package com.example.social_learning_app;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.widget.Toast;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.historyhub.app/native";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "showToast":
                                    String message = call.argument("message");
                                    Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
                                    result.success(null);
                                    break;
                                case "getNativeInfo":
                                    result.success("Android Java Engine Active - v1.0");
                                    break;
                                case "getHistoricalFacts":
                                    // Simulating fetching data from a local Java-based provider
                                    String facts = "TIP Facts & Recent Discoveries:\n" +
                                                  "- T.I.P. was founded on Feb 8, 1962, by Engr. Demetrio Quirino, Jr. and Dr. Teresita Quirino.\n" +
                                                  "- It started with only 80 students in Manila.\n" +
                                                  "- T.I.P. QC was later established to expand its mission of technical education.\n" +
                                                  "- It is one of the first schools in the PH to have ABET-accredited engineering programs.";
                                    result.success(facts);
                                    break;
                                default:
                                    result.notImplemented();
                                    break;
                            }
                        }
                );
    }
}
