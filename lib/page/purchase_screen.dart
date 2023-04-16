import 'package:aichat/page/purchase_controller.dart';
import 'package:aichat/utils/Config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchaseScreen extends StatelessWidget {
  PurchaseScreen({super.key});

  final PurchaseController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Config.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.workspace_premium_outlined,
                        color: Colors.white),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      Config.appName,
                      style: const TextStyle(
                        color: Config.primary2,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Text(
                      'By Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear, color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.75),
                    )
                  ],
                  color: Config.primary2),
              child: const Center(
                child: Text(
                  'Introductory Offer',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'What you will get?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.only(left: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 6,
                        width: 6,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Unlimited Questions and Answers',
                        style: TextStyle(
                          color: Config.primary2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 6,
                        width: 6,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Unlimited Usages*',
                        style: TextStyle(
                          color: Config.primary2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 6,
                        width: 6,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'All pro features unlocked',
                        style: TextStyle(
                          color: Config.primary2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ...List.generate(
              _controller.products.length,
              (index) => Obx(
                () => GestureDetector(
                  onTap: () {
                    _controller.selectedIndex.value = index;
                  },
                  behavior: HitTestBehavior.opaque,
                  child: subscriptionWidget(
                    isActive: _controller.selectedIndex.value == index,
                    name: _controller.products[index].title,
                    amount: _controller.products[index].priceString,
                    subTitle: _controller.products[index].description,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                _controller.updateCustomerInfo();
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Config.primary2,
                  ),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 50.0,
                      offset: Offset(0.0, 0.75),
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Restore',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _controller.purchase('weekly');
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.75),
                      )
                    ],
                    color: Config.primary2),
                child: Obx(() {
                  return Center(
                    child: _controller.loading.value
                        ? Container(
                            height: 15,
                            width: 15,
                            child: const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : const Text(
                            'Purchase',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  );
                }),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Privacy policy',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
                const Text(
                  '|',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Terms of use',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget subscriptionWidget({
    required bool isActive,
    required String amount,
    required String name,
    required String subTitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      decoration: BoxDecoration(
        color: isActive ? Config.primary2 : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Config.primary2,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                ' / $name',
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Text(
            subTitle,
            style: TextStyle(
              color: isActive ? Colors.black54 : Colors.white70,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
