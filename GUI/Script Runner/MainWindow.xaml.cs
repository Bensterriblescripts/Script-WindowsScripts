using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using System;
using System.Diagnostics;
using System.Threading.Tasks;


namespace Script_Runner
{
    public sealed partial class MainWindow : Window {

        // Public Variables
        public bool scriptrunning = false;
        public string errormessage = string.Empty;
        public string function_tracker = string.Empty;
        // Variables
        string buttoncontent = string.Empty;

        // Classes
        Execute execute = new Execute();
        GenericFunctions func = new GenericFunctions();

        // Script paths
        string fix_windowsupdate = "C:\\Repositories\\Script-WindowsScripts\\Fix Windows Update.ps1";
        string fix_rightclick = "C:\\Repositories\\Script-WindowsScripts\\Restore Right-Click Context Menu.ps1";
        string fix_bingsearch = "C:\\Repositories\\Script-WindowsScripts\\Fix Bing Search.ps1";

        public MainWindow() {
            Console.WriteLine("Launching...");
            this.InitializeComponent();
        }

        // Button On-Click
        private void ButtonClickHandler (Button button) {
            function_tracker = "ButtonClickHandler";

            // Error handling
            if (button == null) {
                errormessage = "Button is null.";
                return;
            }
            if (scriptrunning) {
                errormessage = "A script is already running";
                // Add a 'queue' system here - do not async/overlap
                return;
            }
            else if (!string.IsNullOrEmpty(errormessage)) {
                return;
            }

            // Disable the button
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

        // Buttons
        private async void FixRefreshMonitors(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            ButtonClickHandler(button);
            await Task.Delay(500);

            execute.ExecutePowershellCommand("Start-Process -FilePath \"DisplaySwitch.exe\" -ArgumentList \"/internal\"", this);
            execute.ExecutePowershellCommand("Start-Sleep -Seconds 2", this);
            execute.ExecutePowershellCommand("Start-Process -FilePath \"DisplaySwitch.exe\" -ArgumentList \"/extend\"", this);
            if (!string.IsNullOrEmpty(errormessage)) { Debug.WriteLine("Error || " + function_tracker + " || " + errormessage); }
            ButtonFinishHandler(button, true);
        }
        private async void FixUpdates(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            ButtonClickHandler(button);
            await Task.Delay(500);

            execute.ExecutePowershellScript(fix_windowsupdate, this);
            execute.ExecuteCMDCommand("sfc /scannow", this);
            execute.ExecuteCMDCommand("DISM /online /cleanup-image /restorehealth", this);
            if (!string.IsNullOrEmpty(errormessage)) { Debug.WriteLine("Error || " + function_tracker + " || " + errormessage); }
            ButtonFinishHandler(button, false);
        }

        // Hot-Reload Buttons
        private async void FixRightClick(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            ButtonClickHandler(button);
            await Task.Delay(500);

            execute.ExecutePowershellScript(fix_rightclick, this);
            execute.ExecutePowershellState("Test-Path 'HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32'", button, this);
            
            await Task.Delay(500);
            func.BringToFront(this);
            if (!string.IsNullOrEmpty(errormessage)) { Debug.WriteLine("Error || " + function_tracker + " || " + errormessage); }
        }
        private async void FixBingSearch(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            ButtonClickHandler(button);
            await Task.Delay(500);

            await Task.Delay(500);
            execute.ExecutePowershellScript(fix_bingsearch, this);
            execute.ExecutePowershellState("(Get-ItemProperty -Path \"HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Search\" -Name \"BingSearchEnabled\" -ErrorAction SilentlyContinue).BingSearchEnabled", button, this);
            
            await Task.Delay(500);
            func.BringToFront(this);
            if (!string.IsNullOrEmpty(errormessage)) { Debug.WriteLine("Error || " + function_tracker + " || " + errormessage); }
        }

        // On-Load Buttons
        private async void RightClickButtonLoaded(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            execute.ExecutePowershellState("Test-Path 'HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32'", button, this);
            
            await Task.Delay(500);
            if (!string.IsNullOrEmpty(errormessage)) { Debug.WriteLine("Error || " + function_tracker + " || " + errormessage); }
        }
        private async void BingSearchButtonLoaded(object sender, RoutedEventArgs e) {
            Button button = sender as Button;
            execute.ExecutePowershellState("(Get-ItemProperty -Path \"HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Search\" -Name \"BingSearchEnabled\" -ErrorAction SilentlyContinue).BingSearchEnabled", button, this);

            await Task.Delay(500);
            if (!string.IsNullOrEmpty(errormessage)) { Debug.WriteLine("Error || " + function_tracker + " || " + errormessage); }
        }
    }
}
