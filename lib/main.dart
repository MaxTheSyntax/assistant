import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'pages/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1100, 600),
    center: false,
    // backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const App());
  // windowManager.waitUntilReadyToShow().then((_) async {
  //   // await windowManager.setAsFrameless();
  //   await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  // });
  // doWhenWindowReady(() {
  //   appWindow.show();
  // });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'Assistant',
      theme: ThemeData(colorScheme: LegacyColorSchemes.darkZinc(), radius: 0.7),
      home: const RootPage(),
    );
  }
}

// class AppBarButton extends StatelessWidget {
//   const AppBarButton({super.key, required this.icon, required this.onPressed});

//   final IconData icon;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Button(size: ButtonSize.small, onPressed: onPressed, style: , child: Icon(icon));
//   }
// }

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class SidebarItem extends StatelessWidget implements NavigationBarItem {
  const SidebarItem({super.key, required this.text, required this.icon});

  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return NavigationItem(
      label: Text(text),
      alignment: Alignment.centerLeft,
      selectedStyle: const ButtonStyle.primaryIcon(),
      child: icon,
    );
  }

  @override
  bool get selectable => true;
}

class _RootPageState extends State<RootPage> {
  bool expanded = true;

  int selectedIndex = 0;

  // NavigationItem sidebarItem(String text, IconData icon) {
  //   // Convenience factory for a selectable navigation item with left alignment
  //   // and a primary icon style when selected.
  //   return NavigationItem(
  //     label: Text(text),
  //     alignment: Alignment.centerLeft,
  //     selectedStyle: const ButtonStyle.primaryIcon(),
  //     child: Icon(icon),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        DragToMoveArea(
          child: AppBar(
            title: const Text('Assistant'),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            height: 30,
            leading: [
              SecondaryButton(
                // size: ButtonSize.small,
                size: ButtonSize(0.85),
                child: const Icon(LucideIcons.menu),
                onPressed: () {
                  // Handle menu button press
                },
              ),
            ],
            trailing: [
              SecondaryButton(
                size: ButtonSize.small,
                child: const Icon(LucideIcons.minimize2),
                onPressed: () {
                  windowManager.minimize();
                },
              ),
              SecondaryButton(
                size: ButtonSize.small,
                child: const Icon(LucideIcons.maximize),
                onPressed: () {
                  windowManager.isMaximized().then((isMaximized) {
                    if (isMaximized) {
                      windowManager.unmaximize();
                    } else {
                      windowManager.maximize();
                    }
                  });
                },
              ),
              SecondaryButton(
                size: ButtonSize.small,
                child: const Icon(LucideIcons.x),
                onPressed: () {
                  windowManager.close();
                },
              ),
            ],
          ),
        ),
        // const Divider(height: 1),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NavigationRail(
            children: [SidebarItem(text: "Main", icon: Icon(LucideIcons.text))],
          ),
          const ChatPage(),
        ],
      ),
    );
  }
}
