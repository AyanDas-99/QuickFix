import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickfix/state/product/models/description.dart';
import 'package:quickfix/state/product/models/product_payload.dart';
import 'package:quickfix/state/product/respositories/add_product.dart';
import 'package:quickfix/state/utils/pick_image.dart';

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  double totalprogress = 0;
  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(addProductProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            title: Text('Add product'),
            tileColor: Colors.white30,
            trailing: Icon(Icons.navigate_next),
            onTap: () async {
              final images = await PickImage.pickImages(3);
              print(images);
              final payload = ProductPayload(
                  name: 'Iphone 14 Pro Max',
                  images: images,
                  description: [
                    Description(
                        title: 'Display',
                        description: 'Amoled + display with 5000 colors')
                  ],
                  mrp: 150000,
                  price: 70000,
                  stock: 1);
              ref.read(addProductProvider.notifier).addNewProduct(
                  payload: payload,
                  onImageUploadLoading: (progress) {
                    final prog = (progress / 300) * 100;
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
        ],
      ),
    );
  }
}
