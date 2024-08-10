using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using System;
using System.Diagnostics;

namespace Script_Runner
{
    public sealed partial class MainWindow : Window
    {
        // Public Variables
        public bool scriptrunning = false;
        public string errormessage = string.Empty;
        public string function_tracker = string.Empty;
        // Variables
        string buttoncontent = string.Empty;

        // Classes
        Execute execute = new Execute();

        // Script paths
        string fix_windowsupdate = "C:\\Repositories\\Script-WindowsScripts\\Fix Windows Update.ps1";
        string fix_rightclick = "C:\\Repositories\\Script-WindowsScripts\\Restore Right-Click Context Menu.ps1";

        public MainWindow() {
            Console.WriteLine("Launching...");
            this.InitializeComponent();
        }

        // Button On-Click
        private async void ButtonClickHandler (Button button) {
            function_tracker = "ButtonClickHandler";

            // Just in case
            if (button == null) {
                errormessage = "Button is null.";
                return;
            }
            // Handle simultaneous scripts or errors
            if (scriptrunning) {
                errormessage = "A script is already running";
                // Add a 'queue' system here - do not async/overlap
                return;
            }
            else if (string.IsNullOrEmpty(errormessage)) {
                return;
            }

            // Change the button description
            if (button.Content != null) {
                buttoncontent = button.Content as string;
                button.Content = "Running...";
                button.IsEnabled = false;
            }
        }
        // Button Finish
        private void ButtonFinishHandler (Button button, bool opt) {
            function_tracker = "ButtonFinishHandler";

            if (button.Content != null) {

                // Re-enables button and replace button text
                if (opt && string.IsNullOrEmpty(errormessage)) {
                    button.IsEnabled = true;
                    button.Content = "Run Again";
                }
                else if (opt && !string.IsNullOrEmpty(errormessage)) {
                    button.IsEnabled = true;
                    button.Content = "Retry";
                }
                else if (string.IsNullOrEmpty(errormessage)) {
                    button.Content = "Finished";
                }
                else { 
                    button.Content = "Error";
                }
            }

            errormessage = string.Empty;
        }

        // Button Triggers
        private void FixRefreshMonitors(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            ButtonClickHandler(button);
            execute.ExecutePowershellCommand("Start-Process -FilePath \"DisplaySwitch.exe\" -ArgumentList \"/internal\"", this);
            execute.ExecutePowershellCommand("Start-Sleep -Seconds 2", this);
            execute.ExecutePowershellCommand("Start - Process - FilePath \"DisplaySwitch.exe\" - ArgumentList \"/extend\"", this);
            if (!string.IsNullOrEmpty(errormessage)) { Debug.WriteLine("Error || " + function_tracker + " || " + errormessage); }
            ButtonFinishHandler(button, true);
        }
        private void FixUpdates(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            ButtonClickHandler(button);
            execute.ExecutePowershell(fix_windowsupdate, this);
            execute.ExecuteCMDCommand("sfc /scannow", this);
            execute.ExecuteCMDCommand("DISM /online /cleanup-image /restorehealth", this);
            Debug.WriteLine("Error || " + function_tracker + " || "  + errormessage);
            ButtonFinishHandler(button, false);
        }
        private void FixRightClick(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            ButtonClickHandler(button);
            execute.ExecutePowershell(fix_rightclick, this);
            Debug.WriteLine("Error || " + function_tracker + " || " + errormessage);
            ButtonFinishHandler(button, false);
        }
    }
}
