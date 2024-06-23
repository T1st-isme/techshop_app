import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Category/Controller/category_controller.dart';

class CategoryList extends StatelessWidget {
  final _categoryController = Get.find<CategoryController>();

  CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_categoryController.status.value.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (_categoryController.status.value.isError) {
        return const Center(
          child: Text('Error'),
        );
      } else {
        return ListView.builder(
          shrinkWrap: true,
          itemCount:
              _categoryController.category.value.categoryList?.length ?? 0,
          itemBuilder: (context, index) {
            return Material(
              color: Colors.redAccent,
              child: ListTile(
                // onTap: () {
                //   Get.toNamed('/product', parameters: {
                //     'slug': _categoryController
                //         .category.value.categoryList![index].slug
                //   });
                // },
                title: Text(_categoryController
                        .category.value.categoryList![index].name ??
                    'No name'),
              ),
            );
          },
        );
      }
    });
  }
}
