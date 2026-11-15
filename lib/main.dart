import 'package:flutter/material.dart';

void main() => runApp(const MadheshPatroApp());

const brand = Color(0xFF9F202A);
const gold = Color(0xFFE9A52A);
const forest = Color(0xFF243D35);

class MadheshPatroApp extends StatefulWidget {
  const MadheshPatroApp({super.key});
  @override
  State<MadheshPatroApp> createState() => _MadheshPatroAppState();
}

class _MadheshPatroAppState extends State<MadheshPatroApp> {
  bool english = false;
  bool dark = false;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Madhesh Patro',
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: brand), scaffoldBackgroundColor: const Color(0xFFFFF8ED)),
    darkTheme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: brand, brightness: Brightness.dark)),
    home: AppShell(english: english, dark: dark,
      toggleLanguage: () => setState(() => english = !english),
      toggleTheme: () => setState(() => dark = !dark)),
  );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.english, required this.dark, required this.toggleLanguage, required this.toggleTheme});
  final bool english, dark;
  final VoidCallback toggleLanguage, toggleTheme;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final en = widget.english;
    final pages = [
      HomePage(en: en, go: (v) => setState(() => tab = v)),
      CalendarPage(en: en),
      NewsPage(en: en),
      FestivalsPage(en: en),
      SettingsPage(en: en, dark: widget.dark, toggleLanguage: widget.toggleLanguage, toggleTheme: widget.toggleTheme),
    ];
    final labels = en ? ['Home', 'Calendar', 'News', 'Festivals', 'More'] : ['गृहपृष्ठ', 'पात्रो', 'समाचार', 'पर्वहरू', 'थप'];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: [
          for (var i = 0; i < labels.length; i++)
            NavigationDestination(
              icon: Icon([Icons.home_outlined, Icons.calendar_month_outlined, Icons.newspaper_outlined, Icons.celebration_outlined, Icons.grid_view_outlined][i]),
              selectedIcon: Icon([Icons.home, Icons.calendar_month, Icons.newspaper, Icons.celebration, Icons.grid_view][i]),
              label: labels[i],
            ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.en, required this.go});
  final bool en;
  final ValueChanged<int> go;
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return ListView(padding: const EdgeInsets.all(20), children: [
      Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.temple_hindu, color: Colors.white, size: 28)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('MADHESH PATRO', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1)),
          Text(en ? 'Your culture. Your calendar.' : 'तपाईंको संस्कृति, तपाईंको पात्रो'),
        ])),
        IconButton(onPressed: () => go(2), icon: const Icon(Icons.search)),
      ]),
      const SizedBox(height: 22),
      Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [brand, Color(0xFF741923)]), borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(en ? 'TODAY' : 'आजको दिन', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)), const Icon(Icons.wb_sunny_outlined, color: gold)]),
        const SizedBox(height: 12),
        Text('${now.day} ${monthName(now.month)} ${now.year}', style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800)),
        Text(weekdayName(now.weekday, en), style: const TextStyle(color: Colors.white70)),
        const Divider(color: Colors.white30, height: 28),
        Row(children: [
          Expanded(child: _dateLabel(en ? 'Nepali date' : 'नेपाली मिति', en ? 'Data integration pending' : 'पात्रो डाटा जडान हुँदैछ')),
          Expanded(child: _dateLabel(en ? 'Tithi / Panchang' : 'तिथि / पञ्चाङ्ग', en ? 'Verified data pending' : 'प्रमाणित डाटा जडान हुँदैछ')),
        ]),
      ])),
      const SizedBox(height: 24),
      _section(context, en ? 'Explore' : 'छिटो पहुँच'),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 4, childAspectRatio: .82, children: [
        _action(context, Icons.calendar_month, en ? 'Calendar' : 'पात्रो', brand, () => go(1)),
        _action(context, Icons.cloud_outlined, en ? 'Weather' : 'मौसम', forest, null),
        _action(context, Icons.auto_awesome, en ? 'Horoscope' : 'राशिफल', const Color(0xFF8054A2), null),
        _action(context, Icons.celebration, en ? 'Festivals' : 'पर्वहरू', const Color(0xFFB7791F), () => go(3)),
      ]),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _section(context, en ? 'Madhesh updates' : 'मधेशका समाचार'),
        TextButton(onPressed: () => go(2), child: Text(en ? 'See all' : 'सबै हेर्नुहोस्')),
      ]),
      _info(context, Icons.location_city, en ? 'Stories from eight districts' : 'मधेशका आठै जिल्लाका समाचार', en ? 'Local news and community updates.' : 'स्थानीय समाचार तथा समुदायका जानकारी।'),
      _info(context, Icons.palette_outlined, en ? 'Culture & heritage' : 'संस्कृति र सम्पदा', en ? 'Discover Madhesh traditions and arts.' : 'मधेशको मौलिक कला, संस्कृति र परम्परा।'),
    ]);
  }
}

Widget _dateLabel(String title, String value) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
  const SizedBox(height: 5),
  Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
]);

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.en});
  final bool en;
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}
class _CalendarPageState extends State<CalendarPage> {
  DateTime month = DateTime(DateTime.now().year, DateTime.now().month);
  @override
  Widget build(BuildContext context) {
    final en = widget.en;
    final count = DateTime(month.year, month.month + 1, 0).day;
    final offset = DateTime(month.year, month.month, 1).weekday % 7;
    final days = en ? ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'] : ['आइत', 'सोम', 'मङ्गल', 'बुध', 'बिही', 'शुक्र', 'शनि'];
    final today = DateTime.now();
    return ListView(padding: const EdgeInsets.all(20), children: [
      _heading(context, en ? 'Calendar' : 'नेपाली पात्रो', en ? 'Plan your days and remember what matters.' : 'आफ्ना दिन र महत्वपूर्ण अवसरहरू सम्झनुहोस्।'),
      const SizedBox(height: 18),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(onPressed: () => setState(() => month = DateTime(month.year, month.month - 1)), icon: const Icon(Icons.chevron_left)),
          Text('${monthName(month.month)} ${month.year}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          IconButton(onPressed: () => setState(() => month = DateTime(month.year, month.month + 1)), icon: const Icon(Icons.chevron_right)),
        ]),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 7, children: [
          for (final d in days) Center(child: Text(d, style: const TextStyle(color: brand, fontWeight: FontWeight.w800, fontSize: 12))),
          for (var i = 0; i < offset; i++) const SizedBox(),
          for (var d = 1; d <= count; d++)
            Center(child: Container(width: 36, height: 36, alignment: Alignment.center,
              decoration: d == today.day && month.month == today.month && month.year == today.year ? const BoxDecoration(color: brand, shape: BoxShape.circle) : null,
              child: Text('$d', style: TextStyle(color: d == today.day && month.month == today.month && month.year == today.year ? Colors.white : null, fontWeight: FontWeight.w700)))),
        ]),
        const Divider(),
        Text(en ? 'Gregorian preview. Verified Bikram Sambat, tithi and Panchang data will be connected in a later phase.' : 'यो ग्रेगोरियन पात्रोको प्रारम्भिक दृश्य हो। प्रमाणित विक्रम संवत्, तिथि र पञ्चाङ्ग डाटा अर्को चरणमा जोडिनेछ।'),
      ]))),
      const SizedBox(height: 16),
      _section(context, en ? 'Calendar tools' : 'पात्रोका सुविधा'),
      _info(context, Icons.swap_horiz, en ? 'BS ↔ AD converter' : 'वि.सं. ↔ ई.सं. मिति रूपान्तरण', en ? 'Convert between calendar systems' : 'दुवै पात्रोबीच मिति रूपान्तरण'),
      _info(context, Icons.event_available, en ? 'Events & holidays' : 'चाडपर्व तथा सार्वजनिक बिदा', en ? 'Upcoming festivals and important days' : 'आगामी पर्व र महत्वपूर्ण दिनहरू'),
    ]);
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key, required this.en});
  final bool en;
  @override
  State<NewsPage> createState() => _NewsPageState();
}
class _NewsPageState extends State<NewsPage> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    final districts = widget.en ? ['All', 'Saptari', 'Siraha', 'Dhanusha', 'Mahottari', 'Sarlahi', 'Rautahat', 'Bara', 'Parsa'] : ['सबै', 'सप्तरी', 'सिरहा', 'धनुषा', 'महोत्तरी', 'सर्लाही', 'रौतहट', 'बारा', 'पर्सा'];
    return ListView(padding: const EdgeInsets.all(20), children: [
      _heading(context, widget.en ? 'Madhesh News' : 'मधेश समाचार', widget.en ? 'Local stories from all eight districts.' : 'मधेशका आठै जिल्लाका स्थानीय समाचार।'),
      const SizedBox(height: 16),
      SizedBox(height: 42, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: districts.length, separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => ChoiceChip(label: Text(districts[i]), selected: selected == i, onSelected: (_) => setState(() => selected = i)))),
      const SizedBox(height: 18),
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(20)), child: Text(widget.en ? 'Connect your news CMS to publish verified local updates here.' : 'प्रमाणित स्थानीय समाचार प्रकाशित गर्न आफ्नो News CMS जोड्नुहोस्।', style: const TextStyle(color: Colors.white))),
      const SizedBox(height: 20),
      _empty(context, widget.en ? 'News feed is not connected yet' : 'समाचार फिड अझै जोडिएको छैन', widget.en ? 'PHP/MySQL news API integration is planned for a later phase.' : 'PHP/MySQL समाचार API अर्को चरणमा जोडिनेछ।'),
    ]);
  }
}

class FestivalsPage extends StatelessWidget {
  const FestivalsPage({super.key, required this.en});
  final bool en;
  @override
  Widget build(BuildContext context) {
    final entries = en
      ? [('Chhath Puja', 'A festival of faith, gratitude and Sun worship', Icons.wb_sunny), ('Vivah Panchami', 'Celebrating the wedding of Ram and Sita', Icons.favorite), ('Holi', 'The festival of colours and togetherness', Icons.color_lens), ('Jitiya', 'A cherished festival observed by mothers', Icons.diversity_3), ('Sama Chakeva', 'Sibling bonds and Mithila folk culture', Icons.people)]
      : [('छठ पर्व', 'आस्था, श्रद्धा र सूर्य उपासनाको पर्व', Icons.wb_sunny), ('विवाह पञ्चमी', 'राम–सीताको विवाह उत्सव', Icons.favorite), ('होली', 'रङ र सद्भावको पर्व', Icons.color_lens), ('जितिया', 'आमाहरूले श्रद्धापूर्वक मनाउने पर्व', Icons.diversity_3), ('सामा चकेवा', 'दाजुभाइ–दिदीबहिनीको प्रेम र लोकसंस्कृति', Icons.people)];
    return ListView(padding: const EdgeInsets.all(20), children: [
      _heading(context, en ? 'Culture & Festivals' : 'संस्कृति तथा पर्वहरू', en ? 'Celebrate the living heritage of Madhesh.' : 'मधेशको मौलिक संस्कृति र सम्पदा मनाऔँ।'),
      const SizedBox(height: 18),
      Container(height: 140, padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [forest, Color(0xFF426B57)]), borderRadius: BorderRadius.circular(22)), alignment: Alignment.bottomLeft, child: Text(en ? 'Mithila & Madhesh heritage' : 'मिथिला र मधेशको जीवन्त सम्पदा', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18))),
      const SizedBox(height: 18),
      for (final e in entries) _info(context, e.$3, e.$1, e.$2),
    ]);
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.en, required this.dark, required this.toggleLanguage, required this.toggleTheme});
  final bool en, dark;
  final VoidCallback toggleLanguage, toggleTheme;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    _heading(context, en ? 'More' : 'थप सुविधाहरू', en ? 'Personalize your Madhesh Patro experience.' : 'आफ्नो Madhesh Patro अनुभव अनुकूल बनाउनुहोस्।'),
    const SizedBox(height: 18),
    Card(child: ListTile(leading: const Icon(Icons.temple_hindu, color: brand), title: const Text('Madhesh Patro'), subtitle: const Text('Your Culture. Your Calendar. Your Madhesh.'))),
    SwitchListTile(secondary: const Icon(Icons.dark_mode_outlined), title: Text(en ? 'Dark mode' : 'डार्क मोड'), value: dark, onChanged: (_) => toggleTheme()),
    ListTile(leading: const Icon(Icons.language), title: Text(en ? 'App language' : 'एपको भाषा'), subtitle: Text(en ? 'English' : 'नेपाली'), trailing: const Icon(Icons.swap_horiz), onTap: toggleLanguage),
    _info(context, Icons.currency_exchange, en ? 'Exchange rates' : 'विदेशी मुद्रा विनिमय', en ? 'Daily exchange rates' : 'दैनिक विदेशी मुद्रा दर'),
    _info(context, Icons.radio, en ? 'Radio & FM' : 'रेडियो तथा एफएम', en ? 'Local radio stations' : 'स्थानीय रेडियो'),
    const SizedBox(height: 16),
    Center(child: Text('Madhesh Patro • Version 0.1.0', style: Theme.of(context).textTheme.bodySmall)),
  ]);
}

Widget _heading(BuildContext c, String title, String subtitle) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  Text(title, style: Theme.of(c).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
  const SizedBox(height: 5), Text(subtitle, style: Theme.of(c).textTheme.bodyMedium),
]);
Widget _section(BuildContext c, String title) => Text(title, style: Theme.of(c).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800));
Widget _action(BuildContext c, IconData icon, String label, Color color, VoidCallback? onTap) => InkWell(onTap: onTap ?? () => ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('This feature will be added in a later phase.'))), child: Column(children: [
  Container(width: 56, height: 56, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(17)), child: Icon(icon, color: color, size: 26)),
  const SizedBox(height: 6), Text(label, textAlign: TextAlign.center, style: Theme.of(c).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
]));
Widget _info(BuildContext c, IconData icon, String title, String subtitle) => Card(margin: const EdgeInsets.only(top: 10), child: ListTile(
  leading: Container(width: 44, height: 44, decoration: BoxDecoration(color: brand.withValues(alpha: .1), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: brand)),
  title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(subtitle),
));
Widget _empty(BuildContext c, String title, String message) => Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Theme.of(c).colorScheme.surfaceContainerHighest.withValues(alpha: .4), borderRadius: BorderRadius.circular(20)), child: Column(children: [
  const Icon(Icons.newspaper, size: 36), const SizedBox(height: 10), Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(message, textAlign: TextAlign.center),
]));
String monthName(int m) => const ['January','February','March','April','May','June','July','August','September','October','November','December'][m - 1];
String weekdayName(int d, bool en) => (en ? const ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'] : const ['सोमबार','मङ्गलबार','बुधबार','बिहीबार','शुक्रबार','शनिबार','आइतबार'])[d - 1];
