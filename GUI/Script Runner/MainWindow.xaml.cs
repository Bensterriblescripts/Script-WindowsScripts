using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Controls.Primitives;
using Microsoft.UI.Xaml.Data;
using Microsoft.UI.Xaml.Input;
using Microsoft.UI.Xaml.Media;
using Microsoft.UI.Xaml.Navigation;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.Storage.Pickers.Provider;
using System.Threading.Tasks;

namespace Script_Runner
{

    public sealed partial class MainWindow : Window
    {
        // Variables
        bool debug = true;
        string errormessage = string.Empty;
        bool scriptrunning = false;

        // Script paths
        string refresh_monitors = "C:\\Repositories\\Script-WindowsScripts\\Refresh Monitors.ps1";
        string fix_windowsupdate = "C:\\Repositories\\Script-WindowsScripts\\Fix Windows Update.ps1";

    
        public MainWindow() {
            Console.WriteLine("Running...");
            try {
                this.InitializeComponent();
            }
            catch (Exception e) {
                Console.WriteLine("Error during execution: " + e.Message);
            }
        }

        // Button Click Script Handler
        public async Task ButtonScriptClick(Button button, string path, bool opt) {

            // Change the button state
            if (button != null) {

                // Change the button description
                string buttoncontent = string.Empty;
                if (button.Content != null) { 
                    buttoncontent = button.Content as string;
                    button.Content = "Processing...";
                }
                button.IsEnabled = false;

                // Run the script
                await ExecuteScript(path);
                if (!string.IsNullOrEmpty(errormessage)) {
                    button.Content = "Failed";
                    Debug.WriteLine("Script failed with error: " + errormessage);
                }

                // Re-enable the button if the option is on
                if (opt) {
                    button.Content = buttoncontent;
                    button.IsEnabled = true;
                }
                else {
                    button.Content = "Finished";
                }
            }
            else {
                Debug.WriteLine("Button is null");
            }
            return;
        }

        // Run a PowerShell Script
        private async Task ExecuteScript(string path) {

            // Make sure the script exists
            if (!File.Exists(path)) {
                Debug.WriteLine("File does not exist in path: " + path);
                scriptrunning = false;
                return;
            }

            // Start the process information
            ProcessStartInfo startInfo = new ProcessStartInfo();
            Debug.WriteLine("Starting the process information...");
            Debug.WriteLine("Process path set to: " + path);
            startInfo.FileName = "powershell.exe";
            startInfo.Arguments = $"-ExecutionPolicy Unrestricted -File \"{path}\"";
            startInfo.RedirectStandardOutput = true; // Move output to IOStream
            startInfo.RedirectStandardError = true; // Move errors to IOStream
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
                        Debug.WriteLine("Process did not start.");
                        errormessage = "Script failed to start.";
                        return;
                    }

                    // Run the script
                    Debug.WriteLine("Awaiting async...");
                    string output = await process.StandardOutput.ReadToEndAsync();
                    string error = await process.StandardError.ReadToEndAsync();
                    process.WaitForExit();

                    // Check return state
                    int exitcode = process.ExitCode;
                    if (exitcode != 0) {
                        Debug.WriteLine("Script failed with the error: " + error);
                        errormessage = "Script failed.";
                        return;
                    }

                    Debug.WriteLine("Script ran sucessfully");
                    Debug.WriteLine("Output: " + output);
                    return;
                }
            }
            catch (Exception e) {
                Debug.WriteLine("Script failed with an exception: " + e.Message);
                scriptrunning = false;
                return;
            }
            finally {
                scriptrunning = false;
            }
        }

        // Button Triggers
        private async void FixRefreshMonitors(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            if (!scriptrunning) { await ButtonScriptClick(button, refresh_monitors, true); }
            return;
        }
        private async void FixUpdates(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            if (!scriptrunning) { await ButtonScriptClick(button, fix_windowsupdate, false); }
            return;
        }
    }
}
