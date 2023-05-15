import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/pages/search/filter_page.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:moqefapp/widgets/ads_widget.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    Key? key,
  }) : super(key: key);
  static const id = 'result_Page';
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Config.background,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Config.black)),
          title: Text(
            context.locale.results,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Config.black,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Ionicons.filter_outline, color: Config.black),
              onPressed: () {
                Navigator.pushNamed(context, FilterPage.id);
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SizedBox(
            height: screenSize(context).height,
            width: screenSize(context).width,
            child: SingleChildScrollView(
              child: Consumer<AdProvider>(builder: (context, ads, _) {
                if (ads.results.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: ads.results.length,
                    itemBuilder: (context, index) {
                      return AdsWidget(
                        ad: ads.results[index],
                      );
                    },
                  );
                } else {
                  return SizedBox(
                    height: screenSize(context).height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Config.no_ads,
                          height: 200,
                        )
                      ],
                    ),
                  );
                }
              }),
            )));
  }
}
