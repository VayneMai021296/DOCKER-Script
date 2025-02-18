using Avalonia.Controls;
using Avalonia.Interactivity;

namespace MyAvaloniaApp;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
    }
    private void OnClick(object? sender, RoutedEventArgs e)
        {
            var messageBox = new Window
            {
                Content = new TextBlock
                {
                    Text = "Button Clicked! The first Avalonia app",
                    HorizontalAlignment = Avalonia.Layout.HorizontalAlignment.Center,
                    VerticalAlignment = Avalonia.Layout.VerticalAlignment.Center
                },
                Width = 200,
                Height = 100
            };
            messageBox.Show();
        }
}