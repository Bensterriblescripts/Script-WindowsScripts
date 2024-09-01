using System;
using Microsoft.Win32;

namespace Script_Runner;

public static class ContextMenu {
    private const String exec_path = @"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe";
    private const String name = "Search CRM";
    private const Boolean addtofiles = false;
    private const Boolean addtoobjects = true;

    // Starting Point
    public static void CreateMenu(Boolean action) {

        // Add the ContextMenu Item
        if (action) {
            Boolean result = InstallContextMenuItem(exec_path, name, addtofiles, addtoobjects);
        }
        // Remove the ContextMenu Item
        // else {
        //     Boolean result = UninstallContextMenuItem(exec_path);
        // }
    }
    
    // Install New Item
    private static Boolean InstallContextMenuItem(String path, String name, Boolean files, Boolean objects) {
        try {

            if (files) {
                // Add Menu Item for All File Types
                using (RegistryKey key = Registry.CurrentUser.CreateSubKey(@"*\shell\SearchGoogle")) {
                    if (key == null) {
                        Console.WriteLine("Error creating subkey for files.");
                        return false;
                    }

                    key.SetValue("", name);
                    // key.SetValue("Icon", iconPath);
                }

                using (RegistryKey key = Registry.CurrentUser.CreateSubKey(@"*\shell\SearchGoogle\command")) {
                    if (key == null) {
                        Console.WriteLine("Error adding command to new subkey for all files.");
                        return false;
                    }

                    key.SetValue("", $"\"{path}\" \"%1\"");
                }
            }

            if (objects) {
                // Add menu item for selected text
                using (RegistryKey key =
                       Registry.CurrentUser.CreateSubKey(@"AllFilesystemObjects\shell\SearchGoogle")) {
                    if (key == null) {
                        Console.WriteLine("Error creating subkey for objects.");
                        return false;
                    }

                    key.SetValue("", name);
                    // key.SetValue("Icon", iconPath);
                }

                using (RegistryKey key =
                       Registry.CurrentUser.CreateSubKey(@"AllFilesystemObjects\shell\SearchGoogle\command")) {
                    if (key == null) {
                        Console.WriteLine("Error adding command to new subkey for objects.");
                        return false;
                    }

                    key.SetValue("", $"\"{path}\" \"%1\"");
                }
            }

            Console.WriteLine($"Added context menu item: {name}");
            return true;
        }
        catch (Exception ex) {
            Console.WriteLine($"Exception while adding registry entries: {ex.Message}");
            return false;
        }
    }
}