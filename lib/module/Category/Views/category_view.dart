import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Category/Controller/category_controller.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final _categoryController = Get.find<CategoryController>();

  @override
  initState() {
    super.initState();
    _categoryController.getCategories();
  }

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
              height: 80,
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
                        // print(
                        //     '${_categoryController.category.value.categoryList![index].sId}');
                        Get.toNamed('/product', arguments: {
                          'category': _categoryController
                              .category.value.categoryList![index].sId,
                        });
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
