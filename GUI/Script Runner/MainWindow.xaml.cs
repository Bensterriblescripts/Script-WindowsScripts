using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using System;
using System.Diagnostics;
using System.Security.Principal;
using System.IO;

namespace Script_Runner
{
    public sealed partial class MainWindow : Window
    {
        // Variables
        bool scriptrunning = false;
        string errormessage = string.Empty;
        string function_tracker = string.Empty;
        string buttoncontent = string.Empty;

        // Script paths
        string restart_monitorprocess = "C:\\Repositories\\Script-WindowsScripts\\Refresh Monitors.ps1";
        string fix_windowsupdate = "C:\\Repositories\\Script-WindowsScripts\\Fix Windows Update.ps1";

        public MainWindow() {

            Console.WriteLine("Launching...");
            this.InitializeComponent();
        }

        // Button On-Click
        public bool ButtonClickHandler (Button button) {

            function_tracker = "ButtonClickHandler";
            errormessage = string.Empty;

            // Just in case
            if (button == null) {
                errormessage = "Button is null.";
                return false;
            }

            // Change the button description
            if (button.Content != null) {
                buttoncontent = button.Content as string;
                button.Content = "Running...";
                button.IsEnabled = false;
                return true;
            }
            else {
                return false;
            }
        }
        // Button Finish
        public void ButtonFinishHandler (Button button, bool opt) {

            // Just in case..
            if (button.Content != null) {

                // Re-enable the button if set
                if (opt) {
                    button.Content = buttoncontent;
                    button.IsEnabled = true;
                }

                // Set it to greyed finish if not
                else {
                    button.Content = "Finished";
                }
            }
            return;
        }

        // Run a PowerShell Script
        private void ExecutePowershell(string path) {

            scriptrunning = true;

            function_tracker = "ExecutePowershell";

            // Make sure the script exists
            if (!File.Exists(path)) {
                errormessage = "File does not exist in path: " + path;
                scriptrunning = false;
                return;
            }

            // Start the process information
            ProcessStartInfo startInfo = new ProcessStartInfo();
            Debug.WriteLine("Starting the process information...");
            Debug.WriteLine("Process path set to: " + path);
            startInfo.FileName = "powershell.exe";
            startInfo.Arguments = $"-ExecutionPolicy Unrestricted -File \"{path}\"";
            startInfo.RedirectStandardOutput = false; // Move output to IOStream
            startInfo.RedirectStandardError = false; // Move errors to IOStream
            startInfo.UseShellExecute = false; // Run from the OS or powershell.exe
            startInfo.CreateNoWindow = false; // Silent
            startInfo.Verb = "runas"; // Run as admin

            // Execute
            Debug.WriteLine("Starting the process...");
            try {
                using (Process process = new Process()) {

                    // Start the process
                    process.StartInfo = startInfo;
                    process.Start();

                    // Check if the process is running
                    if (process == null) {
                        errormessage = "Process did not start.";
                        scriptrunning = false;
                        return;
                    }

                    // Wait for exit
                    Debug.WriteLine("Awaiting script completion...");
                    process.WaitForExit();

                    // Check return state
                    int exitcode = process.ExitCode;
                    if (exitcode != 0) {
                        errormessage = "Script failed with errorcode " + exitcode + ".";
                        scriptrunning = false;
                        return;
                    }

                    scriptrunning = false;
                    Debug.WriteLine("Script ran sucessfully");
                }
            }
            catch (Exception e) {
                errormessage = "Script failed with exception: " + e.Message;
                scriptrunning = false;
            }
            finally {
                scriptrunning = false;
            }
        }

        // Execute Powershell Commands
        private void ExecutePowershellCommand(string command) {

            scriptrunning = true;

            var process = new Process();
            process.StartInfo.FileName = "powershell.exe";
            process.StartInfo.Arguments = $"{command}";
            process.StartInfo.Verb = "runas";
            process.StartInfo.RedirectStandardOutput = false;
            process.StartInfo.UseShellExecute = true;
            process.StartInfo.CreateNoWindow = false;

            process.Start();
            process.WaitForExit();

            scriptrunning = false;
        }

        // Execute CMD Commands
        private void ExecuteCMDCommand (string command) {

            scriptrunning = true;

            var process = new Process();
            process.StartInfo.FileName = "cmd.exe";
            process.StartInfo.Arguments = $"/C {command}";
            process.StartInfo.Verb = "runas";
            process.StartInfo.RedirectStandardOutput = false;
            process.StartInfo.UseShellExecute = true;
            process.StartInfo.CreateNoWindow = false;
            try {
                process.Start();
                process.WaitForExit();
                scriptrunning = false;
            }
            catch (Exception e) {
                errormessage = "Command ended with error: " + e;
                scriptrunning = false;
            }
        }

        // Button Triggers
        private void FixRefreshMonitors(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            if (!scriptrunning && string.IsNullOrEmpty(errormessage)) { ButtonClickHandler(button); }
            if (!scriptrunning && string.IsNullOrEmpty(errormessage)) { ExecutePowershellCommand("Start-Process -FilePath \"DisplaySwitch.exe\" -ArgumentList \"/internal\""); }
            if (!scriptrunning && string.IsNullOrEmpty(errormessage)) { ExecutePowershellCommand("Start-Sleep -Seconds 2"); }
            if (!scriptrunning && string.IsNullOrEmpty(errormessage)) { ExecutePowershellCommand("Start - Process - FilePath \"DisplaySwitch.exe\" - ArgumentList \"/extend\""); }
            if (!scriptrunning && string.IsNullOrEmpty(errormessage)) { ButtonFinishHandler(button, true); }
            if (!string.IsNullOrEmpty(errormessage)) { Debug.WriteLine("Error || " + function_tracker + " || " + errormessage); }
            return;
        }
        private void FixUpdates(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            if (!scriptrunning && string.IsNullOrEmpty(errormessage)) { ButtonClickHandler(button); }
            if (!scriptrunning && string.IsNullOrEmpty(errormessage)) { ExecutePowershell(fix_windowsupdate); }
            if (!scriptrunning && string.IsNullOrEmpty(errormessage)) { ExecuteCMDCommand("sfc /scannow"); }
            if (!scriptrunning && string.IsNullOrEmpty(errormessage)) { ExecuteCMDCommand("DISM /online /cleanup-image /restorehealth"); }
            if (!scriptrunning && string.IsNullOrEmpty(errormessage)) { ButtonFinishHandler(button, false); }
            if (!string.IsNullOrEmpty(errormessage)) { Debug.WriteLine("Error || " + function_tracker + " || "  + errormessage); }
            return;
        }
    }
}
