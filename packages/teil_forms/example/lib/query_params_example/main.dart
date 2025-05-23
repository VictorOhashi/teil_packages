import 'dart:developer' as dev;

import 'package:example/common/common.dart';
import 'package:example/query_params_example/controllers/controllers.dart';
import 'package:example/query_params_example/models/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teil_forms/teil_forms.dart';

final routes = [
  GoRoute(
    path: '/query-params',
    builder: (context, state) => const _QueryParamsCaseExample(),
  ),
];

class _QueryParamsCaseExample extends StatefulWidget {
  const _QueryParamsCaseExample();

  @override
  State<_QueryParamsCaseExample> createState() => _QueryParamsCaseExampleState();
}

class _QueryParamsCaseExampleState extends State<_QueryParamsCaseExample> {
  @override
  Widget build(BuildContext context) {
    return FormBuilder.async(
      controller: () {
        final uri = GoRouterState.of(context).uri;
        return QueryParamsFormController.fromUri(uri);
      },
      loadingBuilder: (context) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      builder: (context, controller) => _FormPage(controller: controller),
    );
  }
}

class _FormPage extends StatelessWidget {
  final QueryParamsFormController controller;

  const _FormPage({required this.controller});

  void _formSubmitted(BuildContext context) {
    final queryParams = QueryParamsExampleModel(
      email: controller.email.value,
      company: KeyValueModel.fromEntity(controller.company.value),
      agreeTerms: controller.agreeTerms.value,
    );

    final route = GoRouterState.of(context).uri;
    final newRoute = route.replace(queryParameters: {'filter': queryParams.toBase64()});
    dev.log('New Uri: $newRoute');

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Url updated')));
    // Ignored for example purposes
    // ignore: inference_failure_on_function_invocation
    GoRouter.of(context).replace(newRoute.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Query Params Example')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 24,
            children: [
              TextFieldExample(field: controller.email, label: 'Email'),
              SearchFieldExample(
                field: controller.company,
                label: 'Company',
                suggestionsFetcher: (controller, _) =>
                    FakerService.instance.fetchCompanies(controller.text),
              ),
              CheckboxFieldExample(
                field: controller.agreeTerms,
                label: 'Agree to terms',
              ),
              const CardFormDetail(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FormBottomActions(onSubmit: () => _formSubmitted(context)),
      ),
    );
  }
}
