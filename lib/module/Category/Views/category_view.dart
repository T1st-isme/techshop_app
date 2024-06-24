import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Category/Controller/category_controller.dart';

class CategoryList extends StatelessWidget {
  final _categoryController = Get.find<CategoryController>();

  CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_categoryController.status.value.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (_categoryController.status.value.isError) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          return Center(
            child: SizedBox(
              height: 80, // You can adjust the height according to your needs
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    _categoryController.category.value.categoryList?.length ??
                        0,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AspectRatio(
                    aspectRatio: 1.25,
                    child: GestureDetector(
                      onTap: () {
                        // Handle your tap event here.
                        print('Category item tapped!');
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: Colors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: ClipOval(
                                  child: Image.network(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZ3aF4GtX_wOJ75UD0DAwM2yjUmzRIOO6ssA&s",
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                _categoryController
                                    .category.value.categoryList![index].name!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
