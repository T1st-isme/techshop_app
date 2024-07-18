// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// 🌎 Project imports:
import 'package:techshop_app/Routes/app_pages.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/module/WishList/Controller/wish_list_controller.dart';
import 'package:techshop_app/module/WishList/Views/wish_list_empty_view.dart';

class WishListView extends StatefulWidget {
  const WishListView({super.key});

  @override
  _WishListViewState createState() => _WishListViewState();
}

class _WishListViewState extends State<WishListView> {
  final _wishListController = Get.find<WishListController>();
  final _cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _wishListController.getWishList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách yêu thích',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_wishListController.status.value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_wishListController.status.value.isError) {
          return Center(
              child: Text(
                  'Lỗi: ${_wishListController.status.value.errorMessage}'));
        }
        if (_wishListController.wishList.isEmpty) {
          return const WishListEmptyView();
        }
        final wishList = _wishListController.wishList;

        return ListView.builder(
          itemCount: wishList.length,
          itemBuilder: (context, index) {
            final item = wishList[index];
            //format date
            final formattedDate =
                DateFormat('dd/MM/yyyy').format(DateTime.parse(item.addedAt!));
            //format price
            final formatter = NumberFormat('#,###', 'vi_VN');
            final value = item.product!.price!.$numberDecimal!;
            final formatPrice = formatter.format(double.parse(value) * 1000000);

            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.PRODUCTDETAIL,
                    parameters: {'slug': item.product!.slug!});
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        item.product!.proImg != null &&
                                item.product!.proImg!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: item.product!.proImg!.first.img ?? '',
                                width: 50,
                                height: 50,
                              )
                            : const Icon(Icons.image, size: 50),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product!.name ?? 'No Name',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('Giá: $formatPrice ₫'),
                              Text('Ngày thêm: $formattedDate'),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: const FaIcon(
                                  FontAwesomeIcons.heartCircleXmark,
                                  color: Colors.red),
                              onPressed: () {
                                _wishListController
                                    .removeFromWishList(item.product!.sId!);
                              },
                            ),
                            const SizedBox(height: 8),
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.cartPlus,
                                color: Color.fromARGB(255, 162, 95, 230),
                              ),
                              onPressed: () {
                                _cartController.addToCart([
                                  {'product': item.product!.sId, 'quantity': 1}
                                ]);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
