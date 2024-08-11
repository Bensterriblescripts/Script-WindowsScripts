using Microsoft.UI.Windowing;
using WinRT.Interop;
using Microsoft.UI;
using System.Diagnostics;
using System;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace Script_Runner {
    public class GenericFunctions {

        [DllImport("user32.dll")]
        private static extern bool SetForegroundWindow(IntPtr hWnd);

        public void BringToFront (MainWindow main) {
            main.function_tracker = "BringToFront";

            IntPtr hWnd = WindowNative.GetWindowHandle(main);
            SetForegroundWindow(hWnd);
            Debug.WriteLine("Moved application to the foreground.");
        }
    }
}
