import 'package:connie/forms/expense_form.dart';
import 'package:connie/pages/categories/categories_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _openCreateRecordDialog() async {
    Get.dialog(AlertDialog.adaptive(
      content: ExpenseForm(
        onSubmit: () {},
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connie"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () => Get.to(() => const CategoriesOverviewPage()),
              icon: const Icon(Icons.category),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_alt),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bar_chart),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateRecordDialog,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "1 924 Kč",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Actual balance"),
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "-834 Kč",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Weekly spendings"),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.redAccent,
            ),
            title: Text(
              "- 38 Kč",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Nákup"),
            trailing: Text("15.2. 10:31"),
          ),
          ListTile(
            leading: Icon(Icons.savings),
            title: Text("+ 180 Kč"),
            subtitle: Text("Kapesné"),
            trailing: Text("15.2. 10:31"),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("- 38 Kč"),
            subtitle: Text("Nákup"),
            trailing: Text("15.2. 10:31"),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("- 38 Kč"),
            subtitle: Text("Nákup"),
            trailing: Text("15.2. 10:31"),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("- 38 Kč"),
            subtitle: Text("Nákup"),
            trailing: Text("15.2. 10:31"),
          ),
        ],
      ),
    );
  }
}
