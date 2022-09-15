import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hohodidi_user/app_constants/colors.dart';
import 'package:hohodidi_user/app_utils/custom_tab_indicator.dart';
import 'package:hohodidi_user/app_utils/sliver_app_delegete.dart';
import 'package:hohodidi_user/data_models/responses/product_list_response.dart';
import 'package:hohodidi_user/ui/check_out/check_out_screen.dart';
import 'package:hohodidi_user/ui/product/description_page.dart';
import 'package:hohodidi_user/ui/product/item_gallery_page.dart';
import 'package:hohodidi_user/ui/product/review_page.dart';
import 'package:hohodidi_user/ui/product/shop_info_screen.dart';
import 'package:hohodidi_user/view_model/product_provider.dart';
import 'package:hohodidi_user/widgets/section_view/section_view_item_detail_header.dart';
import 'package:hohodidi_user/widgets/widget_cart_quantity_badge.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  static const routeName = '/product_detail_screen';
  final Product product;

  const ItemDetailScreen(this.product, {Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<ProductCategories> productCategories = [
    ProductCategories(1, "Description"),
    ProductCategories(2, "Shop Info"),
    ProductCategories(3, "Gallery"),
    ProductCategories(4, "Rating and Review"),

  ];

  Product get product => widget.product;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) => DefaultTabController(
          length: _tabController!.length,
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    toolbarHeight: kToolbarHeight,
                    title: const Text("Item Detail"),
                    titleSpacing: 0,
                    centerTitle: false,
                    foregroundColor: Colors.white,
                    backgroundColor: PRIMARY_COLOR,
                    elevation: 0,
                    pinned: true,
                    actions: [
                      CartQuantityBadgeWidget(
                        onPressed: () => Navigator.pushNamed(context, CheckOutScreen.routeName),
                      ),
                    ],
                  ),
                  ItemDetailHeaderSectionView(item: product),
                  SliverPersistentHeader(
                    delegate: SliverAppBarDelegate(
                        TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: TEXT_COLOR_BLACK,
                          indicator: const CustomTabIndicator(),
                          tabs: productCategories
                              .map(
                                (item) => Tab(
                                  height: 52,
                                  text: item.categoryName,
                                ),
                              )
                              .toList(),
                        ),
                        height: 54),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: productCategories
                    .map((item) => getTabBarView(item.categoryId))
                    .toList(),
              )),
        ),
      ),
    );
  }

  Widget getTabBarView(int categoryId) {
    if (categoryId == 1) {
      return  DescriptionPage(description:  product.description??"");
    } else if (categoryId == 2) {
      return ShopInfoScreen(product.shop!);
    } else if (categoryId == 3) {
      return ItemGalleryPage(photos: product.gallery!);
    } else if (categoryId == 4) {
      return ReviewPage(product.id!);
    } else {
      return Container();
    }
  }
}

class ProductCategories {
  int categoryId;
  String categoryName;

  ProductCategories(this.categoryId, this.categoryName);
}
