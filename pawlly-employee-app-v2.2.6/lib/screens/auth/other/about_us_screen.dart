import '../../../../utils/library.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.about,
      body: Column(
        children: [
          ListView.separated(
            itemCount: aboutPages.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (aboutPages[index].name.isEmpty || aboutPages[index].url.isEmpty) {
                return const SizedBox();
              } else {
                return SettingItemWidget(
                  title: aboutPages[index].name,
                  onTap: () {
                    commonLaunchUrl(aboutPages[index].url, launchMode: LaunchMode.externalApplication);
                  },
                  titleTextStyle: primaryTextStyle(),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                );
              }
            },
            separatorBuilder: (context, index) => commonDivider,
          ),
        ],
      ),
    );
  }
}
