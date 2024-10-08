﻿using Microsoft.UI.Xaml.Controls;
using System;
using System.Diagnostics;
using System.IO;

namespace Script_Runner {
    public class Execute {

        /* PowerShell */
        public void ExecutePowershellScript(string path, MainWindow main) {
            main.function_tracker = "ExecutePowershellScript";

            // Error handling
            if (String.IsNullOrEmpty(path)) {
                main.errormessage = "Path to script is empty.";
                return;
            }
            else if (main.scriptrunning) {
                main.errormessage = "A script is already running.";
                return;
            }
            else if (!String.IsNullOrEmpty(main.errormessage)) {
                return;
            }

            main.scriptrunning = true;

            // Make sure the script exists
            if (!File.Exists(path)) {
                main.errormessage = "File does not exist in path: " + path;
                main.scriptrunning = false;
                return;
            }

            // Build the process information
            ProcessStartInfo startInfo = new ProcessStartInfo();
            Debug.WriteLine("Starting the process information...");
            Debug.WriteLine("Process path set to: " + path);
            startInfo.FileName = "powershell.exe";
            startInfo.Arguments = $"-ExecutionPolicy Unrestricted -File \"{path}\"";
            startInfo.RedirectStandardOutput = false; // Move output to IOStream
            startInfo.RedirectStandardError = false; // Move errors to IOStream
            startInfo.UseShellExecute = false; // Run from the OS or powershell.exe
            startInfo.CreateNoWindow = true; // Silent
            startInfo.Verb = "runas"; // Run as admin

            Debug.WriteLine("Starting the process...");
            try {
                using (Process process = new Process()) {

                    // Execute
                    process.StartInfo = startInfo;
                    process.Start();
                    if (process == null) {
                        main.errormessage = "Process did not start.";
                        main.scriptrunning = false;
                        return;
                    }
                    Debug.WriteLine("Awaiting script completion...");
                    process.WaitForExit();

                    // Check return state
                    int exitcode = process.ExitCode;
                    if (exitcode != 0) {
                        main.errormessage = "Script failed with errorcode " + exitcode + ".";
                        main.scriptrunning = false;
                        return;
                    }
                    main.scriptrunning = false;
                    Debug.WriteLine("Script ran sucessfully");
                }
            }
            catch (System.ComponentModel.Win32Exception e) {
                main.errormessage = "Elevation is required " + e;
                main.scriptrunning = false;
            }
            finally {
                main.scriptrunning = false;
            }
        }
        public void ExecutePowershellCommand(string command, MainWindow main) {
            main.function_tracker = "ExecutePowershellCommand";

            // Error handling
            if (String.IsNullOrEmpty(command)) {
                main.errormessage = "The command is empty or null.";
                return;
            }
            else if (main.scriptrunning) {
                main.errormessage = "A script is already running.";
                return;
            }
            else if (!String.IsNullOrEmpty(main.errormessage)) {
                return;
            }

            main.scriptrunning = true;

            // Build the process
            var process = new Process();
            process.StartInfo.FileName = "powershell.exe";
            process.StartInfo.Arguments = $"{command}";
            process.StartInfo.Verb = "runas";
            process.StartInfo.RedirectStandardOutput = false;
            process.StartInfo.UseShellExecute = true;
            process.StartInfo.CreateNoWindow = true;

            // Execute
            try {
                process.Start();
                process.WaitForExit();

                main.scriptrunning = false;
            }
            catch (System.ComponentModel.Win32Exception e) {
                main.errormessage = "Elevation is required " + e;
                main.scriptrunning = false;
            }
            catch (Exception e) {
                main.errormessage = "Process error: " + e;
                main.scriptrunning = false;
            }
        }
        public void ExecutePowershellState(string command, Button button, MainWindow main) {
            main.function_tracker = "ExecutePowershellState";

            // Error handling
            if (String.IsNullOrEmpty(command)) {
                main.errormessage = "The command is empty or null.";
                return;
            }
            else if (main.scriptrunning) {
                main.errormessage = "A script is already running.";
                return;
            }
            else if (!String.IsNullOrEmpty(main.errormessage)) {
                return;
            }

            main.scriptrunning = true;

            // Build the process
            var process = new Process();
            process.StartInfo.FileName = "powershell.exe";
            process.StartInfo.Arguments = $"{command}";
            process.StartInfo.Verb = "runas";
            process.StartInfo.RedirectStandardOutput = true;
            process.StartInfo.UseShellExecute = false;
            process.StartInfo.CreateNoWindow = true;

            // Execute
            try {
                process.Start();
                string output = process.StandardOutput.ReadToEnd();
                process.WaitForExit();

                main.scriptrunning = false;

                // Only set to enabled if true, all other instances are false
                Debug.WriteLine("Powershell query returned: " + output.Trim());
                if (output.Trim().Equals("True", StringComparison.OrdinalIgnoreCase) || output.Trim().Equals("1", StringComparison.OrdinalIgnoreCase)) { // True or 1
                    Debug.WriteLine("Button " + button.Name + " has been set to enabled.");
                    button.Content = "Disable";
                    button.IsEnabled = true;
                }
                else {
                    Debug.WriteLine("Button " + button.Name + " has been set to disabled.");
                    button.Content = "Enable";
                    button.IsEnabled = true;
                }
            }
            catch (System.ComponentModel.Win32Exception e) {
                main.errormessage = "Elevation is required " + e;
                main.scriptrunning = false;
            }
            catch (Exception e) {
                main.errormessage = "Process error: " + e;
                main.scriptrunning = false;
            }
        }


        /* CMD */
        public void ExecuteCMDCommand(string command, MainWindow main) {
            main.function_tracker = "ExecuteCMDCommand";

            // Error handling
            if (String.IsNullOrEmpty(command)) {
                main.errormessage = "The command is empty or null.";
                return;
            }
            else if (main.scriptrunning) {
                main.errormessage = "A script is already running.";
                return;
            }
            else if (!String.IsNullOrEmpty(main.errormessage)) {
                return;
            }

            main.scriptrunning = true;

            var process = new Process();
            process.StartInfo.FileName = "cmd.exe";
            process.StartInfo.Arguments = $"/C {command}";
            process.StartInfo.Verb = "runas";
            process.StartInfo.RedirectStandardOutput = false;
            process.StartInfo.UseShellExecute = true;
            process.StartInfo.CreateNoWindow = true;
            try {
                process.Start();
                process.WaitForExit();

                main.scriptrunning = false;
                main.Activate();
            }
            catch (System.ComponentModel.Win32Exception e) {
                main.errormessage = "Elevation is required " + e;
                main.scriptrunning = false;
                main.Activate();
            }
            catch (Exception e) {
                main.errormessage = "Command ended with error: " + e;
                main.scriptrunning = false;
                main.Activate();
            }
        }
    }
}
