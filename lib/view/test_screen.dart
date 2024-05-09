import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/admin/order/repository/order_repository.dart';
import 'package:quickfix/state/models/shipping_address.dart';
import 'package:quickfix/state/order/models/order_status.dart';
import 'package:quickfix/state/product/models/description.dart';
import 'package:quickfix/state/product/models/product_payload.dart';
import 'package:quickfix/state/product/respositories/add_product.dart';
import 'package:quickfix/state/providers/scaffold_messenger.dart';
import 'package:quickfix/state/user/repositories/update_user.dart';
import 'package:quickfix/state/utils/pick_image.dart';

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  final formkey = GlobalKey<FormState>();

  // Update address
  Future<void> updateAddress() async {
    if (!formkey.currentState!.validate()) {
      return;
    }
    final address = ShippingAddress(
      street: streetController.text,
      city: cityController.text,
      state: stateController.text,
      pincode: pincodeController.text,
      houseNo: houseNoController.text,
      landmark: landmarkController.text,
    );

    final isUpdated = await ref
        .read(updateUserRepositoryProvider.notifier)
        .updateAddress(address);
    if (isUpdated) {
      ref.read(scaffoldMessengerProvider).showSnackBar(
          const SnackBar(content: Text('Shipping address updated!')));
    } else {
      ref.read(scaffoldMessengerProvider).showSnackBar(
          const SnackBar(content: Text('Shipping address update failed!')));
    }
  }

  // controllers for address
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final houseNoController = TextEditingController();
  final landmarkController = TextEditingController();
  // controller for order status update
  final orderIdController = TextEditingController();

  double totalprogress = 0;
  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(addProductProvider);

    final userUpdateLoading = ref.watch(updateUserRepositoryProvider);
    final orderUpdateLoading = ref.watch(orderRepositoryProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Add product'),
              tileColor: Colors.white30,
              trailing: const Icon(Icons.navigate_next),
              onTap: () async {
                final images = await PickImage.pickImages(3);
                print(images);
                if (images.isEmpty) return;
                final payload = ProductPayload(
                    categories: ['Phone'],
                    name: '(Refurbished) Iphone Charger | 120W',
                    images: images,
                    description:
                        'Original Iphone charger refurbished, In good condition and charges Iphone 12 to 100%  in 30 mins.',
                    detail: [
                      Detail(title: 'Power', description: '120 W'),
                      Detail(title: 'Color', description: 'White'),
                      Detail(title: 'Cord', description: '1 Mtr, anti-tangle'),
                    ],
                    mrp: 5000,
                    price: 2000,
                    stock: 1);
                ref.read(addProductProvider.notifier).addNewProduct(
                    payload: payload,
                    onImageUploadLoading: (progress) {
                      final prog = (progress / (images.length * 100)) * 100;
                      print("Uploading....uploading....uploading");
                      setState(() {
                        totalprogress = prog;
                      });
                    });
              },
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            if (loading)
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.blueGrey.shade100,
                height: 10,
                child: Row(
                  children: [
                    Container(
                      width: 1,
                      height: 5,
                      color: Colors.blue,
                    ).animate().scaleX(
                        begin: 0,
                        end: MediaQuery.of(context).size.width *
                            (totalprogress / 100) *
                            2),
                  ],
                ),
              ),
            Text(totalprogress.toString()),
            if (loading) const CircularProgressIndicator(),
            const Divider(height: 10),
            Form(
              key: formkey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'House number cannot be empty';
                      }
                      return null;
                    },
                    controller: streetController,
                    decoration: const InputDecoration(
                        hintText: 'House no. | Flat no. | Building name'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Landmark cannot be empty';
                      }
                      return null;
                    },
                    controller: cityController,
                    decoration: const InputDecoration(
                        hintText: 'Landmark. Eg - Near shiv Mandir'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Street cannot be empty';
                      }
                      return null;
                    },
                    controller: streetController,
                    decoration: const InputDecoration(hintText: 'Street'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'City cannot be empty';
                      }
                      return null;
                    },
                    controller: cityController,
                    decoration: const InputDecoration(hintText: 'City'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'State cannot be empty';
                      }
                      return null;
                    },
                    controller: stateController,
                    decoration: const InputDecoration(hintText: 'State'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pincode cannot be empty';
                      }
                      return null;
                    },
                    controller: pincodeController,
                    decoration: const InputDecoration(hintText: 'Pincode'),
                  ),
                  TextButton(
                      onPressed: userUpdateLoading ? null : updateAddress,
                      child: userUpdateLoading
                          ? const CircularProgressIndicator()
                          : const Text('Update address')),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // Update orderstatus
            Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: orderIdController,
                      ),
                    ),
                    DropdownButton(
                      items: OrderStatus.values
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        ref
                            .read(orderRepositoryProvider.notifier)
                            .updateOrderStatus(
                                orderId: orderIdController.text,
                                orderStatus: value!);
                      },
                    ),
                  ],
                ),
                if (orderUpdateLoading)
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                    child: const CircularProgressIndicator(),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
