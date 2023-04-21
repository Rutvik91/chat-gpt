import 'dart:async';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseController extends GetxController {
  RxBool proUser = false.obs;
  List<StoreProduct> products = [];
  List<StoreProduct> tempList = [];
  EntitlementInfo? customerInfo;
  RxInt selectedIndex = 0.obs;
  RxBool loading = false.obs;
  String ip = '';

  @override
  void onInit() async {
    await fetchSubscriptions();
    await updateCustomerInfo();
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      updateCustomerInfo();
    });

    super.onInit();
  }

  Future printIps() async {
    final ipv4 = await Ipify.ipv4();
    ip = ipv4;
    print(ipv4); // 98.207.254.136
  }

  updateCustomerInfo() async {
    try {
      final cusrtomerInfo = await Purchases.getCustomerInfo();
      final entitlement = cusrtomerInfo.entitlements.active['proUser'];
      proUser.value = entitlement != null;
      customerInfo = entitlement;
    } catch (e) {
      showAppSnackBar(e.toString());
    }
  }

  fetchSubscriptions() async {
    try {
      List<StoreProduct> response =
          await Purchases.getProducts(["weekly", "monthly", "yearly"]);
      products = response;
      print(products);
      // await Purchases.getOfferings().then((value) => print(value.toJson()));
    } catch (e) {
      showAppSnackBar(e.toString());
    }
  }

  Future<bool> purchase(String productIdentifier) async {
    loading.value = true;
    try {
      var value = await Purchases.purchaseProduct('weekly');
      final entitlement = value.entitlements.active['proUser'];
      loading.value = false;
      return entitlement != null;
    } catch (e) {
      showAppSnackBar(e.toString());
      loading.value = false;
      return false;
    }
  }

  showAppSnackBar(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}
