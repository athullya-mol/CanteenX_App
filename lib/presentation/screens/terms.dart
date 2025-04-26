import 'package:CanteenX/application/blocs/terms/terms_bloc.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/presentation/widgets/custom_appbar.dart';
import 'package:CanteenX/presentation/widgets/settings_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CanteenX/core/extensions/extensions.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  void initState() {
    context.read<TermsBloc>().add(
          GetTermsEvent(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: "Terms of Service"),
      body: BlocBuilder<TermsBloc, TermsState>(
        builder: (context, state) {
          if (state is TermsError) {
            return Center(
              child: Text(
                "error loading info",
                style: AppText.h3b,
              ),
            );
          } else if (state is TermsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TermsLoaded) {
            return Padding(
              padding: Space.hf(1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Space.yf(1.5),
                  Text(
                    StringCapitalizeExtension(state.terms.header1).capitalize(),
                    style: AppText.h3b?.copyWith(height: 2),
                  ),
                  verseText(
                    text: state.terms.subheader1,
                    withPadding: false,
                  ),
                  Space.yf(1.5),
                  Text(
                    StringCapitalizeExtension(state.terms.header2).capitalize(),
                    style: AppText.h3b?.copyWith(height: 2),
                  ),
                  verseText(
                    text: state.terms.subheader2,
                    withPadding: false,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
