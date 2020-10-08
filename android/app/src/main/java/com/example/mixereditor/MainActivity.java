package com.example.mixereditor;

import androidx.annotation.NonNull;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.InputStreamReader;
import java.text.MessageFormat;

import android.content.Context;
import android.os.Message;
import android.os.PowerManager;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "mixerChannel";
    private static final Runtime runtime = Runtime.getRuntime();
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("getRoot")) {
                        String response;
                        try {
                            response = _getRoot();
                        } catch (Exception ex) {
                            response = "Denied";
                        }
                        result.success(response);
                    }
                    if (call.method.equals("mountFs")) {
                        String mountPartition = call.argument("mountPartition");
                        String response = _mountFs(mountPartition);
                        result.success(response);
                    }
                    if (call.method.equals("executeCommand")) {
                        String command = call.argument("command");
                        String response = _executeCommand(command);
                        result.success(response);
                    }
                    if (call.method.equals("unmountFs")) {
                        String mountPartition = call.argument("mountPartition");
                        String response = _unmountFs(mountPartition);
                        result.success(response);
                    }
                });
    }

    private String _getRoot() throws Exception {
        Process p = runtime.exec("su");
        DataOutputStream stdout = new DataOutputStream(p.getOutputStream());

        stdout.writeBytes("su");
        stdout.writeByte('\n');
        stdout.flush();
        stdout.close();

        BufferedReader stdin = new BufferedReader(new InputStreamReader(p.getInputStream()));
        char[] buffer = new char[1024];
        int read;
        StringBuilder out = new StringBuilder();

        while((read = stdin.read(buffer)) > 0) {
            out.append(buffer, 0, read);
        }
        stdin.close();
        p.waitFor();
        return out.toString();
    }

    private String _mountFs(String mountPartition) {
        try {
            String mountCommand = MessageFormat.format(
                    "su -c mount -o rw,remount {0}", mountPartition
            );
            Process process = runtime.exec(mountCommand);
            BufferedReader stdError = new BufferedReader(
                    new InputStreamReader(process.getErrorStream())
            );
            String result;
            process.waitFor();
            if ((result = stdError.readLine()) != null) {
                return result;
            } else {
                return "OK";
            }
        } catch (Exception ex) {
            return "Error Mounting Partition";
        }
    }

    private String _executeCommand(String command) {
        try {
            Process process = runtime.exec(command);
            BufferedReader stdError = new BufferedReader(
                    new InputStreamReader(process.getErrorStream())
            );
            String result;
            process.waitFor();
            if ((result = stdError.readLine()) != null) {
                return result;
            } else {
                return "OK";
            }
        } catch (Exception ex) {
            return "Error";
        }
    }

    private String _unmountFs(String mountPartition) {
        try {
            String commandString = MessageFormat.format(
                    "su -c mount -o ro,remount {0}", mountPartition
            );
            Process process = runtime.exec(commandString);
            BufferedReader stdError = new BufferedReader(
                    new InputStreamReader(process.getErrorStream())
            );
            String result;
            process.waitFor();
            if ((result = stdError.readLine()) != null) {
                return result;
            } else {
                return "OK";
            }
        } catch (Exception ex) {
            return "Error Unmounting Partition";
        }
    }
}
